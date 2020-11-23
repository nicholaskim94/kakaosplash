
//
//  API.swift
//  Kakaosplash
//
//  Created by Nicholas Kim on 2020/11/21.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
}

struct APIConstants {
    static let BASE_URL = "https://api.unsplash.com/"
    static let ACCESS_KEY = "<UNSPLASH_ACCESS_KEY>"
}

enum API {
    
    case listPhotos(page: Int, perPage: Int, order: String)
    case searchPhotos(query: String, page: Int, perPage: Int, order: String)
    
    var path: String {
        switch self {
        case .listPhotos:   return "/photos"
        case .searchPhotos:  return "/search/photos"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .listPhotos, .searchPhotos:   return .get
        }
    }
    
    var parameters: [String: String] {
        switch self {
        case .listPhotos(let page, let perPage, let order):
            return ["page": String(page),
                    "per_page": String(perPage),
                    "order_by": order]
        case .searchPhotos(let query, let page, let perPage, let order):
            return ["query": query,
                    "page": String(page),
                    "per_page": String(perPage),
                    "order_by": order]
        }
    }
    
    var request: URLRequest {
        var components = URLComponents(string: "\(APIConstants.BASE_URL)\(self.path)")!
        
        if(self.httpMethod == .get) {
            components.queryItems = parameters.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
        }
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = self.httpMethod.rawValue
        request.setValue("v1", forHTTPHeaderField: "Accept-Version")
        request.setValue("Client-ID \(APIConstants.ACCESS_KEY)", forHTTPHeaderField: "Authorization")

        
        return request
    }
}
