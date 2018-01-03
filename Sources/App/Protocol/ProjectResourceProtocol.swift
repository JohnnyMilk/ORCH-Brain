//
//  ProjectResourceProtocol.swift
//  App
//
//  Created by Johnny Wang on 2018/1/3.
//

protocol ProjectResourceProtocol {
    func index(_ req: Request) throws -> ResponseRepresentable
    func store(_ req: Request) throws -> ResponseRepresentable
    func show(_ req: Request, projectResource: ProjectResource) throws -> ResponseRepresentable
    func delete(_ req: Request, projectResource: ProjectResource) throws -> ResponseRepresentable
    func clear(_ req: Request) throws -> ResponseRepresentable
    func update(_ req: Request, projectResource: ProjectResource) throws -> ResponseRepresentable
}

