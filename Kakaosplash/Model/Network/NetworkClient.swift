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
            #if DEBUG
            if
                let data = data,
                let responseString = String(bytes: data, encoding: .utf8) {
                // The response body seems to be a valid UTF-8 string, so print that.
                print("RESPONSE")
                print(responseString)
            }
            #endif

            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data {
                completion(.success(data))
            }
        }
        #if DEBUG
        print("REQUEST")
        #endif
        task.resume()
    }
}
