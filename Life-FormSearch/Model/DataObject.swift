//
//  DataObjects.swift
//  Life-FormSearch
//
//  Created by Long Tran on 13/03/2024.
//

import Foundation


struct DataObject: Codable{
    var rightsHolder: String?
    var eolMediaURL: URL
    var mimeType: String
    var license: String
    var agents: [Agent]
}
