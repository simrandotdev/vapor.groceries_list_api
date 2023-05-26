//
//  Grocery.swift
//  
//
//  Created by Simran Preet Narang on 2023-05-26.
//

import Vapor
import Fluent

final class Grocery: Model, Content {
    static var schema: String = "groceries"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "price")
    var price: Double
    
    @Field(key: "quantity")
    var quantity: Int
    
    @Parent(key: "category_id")
    var category: Category
    
    init() {  }
    
    init(title: String, price: Double, quantity: Int, categoryId: UUID) {
        self.id = UUID()
        self.title = title
        self.price = price
        self.quantity = quantity
        self.$category.id = categoryId
    }
}
