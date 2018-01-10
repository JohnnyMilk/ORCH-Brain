//
//  ProjectController.swift
//  ORCH-BrainPackageDescription
//
//  Created by Johnny Wang on 2017/12/27.
//

import Vapor
import HTTP

final class ProjectController: ProjectProtocol, ResourceRepresentable {
    // When users call 'GET' on '/projects'
    // it should return an index of all available projects
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try Project.all().makeJSON()
    }
    
    // When consumers call 'POST' on '/projects' with valid JSON
    // construct and save the project
    func store(_ req: Request) throws -> ResponseRepresentable {
        let project = try req.project()
        try project.save()
        return project
    }
    
    // When the consumer calls 'GET' on a specific resource, ie:
    // '/projects/1' we should show that specific project
    func show(_ req: Request, project: Project) throws -> ResponseRepresentable {
        return project
    }
    
    // When the consumer calls 'DELETE' on a specific resource, ie:
    // '/projects/1' we should remove that resource from the database
    func delete(_ req: Request, project: Project) throws -> ResponseRepresentable {
        try project.delete()
        return Response(status: .ok)
    }
    
    // When the consumer calls 'DELETE' on the entire table, ie:
    // '/projects' we should remove the entire table
    func clear(_ req: Request) throws -> ResponseRepresentable {
        try Project.makeQuery().delete()
        return Response(status: .ok)
    }
    
    // When the user calls 'PATCH' on a specific resource, we should
    // update that resource to the new values.
    func update(_ req: Request, project: Project) throws -> ResponseRepresentable {
        try project.update(for: req)
        try project.save()
        return project
    }
    
    func makeResource() -> Resource<Project> {
        return Resource(
            index: index,
            store: store,
            show: show,
            update: update,
            destroy: delete,
            clear: clear
        )
    }
}

extension Request {
    func project() throws -> Project {
        guard let json = json else { throw Abort.badRequest }
        return try Project(json: json)
    }
}

extension ProjectController: EmptyInitializable { }

