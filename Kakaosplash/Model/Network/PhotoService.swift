//
//  PhotoService.swift
//  Kakaosplash
//
//  Created by Nicholas Kim on 2020/11/21.
//

import Foundation

enum PhotosOrderBy: String {
    case latest
    case oldest
    case popular
}

class PhotoService {
    
    public static let photosPerPage = 20
    
    typealias Dependencies = UsesNetworkClient
    
    private let networkClient: NetworkClient
    
    init(dependencies: Dependencies) {
        self.networkClient = dependencies.networkClient
    }
    
    func getPhotoList(page: Int,
                      perPage: Int = photosPerPage,
                      orderBy: PhotosOrderBy,
                      completion: @escaping (Result<[Photo], KakaosplashError>) -> Void) {
        let apiRequest = API.listPhotos(page: page,
                                 perPage: perPage,
                                 order: orderBy.rawValue)
        networkClient.executeRequest(apiRequest) { result in
            switch result {
            case .failure(let error):
                #if DEBUG
                print("ERROR_READING_EVENT_LIST", error.localizedDescription)
                #endif
                completion(.failure(.network(description: error.localizedDescription)))
                
            case .success(let data):
                guard
                    let response = try? JSONDecoder().decode([Photo].self, from: data) else {
                    completion(.failure(.parsing(description: "Failed to decode Photos")))
                    return
                }
                
                completion(.success(response))
                
                print("LIST", response)
            }

        }
    }
    
    func searchPhotos(query: String,
                      page: Int,
                      perPage: Int = photosPerPage,
                      orderBy: PhotosOrderBy,
                      completion: @escaping (Result<[Photo], KakaosplashError>) -> Void) {
        let apiRequest = API.searchPhotos(query: query,
                                          page: page,
                                          perPage: perPage,
                                          order: orderBy.rawValue)
        networkClient.executeRequest(apiRequest) { result in
            switch result {
            case .failure(let error):
                #if DEBUG
                print("ERROR_READING_EVENT_LIST", error.localizedDescription)
                #endif
                completion(.failure(.network(description: error.localizedDescription)))
                
            case .success(let data):
                guard
                    let response = try? JSONDecoder().decode(SearchResponse<Photo>.self, from: data) else {
                    completion(.failure(.parsing(description: "Failed to decode Photos")))
                    return
                }
                
                completion(.success(response.results))
                
                print("SEARCH", response.results)
            }

        }
    }
}
