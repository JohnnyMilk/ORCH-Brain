//
//  ProjectResourceController.swift
//  ORCH-BrainPackageDescription
//
//  Created by Johnny Wang on 2018/1/3.
//

import Vapor
import HTTP

final class ProjectResourceController: ProjectResourceProtocol, ResourceRepresentable {
    // When users call 'GET' on '/projects'
    // it should return an index of all available projects
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try ProjectResource.all().makeJSON()
    }
    
    // When consumers call 'POST' on '/posts' with valid JSON
    // construct and save the project
    func store(_ req: Request) throws -> ResponseRepresentable {
        let projectResource = try req.project()
        try projectResource.save()
        return projectResource
    }
    
    // When the consumer calls 'GET' on a specific resource, ie:
    // '/projects/1' we should show that specific project
    func show(_ req: Request, projectResource: ProjectResource) throws -> ResponseRepresentable {
        return projectResource
    }
    
    // When the consumer calls 'DELETE' on a specific resource, ie:
    // '/projects/1' we should remove that resource from the database
    func delete(_ req: Request, projectResource: ProjectResource) throws -> ResponseRepresentable {
        try projectResource.delete()
        return Response(status: .ok)
    }
    
    // When the consumer calls 'DELETE' on the entire table, ie:
    // '/projects' we should remove the entire table
    func clear(_ req: Request) throws -> ResponseRepresentable {
        try ProjectResource.makeQuery().delete()
        return Response(status: .ok)
    }
    
    // When the user calls 'PATCH' on a specific resource, we should
    // update that resource to the new values.
    func update(_ req: Request, projectResource: ProjectResource) throws -> ResponseRepresentable {
        try projectResource.update(for: req)
        try projectResource.save()
        return projectResource
    }
    
    func makeResource() -> Resource<ProjectResource> {
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
    func projectResource() throws -> ProjectResource {
        guard let json = json else { throw Abort.badRequest }
        return try ProjectResource(json: json)
    }
}

extension ProjectResourceController: EmptyInitializable { }


