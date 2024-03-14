//
//  LifeFormController.swift
//  Life-FormSearch
//
//  Created by Long Tran on 12/03/2024.
//

import UIKit


class LifeFormController{
    
    static let shared = LifeFormController()
    
    func sendRequest<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
        
        let (data, response) = try await URLSession.shared.data(for: request.urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else{
            throw request.requestError
        }
        
        return try request.decodeResponse(data: data)
    }
    
    func fetchLifeForms(for keyWord: String) async throws -> [LifeForm]{
        let lifeFormsRequest = LifeFormsAPIRequest(keyWordSearch: keyWord)
        let lifeFormResponse = try await sendRequest(lifeFormsRequest)
        return lifeFormResponse.results
    }
    
    func fetchDetailLifeForm(for id: Int) async throws -> DetailLifeform {
        let detailLifeFormRequest = DetailLifeFormAPIRequest(id: id)
        let detailLifeForm = try await sendRequest(detailLifeFormRequest)
        
        return detailLifeForm
    }
    
    func fetchAncestors(for id: Int) async throws -> AncestorsDict {
        let ancestorsRequest = AncestorsAPIRequest(id: id)
        let ancestors = try await sendRequest(ancestorsRequest)
    
        return ancestors
    }
    
    func fetchImage(for url: URL) async throws -> UIImage {
        let imageRequest = ImageAPIRequest(url: url)
        let image = try await sendRequest(imageRequest)
        
        return image
    }
}


struct LifeFormsAPIRequest: APIRequest{
    
    var requestError: APIRequestError{
        return .lifeFormNotFound
    }
    
    var keyWordSearch: String?
    var urlRequest: URLRequest{
        get{
            var urlComponent = URLComponents(string: "https://eol.org/api/search/1.0.json")
            
            let queries = ["q": keyWordSearch, "page":"1"]
            urlComponent?.queryItems = queries.map{URLQueryItem(name: $0.key, value: $0.value)}
            
            let urlRequest = URLRequest(url: urlComponent!.url!)
            return urlRequest
            
        }
    }
    
    func decodeResponse(data: Data) throws -> LifeFormsResponse {
        let jsonDecoder = JSONDecoder()
        let lifeFormsResponse =  try jsonDecoder.decode(LifeFormsResponse.self, from: data)
    
        return lifeFormsResponse
    }
}

struct DetailLifeFormAPIRequest:  APIRequest{
    
    var requestError: APIRequestError{
        return .detailLifeFormNotFound
    }
    
    let id: Int
    
    var urlRequest: URLRequest{
        var urlComponent = URLComponents(string: "https://eol.org/api/pages/1.0/\(id).json")
        let queries = ["taxonomy": "true", "images_per_page": "1", "language": "en"]
        
        urlComponent?.queryItems = queries.map{ URLQueryItem(name: $0.key, value: $0.value)}

        let urlRequest = URLRequest(url: urlComponent!.url!)
        return urlRequest
    }
    
    func decodeResponse(data: Data) throws -> DetailLifeform {
        
        let jsonDecoder = JSONDecoder()
        var detailLifeFormResponse = try jsonDecoder.decode(DetailLifeFormResponse.self, from: data)
        if let firstObject = detailLifeFormResponse.detail.dataObjects?.first{
            detailLifeFormResponse.detail.dataObjects = Array(arrayLiteral: firstObject)
        }
        
        detailLifeFormResponse.detail.taxonConcepts = Array(detailLifeFormResponse.detail.taxonConcepts[0..<1])

        
        return detailLifeFormResponse.detail
    }
    
}

typealias AncestorsDict = [String: String]

struct AncestorsAPIRequest: APIRequest{
    
    var requestError: APIRequestError{
        .ancestorsNotFound
    }
    
    let id: Int
    
    var urlRequest: URLRequest{
        let urlComponent = URLComponents(string: "https://eol.org/api/hierarchy_entries/1.0/\(id).json?language=en")
        let request = URLRequest(url: urlComponent!.url!)
        return request
    }
    
    func decodeResponse(data: Data) throws -> AncestorsDict {
        let jsonDecoder = JSONDecoder()
        let ancestorsResponse = try jsonDecoder.decode(AncestorsResponse.self, from: data)
        
        let taxonRankLimiteds = ["kingdom", "phylum", "order", "family", "genus"]
        let ancestorsFilled = ancestorsResponse.ancestors.filter({ ancestor in
            if let taxonRank = ancestor.taxonRank{
                return taxonRankLimiteds.contains(taxonRank)

            }else{
                return false
            }
        })
        
        let completedAncestors = Dictionary<String, String>(uniqueKeysWithValues: ancestorsFilled.compactMap{ ancestor in
            guard let taxonRank = ancestor.taxonRank else{
                return nil
            }
            
            return(taxonRank, ancestor.scientificName)
        })

    
        
        return completedAncestors
        
    }
    
}

struct ImageAPIRequest: APIRequest{
   
    
    var requestError: APIRequestError{
        .invalidImage
    }
    let url: URL
    
    var urlRequest: URLRequest{
        return URLRequest(url: url)
    }
    
    func decodeResponse(data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else{
            throw  APIRequestError.invalidImage
        }
        
        return image
    }
    
}
