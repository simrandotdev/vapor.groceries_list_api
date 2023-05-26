//
//  GroceryRequestDTO.swift
//  
//
//  Created by Simran Preet Narang on 2023-05-26.
//

import Vapor

struct GroceryRequestDTO: Content {
    let title: String
    let price: Double
    let quantity: Int
}
