//
//  Agent.swift
//  Life-FormSearch
//
//  Created by Long Tran on 12/03/2024.
//

import Foundation

struct Agent: Codable{
    var role: String
    var fullName: String
    
    enum CodingKeys: String, CodingKey{
        case role
        case fullName = "full_name"
    }
}
