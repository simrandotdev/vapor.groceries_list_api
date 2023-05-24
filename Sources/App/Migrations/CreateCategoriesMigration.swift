//
//  CreateCategoriesMigration.swift
//  
//
//  Created by Simran Preet Narang on 2023-05-24.
//

import Foundation
import Fluent

struct CreateCategoriesMigration: AsyncMigration {
    
    func prepare(on database: FluentKit.Database) async throws {
        
        try await database
            .schema("categories")
            .id()
            .field("title", .string, .required)
            .field("color_code", .string, .required)
            .field("user_id", .uuid, .required, .references("users", "id"))
            .create()
    }
    
    func revert(on database: Database) async throws {
        
        try await database
            .schema("categories")
            .delete()
    }
    
}
