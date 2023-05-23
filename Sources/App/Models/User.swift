//
//  File.swift
//  
//
//  Created by Simran Preet Narang on 2023-05-23.
//

import Foundation
import Vapor
import Fluent

final class User: Model, Content, Validatable {

    static var schema: String = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "password")
    var password: String
    
    init() { }
    
    init(username: String, password: String) {
        self.id = UUID()
        self.username = username
        self.password = password
    }
    
    static func validations(_ validations: inout Validations) {
        
        validations.add("username", as: String.self, is: !.empty, required: true, customFailureDescription: "Username cannot be empty.")
        validations.add("password", as: String.self, is: !.empty, required: true, customFailureDescription: "Password cannot be empty.")
        validations.add("password", as: String.self, is: .count(6...100), required: true, customFailureDescription: "Password must be between 6 to 100 characters long.")
    }
}
