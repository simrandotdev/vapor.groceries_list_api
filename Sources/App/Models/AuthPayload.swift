//
//  File.swift
//  
//
//  Created by Simran Preet Narang on 2023-05-23.
//

import Foundation
import JWT

struct AuthPayload: JWTPayload {
    
    var subject: SubjectClaim
    var expiration: ExpirationClaim
    var userId: UUID
    
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
        case userId = "uid"
    }
    
    func verify(using signer: JWTKit.JWTSigner) throws {
        try self.expiration.verifyNotExpired()
    }
}
