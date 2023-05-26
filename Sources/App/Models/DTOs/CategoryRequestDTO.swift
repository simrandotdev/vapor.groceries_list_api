//
//  CategoryRequestDTO.swift
//  
//
//  Created by Simran Preet Narang on 2023-05-26.
//

import Vapor

struct CategoryRequestDTO: Content {
    
    let title: String
    let colorCode: String
    
}
