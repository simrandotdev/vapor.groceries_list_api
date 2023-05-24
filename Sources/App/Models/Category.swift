//
//  File.swift
//  
//
//  Created by Simran Preet Narang on 2023-05-24.
//

import Foundation
import Fluent
import Vapor

final class Category: Model, Content, Validatable {
    
    static var schema: String = "categories"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "color_code")
    var colorCode: String
    
    @Parent(key: "user_id")
    var user: User
    
    init() { }
    
    init(title: String, colorCode: String, userId: UUID) {
        
        self.id = UUID()
        self.title = title
        self.colorCode = colorCode
        self.$user.id = userId
    }
    
    static func validations(_ validations: inout Validations) {
        
        validations.add("title", as: String.self, is: !.empty, required: true, customFailureDescription: "Title cannot be empty")
        validations.add("colorCode", as: String.self, is: !.empty, required: true, customFailureDescription: "Color code cannot be empty")
    }
}
