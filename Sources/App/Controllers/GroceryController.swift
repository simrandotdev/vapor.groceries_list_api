//
//  GroceryController.swift
//  
//
//  Created by Simran Preet Narang on 2023-05-26.
//

import Vapor

class GroceryController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        // /api/users/:userId
        let api = routes.grouped("api", "users", ":userId")
        
    // POST: Saving GroceryCategory
    // /api/user/:userId/categories
        api.post("categories", use: saveCategory)
    }
    
    func saveCategory(req: Request) async throws -> CategoryResponseDTO {
        
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        // DTO for request
        guard let requestDTO = try? req.content.decode(CategoryRequestDTO.self) else {
            throw Abort(.badRequest)
        }
        
        
        let category = Category(title: requestDTO.title, colorCode: requestDTO.colorCode, userId: userId)
        try await category.save(on: req.db)
        
        // DTO for response
        
        
        return .init(category: category)
    }
}
