//
//  APIRequest.swift
//  Life-FormSearch
//
//  Created by Long Tran on 12/03/2024.
//

import Foundation


protocol APIRequest{
    associatedtype Response
    
    var requestError: APIRequestError {get}
    
    var urlRequest: URLRequest {get}
    
    func decodeResponse(data: Data) throws -> Response
}


enum APIRequestError: Error, LocalizedError{
    case lifeFormNotFound
    case detailLifeFormNotFound
    case ancestorsNotFound
    case invalidImage
}
