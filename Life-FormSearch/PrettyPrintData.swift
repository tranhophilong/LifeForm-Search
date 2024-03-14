//
//  PrettyPrintData.swift
//  Life-FormSearch
//
//  Created by Long Tran on 13/03/2024.
//

import Foundation


extension Data{
    func prettyPrintedJSONString(){
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
              let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject),
              let prettyJSONString = String(data: jsonData, encoding: .utf8) else{
            print("Failed to read read JSON Objec")
            return
        }
        
        print(prettyJSONString)
    }
}
