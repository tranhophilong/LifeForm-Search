//
//  ResponseModel.swift
//  Life-FormSearch
//
//  Created by Long Tran on 12/03/2024.
//

import Foundation


struct LifeFormsResponse: Codable{
    var results: [LifeForm]
}

struct DetailLifeFormResponse: Codable{
    var detail: DetailLifeform
    
    enum CodingKeys: String, CodingKey{
        case detail = "taxonConcept"
    }
}

struct AncestorsResponse: Codable{
    var ancestors: [Ancestor]
}
