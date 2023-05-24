//
//  File.swift
//  
//
//  Created by Simran Preet Narang on 2023-05-23.
//

import Foundation
import Vapor

struct RegisterResponseDTO: Content {
    var error: Bool
    var reason: String? = nil
    
    init(error: Bool, reason: String? = nil) {
        self.error = error
        self.reason = reason
    }
}
