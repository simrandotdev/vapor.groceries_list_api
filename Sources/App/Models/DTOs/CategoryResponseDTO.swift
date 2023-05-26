//
//  CategoryResponseDTO.swift
//  
//
//  Created by Simran Preet Narang on 2023-05-26.
//

import Vapor

struct CategoryResponseDTO: Content {
    
    let id: UUID?
    let title: String
    let colorCode: String
    
    init(category: Category) {
        self.id = category.id
        self.title = category.title
        self.colorCode = category.colorCode
    }
}


