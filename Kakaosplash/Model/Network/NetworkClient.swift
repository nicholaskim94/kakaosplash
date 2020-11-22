//
//  NetworkClient.swift
//  Kakaosplash
//
//  Created by Nicholas Kim on 2020/11/21.
//

import Foundation

class NetworkClient {
    
    let urlSession = URLSession.shared
    
    func executeRequest(_ api: API, completion: @escaping (Result<Data, Error>) -> Void) {
        
        let task = urlSession.dataTask(with: api.request) { data, response, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data {
                completion(.success(data))
            }
        }
        task.resume()
    }
}
