//
//  ResourceTypeProtocol.swift
//  App
//
//  Created by Johnny Wang on 2018/1/10.
//

protocol ResourceTypeProtocol {
    func index(_ req: Request) throws -> ResponseRepresentable
    func store(_ req: Request) throws -> ResponseRepresentable
    func show(_ req: Request, resourceType: ResourceType) throws -> ResponseRepresentable
    func delete(_ req: Request, resourceType: ResourceType) throws -> ResponseRepresentable
    func clear(_ req: Request) throws -> ResponseRepresentable
    func update(_ req: Request, resourceType: ResourceType) throws -> ResponseRepresentable
}


