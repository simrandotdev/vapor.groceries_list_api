//
//  File.swift
//  
//
//  Created by Simran Preet Narang on 2023-05-23.
//

import Foundation
import Vapor

class UserController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        let usersGroup = routes.grouped("api", "users")
        
        // POST: /api/register
        usersGroup.post("register", use: register)
    }
    
    func register(req: Request) async throws -> RegisterResponseDTO {
        
        try User.validate(query: req)
        
        guard let user = try? req.content.decode(User.self) else {
            throw Abort(.badRequest)
        }
        
        // find if the username already exists
        if let _ = try await User.query(on: req.db)
            .filter(\.$username, .equal, user.username)
            .first() {
            throw Abort(.conflict, reason: "Username already exists.")
        }
        
        // hash the password
        user.password = try await req.password.async.hash(user.password)
        
        // save the user in database
        try await user.save(on: req.db)
        
        
        return RegisterResponseDTO(error: false	)
    }
}
