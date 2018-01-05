//
//  ProjectResource.swift
//  ORCH-BrainPackageDescription
//
//  Created by Johnny Wang on 2018/1/3.
//

import Vapor
import FluentProvider
import HTTP

enum ProjectResourceType: String {
    case apk = "apk"
    case ipaHtml = "ipaHtml"
    
    static let allValues = [apk, ipaHtml]
}

final class ProjectResource: Model {
    let storage = Storage()
    var project_id: Int
    var name: String
    var type: ProjectResourceType.RawValue
    var link: String
    
    struct Keys {
        static let id = "id"
        static let project_id = "project_id"
        static let name = "name"
        static let type = "type"
        static let link = "link"
    }
    
    init(project_id: Int, name: String, type: ProjectResourceType.RawValue, link: String) {
        self.project_id = project_id
        self.name = name
        self.type = type
        self.link = link
    }
    
    init(row: Row) throws {
        project_id = try row.get(ProjectResource.Keys.project_id)
        name = try row.get(ProjectResource.Keys.name)
        type = try row.get(ProjectResource.Keys.type)
        link = try row.get(ProjectResource.Keys.link)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(ProjectResource.Keys.project_id, project_id)
        try row.set(ProjectResource.Keys.name, name)
        try row.set(ProjectResource.Keys.type, type)
        try row.set(ProjectResource.Keys.link, link)
        return row
    }
}

// MARK: Fluent Preparation
extension ProjectResource: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.int(ProjectResource.Keys.project_id)
            builder.string(ProjectResource.Keys.name)
            builder.string(ProjectResource.Keys.type)
            builder.string(ProjectResource.Keys.link)
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
            type: try json.get(ProjectResource.Keys.type),
            link: try json.get(ProjectResource.Keys.link)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(ProjectResource.Keys.id, id)
        try json.set(ProjectResource.Keys.project_id, project_id)
        try json.set(ProjectResource.Keys.name, name)
        try json.set(ProjectResource.Keys.type, type)
        try json.set(ProjectResource.Keys.link, link)
        return json
    }
}

// MARK: HTTP
extension ProjectResource: ResponseRepresentable { }

// MARK: Update
extension ProjectResource: Updateable {
    public static var updateableKeys: [UpdateableKey<ProjectResource>] {
        return [
            // If the request contains a String at key "content"
            // the setter callback will be called.
            UpdateableKey(ProjectResource.Keys.project_id, Int.self) { resource, project_id in
                resource.project_id = project_id
            },
            UpdateableKey(ProjectResource.Keys.name, String.self) { resource, name in
                resource.name = name
            },
            UpdateableKey(ProjectResource.Keys.type, String.self) { resource, type in
                resource.type = type
            },
            UpdateableKey(ProjectResource.Keys.link, String.self) { resource, link in
                resource.link = link
            }
        ]
    }
}


