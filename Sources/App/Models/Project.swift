//
//  Project.swift
//  ORCH-BrainPackageDescription
//
//  Created by Johnny Wang on 2017/12/27.
//

import Vapor
import FluentProvider
import HTTP

final class Project: Model {
    let storage = Storage()
    var name: String
    var abbreviation: String
    
    struct Keys {
        static let id = "id"
        static let name = "name"
        static let abbreviation = "abbreviation"
    }
    
    init(name: String, abbreviation: String) {
        self.name = name
        self.abbreviation = abbreviation
    }
    
    init(row: Row) throws {
        name = try row.get(Project.Keys.name)
        abbreviation = try row.get(Project.Keys.abbreviation)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Project.Keys.name, name)
        try row.set(Project.Keys.abbreviation, abbreviation)
        return row
    }
}

// MARK: Fluent Preparation
extension Project: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Project.Keys.name)
            builder.string(Project.Keys.abbreviation, optional: true)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: JSON
extension Project: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            name: try json.get(Project.Keys.name),
            abbreviation: try json.get(Project.Keys.abbreviation)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Project.Keys.id, id)
        try json.set(Project.Keys.name, name)
        try json.set(Project.Keys.abbreviation, abbreviation)
        return json
    }
}

// MARK: HTTP
extension Project: ResponseRepresentable { }

// MARK: Update
extension Project: Updateable {
    public static var updateableKeys: [UpdateableKey<Project>] {
        return [
            // If the request contains a String at key "content"
            // the setter callback will be called.
            UpdateableKey(Project.Keys.name, String.self) { project, name in
                project.name = name
            },
            UpdateableKey(Project.Keys.abbreviation, String.self) { project, abbreviation in
                project.abbreviation = abbreviation
            }
        ]
    }
}

