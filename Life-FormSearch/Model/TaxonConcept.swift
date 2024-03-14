//
//  TaxonConcept.swift
//  Life-FormSearch
//
//  Created by Long Tran on 12/03/2024.
//

import Foundation

struct TaxonConcept: Codable{
    var identifier: Int
    var taxonRank: String?
    var scientificName: String?
    var nameAccordingTo: String?
}

