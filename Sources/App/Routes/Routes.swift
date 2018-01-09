import Vapor

extension Droplet {
    func setupRoutes() throws {
        try resource("projects", ProjectController.self)
        try resource("resources", ProjectResourceController.self)
        
        get("project", "resource", Int.parameter) { req in
            let proojectID = try req.parameters.next(Int.self)

        return try ProjectResource.makeQuery().filter("project_id", .equals, proojectID).all().makeJSON()
        }
    }
}
