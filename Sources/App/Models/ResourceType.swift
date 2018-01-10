//
//  ResourceType.swift
//  App
//
//  Created by Johnny Wang on 2018/1/10.
//

import Vapor
import FluentProvider
import HTTP

enum ProjectResourceType: String {
    case apk = "apk"
    case ipaHtml = "ipaHtml"
    
    static let allValues = [apk, ipaHtml]
}

final class ResourceType: Model {
    let storage = Storage()
    var name: String
    var remark: String?
    
    struct Keys {
        static let id = "id"
        static let name = "name"
        static let remark = "remark"
    }
    
    init(name: String, remark: String?) {
        self.name = name
        self.remark = remark
    }
    
    init(row: Row) throws {
        name = try row.get(ResourceType.Keys.name)
        remark = try row.get(ResourceType.Keys.remark)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(ResourceType.Keys.name, name)
        try row.set(ResourceType.Keys.remark, remark)
        return row
    }
}

// MARK: Fluent Preparation
extension ResourceType: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(ResourceType.Keys.name)
            builder.string(ResourceType.Keys.remark, optional: true)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: JSON
extension ResourceType: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            name: try json.get(ResourceType.Keys.name),
            remark: try json.get(ResourceType.Keys.remark)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(ResourceType.Keys.id, id)
        try json.set(ResourceType.Keys.name, name)
        try json.set(ResourceType.Keys.remark, remark)
        return json
    }
}

// MARK: HTTP
extension ResourceType: ResponseRepresentable { }

// MARK: Update
extension ResourceType: Updateable {
    public static var updateableKeys: [UpdateableKey<ResourceType>] {
        return [
            UpdateableKey(ResourceType.Keys.name, String.self) { type, name in
                type.name = name
            },
            UpdateableKey(ResourceType.Keys.remark, String.self) { type, remark in              type.remark = remark
            }
        ]
    }
}



