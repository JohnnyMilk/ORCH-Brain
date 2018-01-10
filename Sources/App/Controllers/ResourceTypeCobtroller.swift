//
//  ResourceTypeCobtroller.swift
//  App
//
//  Created by Johnny Wang on 2018/1/10.
//

import Vapor
import HTTP

final class ResourceTypeController: ResourceTypeProtocol, ResourceRepresentable {
    // When users call 'GET' on '/types'
    // it should return an index of all available types
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try ResourceType.all().makeJSON()
    }
    
    // When consumers call 'POST' on '/types' with valid JSON
    // construct and save the type
    func store(_ req: Request) throws -> ResponseRepresentable {
        let resourceType = try req.resourceType()
        try resourceType.save()
        return resourceType
    }
    
    // When the consumer calls 'GET' on a specific resource, ie:
    // '/types/1' we should show that specific type
    func show(_ req: Request, resourceType: ResourceType) throws -> ResponseRepresentable {
        return resourceType
    }
    
    // When the consumer calls 'DELETE' on a specific resource, ie:
    // '/types/1' we should remove that resource from the database
    func delete(_ req: Request, resourceType: ResourceType) throws -> ResponseRepresentable {
        try resourceType.delete()
        return Response(status: .ok)
    }
    
    // When the consumer calls 'DELETE' on the entire table, ie:
    // '/types' we should remove the entire table
    func clear(_ req: Request) throws -> ResponseRepresentable {
        try ResourceType.makeQuery().delete()
        return Response(status: .ok)
    }
    
    // When the user calls 'PATCH' on a specific resource, we should
    // update that resource to the new values.
    func update(_ req: Request, resourceType: ResourceType) throws -> ResponseRepresentable {
        try resourceType.update(for: req)
        try resourceType.save()
        return resourceType
    }
    
    func makeResource() -> Resource<ResourceType> {
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
    func resourceType() throws -> ResourceType {
        guard let json = json else { throw Abort.badRequest }
        return try ResourceType(json: json)
    }
}

extension ResourceTypeController: EmptyInitializable { }


