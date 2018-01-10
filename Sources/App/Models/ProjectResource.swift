//
//  ProjectResource.swift
//  ORCH-BrainPackageDescription
//
//  Created by Johnny Wang on 2018/1/3.
//

import Vapor
import FluentProvider
import HTTP

final class ProjectResource: Model {
    let storage = Storage()
    var project_id: Int
    var name: String
    var type_id: Int
    var link: String
    var remark: String?
    
    struct Keys {
        static let id = "id"
        static let project_id = "project_id"
        static let name = "name"
        static let type_id = "type_id"
        static let link = "link"
        static let remark = "remark"
    }
    
    init(project_id: Int, name: String, type_id: Int, link: String, remark: String?) {
        self.project_id = project_id
        self.name = name
        self.type_id = type_id
        self.link = link
        self.remark = remark
    }
    
    init(row: Row) throws {
        project_id = try row.get(ProjectResource.Keys.project_id)
        name = try row.get(ProjectResource.Keys.name)
        type_id = try row.get(ProjectResource.Keys.type_id)
        link = try row.get(ProjectResource.Keys.link)
        remark = try row.get(ProjectResource.Keys.remark)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(ProjectResource.Keys.project_id, project_id)
        try row.set(ProjectResource.Keys.name, name)
        try row.set(ProjectResource.Keys.type_id, type_id)
        try row.set(ProjectResource.Keys.link, link)
        try row.set(ProjectResource.Keys.remark, remark)
        return row
    }
}

// MARK: Fluent Preparation
extension ProjectResource: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.int(ProjectResource.Keys.project_id)
            builder.foreignKey(ProjectResource.Keys.project_id, references: Project.Keys.id, on: Project.self)
            builder.string(ProjectResource.Keys.name)
            builder.int(ProjectResource.Keys.type_id)
            builder.foreignKey(ProjectResource.Keys.type_id, references: ResourceType.Keys.id, on: ResourceType.self)
            builder.string(ProjectResource.Keys.link)
            builder.string(ProjectResource.Keys.remark, optional: true)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: JSON
extension ProjectResource: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            project_id: try json.get(ProjectResource.Keys.project_id),
            name: try json.get(ProjectResource.Keys.name),
            type_id: try json.get(ProjectResource.Keys.type_id),
            link: try json.get(ProjectResource.Keys.link),
            remark: try json.get(ProjectResource.Keys.remark)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(ProjectResource.Keys.id, id)
        try json.set(ProjectResource.Keys.project_id, project_id)
        try json.set(ProjectResource.Keys.name, name)
        try json.set(ProjectResource.Keys.type_id, type_id)
        try json.set(ProjectResource.Keys.link, link)
        if (remark != nil) { try json.set(ProjectResource.Keys.remark, remark) }
        return json
    }
}

// MARK: HTTP
extension ProjectResource: ResponseRepresentable { }

// MARK: Update
extension ProjectResource: Updateable {
    public static var updateableKeys: [UpdateableKey<ProjectResource>] {
        return [
            UpdateableKey(ProjectResource.Keys.project_id, Int.self) { resource, project_id in
                resource.project_id = project_id
            },
            UpdateableKey(ProjectResource.Keys.name, String.self) { resource, name in
                resource.name = name
            },
            UpdateableKey(ProjectResource.Keys.type_id, Int.self) { resource, type_id in
                resource.type_id = type_id
            },
            UpdateableKey(ProjectResource.Keys.link, String.self) { resource, link in
                resource.link = link
            },
            UpdateableKey(ProjectResource.Keys.remark, String.self) { resource, remark in
                resource.remark = remark
            }
        ]
    }
}
