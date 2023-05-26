//
//  File.swift
//  
//
//  Created by Simran Preet Narang on 2023-05-26.
//

import Vapor
import Fluent

class GroceryController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        let groceriesAPI = routes
            .grouped(AuthMiddleware())
            .grouped("api", "category", ":categoryId", "groceries")
        
        groceriesAPI.post(use: addGrocery)
        groceriesAPI.get(use: getGroceries)
        groceriesAPI.delete(":groceryId", use: deleteGrocery)
    }
    
    func addGrocery(req: Request) async throws -> String {
        
        // TODO:
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.badRequest, reason : "Invalid User Id")
        }
        
        guard let categoryId = req.parameters.get("categoryId", as: UUID.self) else {
            throw Abort(.badRequest, reason : "Invalid Category Id")
        }
        
        guard let dto = try? req.content.decode(GroceryRequestDTO.self) else {
            throw Abort(.badRequest, reason: "Invalid request Body")
        }
        
        guard let category = try? await Category.query(on: req.db).filter(\.$id, .equal, categoryId).first(),
              category.$user.id == userId,
              let catId = category.id else {
            throw Abort(.notFound, reason: "Category not found on this user.")
        }
        
        let grocery = Grocery(title: dto.title, price: dto.price, quantity: dto.quantity, categoryId: catId)
        
        try await grocery.save(on: req.db)
        
        return "OK"
    }
    
    func getGroceries(req: Request) async throws -> [Grocery] {
        
        // TODO:
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.badRequest, reason : "Invalid User Id")
        }
        
        guard let categoryId = req.parameters.get("categoryId", as: UUID.self) else {
            throw Abort(.badRequest, reason : "Invalid Category Id")
        }
        
        guard let category = try? await Category.query(on: req.db).filter(\.$id, .equal, categoryId).first(),
              category.$user.id == userId else {
            throw Abort(.notFound, reason: "Category not found on this user.")
        }
        
        let groceries = try await Grocery.query(on: req.db).filter(\.$category.$id, .equal, categoryId).all()
        
        return groceries
    }
    
    func deleteGrocery(req: Request) async throws -> Grocery {
        
        // TODO:
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.badRequest, reason : "Invalid User Id")
        }
        
        guard let categoryId = req.parameters.get("categoryId", as: UUID.self) else {
            throw Abort(.badRequest, reason : "Invalid Category Id")
        }
        
        guard let groceryId = req.parameters.get("groceryId", as: UUID.self) else {
            throw Abort(.badRequest, reason : "Invalid Grocery Id")
        }
        
        guard let category = try? await Category.query(on: req.db).filter(\.$id, .equal, categoryId).first(),
              category.$user.id == userId else {
            throw Abort(.notFound, reason: "Category not found on this user.")
        }
        
        guard let grocery = try? await Grocery.query(on: req.db).filter(\.$category.$id, .equal, categoryId).filter(\.$id, .equal, groceryId).first() else {
            throw Abort(.notFound)
        }
        
        try await grocery.delete(on: req.db)
        
        return grocery
    }
}
