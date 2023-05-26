//
//  File.swift
//  
//
//  Created by Simran Preet Narang on 2023-05-26.
//

import Foundation
import Vapor
import JWT

struct AuthMiddleware: AsyncMiddleware {
    
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        
        guard let payload = try? request.jwt.verify(as: AuthPayload.self) else {
            throw Abort(.unauthorized)
        }
        
        guard let _ = try await User.query(on: request.db).filter(\.$id, .equal, payload.userId).first() else {
            throw Abort(.unauthorized)
        }
        
        request.parameters.set("userId", to: payload.userId.uuidString)
        
        return try await next.respond(to: request)
    }
}
