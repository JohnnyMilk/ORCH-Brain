import Vapor

extension Droplet {
    func setupRoutes() throws {
        try resource("projects", ProjectController.self)
        try resource("resources", ProjectResourceController.self)
        try resource("types", ResourceTypeController.self)
        
        get("project", Int.parameter, "type", Int.parameter, "resources") { req in
            let proojectID = try req.parameters.next(Int.self)
            let typeID = try req.parameters.next(Int.self)

            return try ProjectResource.makeQuery().and { andGrpup in
                try andGrpup.filter("project_id", .equals, proojectID)
                try andGrpup.filter("type_id", .equals, typeID)
                }.all().makeJSON()
        }
        
        get("project", Int.parameter, "resources") { req in
            let proojectID = try req.parameters.next(Int.self)
            
            return try ProjectResource.makeQuery().filter("project_id", .equals, proojectID).all().makeJSON()
        }

        get("type", Int.parameter, "resources") { req in
            let typeID = try req.parameters.next(Int.self)
            
            return try ProjectResource.makeQuery().filter("type_id", .equals, typeID).all().makeJSON()
        }
        
    }
}


