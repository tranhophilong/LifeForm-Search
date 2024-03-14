//
//  SearchInfo.swift
//  Life-FormSearch
//
//  Created by Long Tran on 12/03/2024.
//

import Foundation


struct LifeForm: Codable{
    var identifier: Int
    var scientificName: String
    var commonName: String
    
    enum CodingKeys: String, CodingKey{
        case identifier = "id"
        case scientificName = "title"
        case commonName = "content"
    }
}
