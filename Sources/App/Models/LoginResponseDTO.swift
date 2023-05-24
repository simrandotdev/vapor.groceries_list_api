//
//  LoginResponseDTO.swift
//  
//
//  Created by Simran Preet Narang on 2023-05-23.
//

import Foundation
import Vapor

struct LoginResponseDTO: Content {
    var token: String?
    var sucess: Bool
    
    init(token: String? = nil, sucess: Bool) {
        self.token = token
        self.sucess = sucess
    }
}
