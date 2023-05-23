//
//  File.swift
//  
//
//  Created by Simran Preet Narang on 2023-05-23.
//

import Foundation
import Vapor
import JWT

class UserController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        let usersGroup = routes.grouped("api", "users")
        
        // POST: /api/register
        usersGroup.post("register", use: register)
        
        // POST: /api/login
        usersGroup.post("login", use: login)
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
    
    
    func login(req: Request) async throws -> LoginResponseDTO {
        
//        try User.validate(query: req)
        
        guard let user = try? req.content.decode(User.self) else {
            throw Abort(.badRequest)
        }
        
        // find if the user already exists
        guard let existingUser = try await User.query(on: req.db)
            .filter(\.$username, .equal, user.username)
            .first() else {
            throw Abort(.conflict, reason: "Username already exists.")
        }
        
        // validate the password
        let ifPasswordMatched = try await req.password.async.verify(user.password, created: existingUser.password)
        
        if !ifPasswordMatched {
            throw Abort(.unauthorized)
        }
        
        // create JWT Token
        let authPayload = AuthPayload(subject: .init(stringLiteral: "grocery_app"),
                                      expiration: .init(value: Date().addingTimeInterval(3600)),
                                      userId: try existingUser.requireID())
        
        
        return LoginResponseDTO(token: try req.jwt.sign(authPayload), sucess: true)
    }
}
