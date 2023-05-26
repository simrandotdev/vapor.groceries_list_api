//
//  CreateGroceryTableMigration.swift
//  
//
//  Created by Simran Preet Narang on 2023-05-26.
//

import Foundation
import Fluent

class CreateGroceryTableMigration: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        
        try await database.schema("groceries")
            .id()
            .field("title", .string, .required)
            .field("price", .double, .required)
            .field("quantity", .int, .required)
            .field("category_id", .uuid, .required, .references("categories", "id", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: Database) async throws {
        
        try await database.schema("groceries")
            .delete()
    }
}
