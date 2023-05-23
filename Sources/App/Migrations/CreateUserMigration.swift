//
//  File.swift
//  
//
//  Created by Simran Preet Narang on 2023-05-22.
//

import Foundation
import Fluent

struct CreateUserMigration: AsyncMigration {
    
    func prepare(on database: FluentKit.Database) async throws {
        
        try await database
            .schema("users")
            .id()
            .field("username", .string, .required).unique(on: "username")
            .field("password", .string, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        
        try await database
            .schema("users")
            .delete()
    }
    
}
