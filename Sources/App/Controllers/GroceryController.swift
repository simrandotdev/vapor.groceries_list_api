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
        
        // GET: Fetching GroceryCategory
        // /api/user/:userId/categories
        api.get("categories", use: fetchCategories)
        
        api.put("categories", ":categoryId", use: updateCategory)
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
    
    
    func fetchCategories(req: Request) async throws -> [Category] {
        
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        let categories: [Category] = try await Category
            .query(on: req.db)
            .filter(\.$user.$id, .equal, userId)
            .all()
        
        
        return categories
    }
    
    
    func updateCategory(req: Request) async throws -> CategoryResponseDTO {

        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.badRequest)
        }

        guard let categoryId = req.parameters.get("categoryId", as: UUID.self) else {
            throw Abort(.badRequest)
        }

        guard let requestDTO = try? req.content.decode(CategoryRequestDTO.self) else {
            throw Abort(.badRequest)
        }

        let categoryWithIdQuery  =  Category
            .query(on: req.db)
            .filter(\.$user.$id, .equal, userId)

        guard let category = try await categoryWithIdQuery.filter(\.$id, .equal, categoryId)
            .first() else {
            throw Abort(.notFound)
        }
        
        category.title = requestDTO.title
        category.colorCode = requestDTO.colorCode
        
        try await category.save(on: req.db)
        

        return CategoryResponseDTO(category: category)
    }
    
    
}
