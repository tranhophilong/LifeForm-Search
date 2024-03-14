//
//  DataObject.swift
//  Life-FormSearch
//
//  Created by Long Tran on 12/03/2024.
//

import Foundation


struct DetailLifeform: Codable{
    var identifier: Int
    var dataObjects: [DataObject]?
    var taxonConcepts: [TaxonConcept]
}
