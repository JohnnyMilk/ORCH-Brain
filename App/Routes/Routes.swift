import Vapor

extension Droplet {
    func setupRoutes() throws {
        
        try resource("projects", ProjectController.self)
    }
}
