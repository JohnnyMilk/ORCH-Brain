import Vapor

extension Droplet {
    func setupRoutes() throws {
        try resource("projects", ProjectController.self)
        try resource("resources", ProjectResourceController.self)
        try resource("types", ResourceTypeController.self)
        
        get("project", Int.parameter, "type", Int.parameter, "resources") { req in
            let proojectID = try req.parameters.next(Int.self)
            let typeID = try req.parameters.next(Int.self)

            return try self.formatJSONDataWithReadableValue(resources: try ProjectResource.makeQuery().and { andGrpup in
                try andGrpup.filter("project_id", .equals, proojectID)
                try andGrpup.filter("type_id", .equals, typeID)
                }.all())
        }
        
        get("project", Int.parameter, "resources") { req in
            let proojectID = try req.parameters.next(Int.self)
            
            return try self.formatJSONDataWithReadableValue(resources: try ProjectResource.makeQuery().filter("project_id", .equals, proojectID).all())
        }

        get("type", Int.parameter, "resources") { req in
            let typeID = try req.parameters.next(Int.self)
            
            return try self.formatJSONDataWithReadableValue(resources: try ProjectResource.makeQuery().filter("type_id", .equals, typeID).all())
        }
    }
    
    private func formatJSONDataWithReadableValue(resources : [ProjectResource]) throws -> JSON {
        var jsonArray = [JSON]()
        
        for resource in resources {
            var json = try resource.makeJSON()
            let type_name = try ResourceType.makeQuery().filter("id", .equals, resource.type_id).first()?.name
            let project_name = try Project.makeQuery().filter("id", .equals, resource.project_id).first()?.name
            try json.set("type_name", type_name)
            try json.set("project_name", project_name)
            json.removeKey(ProjectResource.Keys.type_id)
            json.removeKey(ProjectResource.Keys.project_id)
            
            jsonArray.append(json)
        }
        
        return try JSON(node: jsonArray)
    }
    
}


