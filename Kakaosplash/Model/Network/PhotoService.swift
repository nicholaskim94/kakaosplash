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
    
    typealias Dependencies = UsesNetworkClient
    
    private let networkClient: NetworkClient
    
    init(dependencies: Dependencies) {
        self.networkClient = dependencies.networkClient
    }
    
    func getPhotoList(page: Int,
                      perPage: Int = 20,
                      orderBy: PhotosOrderBy,
                      completion: @escaping (Result<[Photo], Error>) -> Void) {
        let apiRequest = API.listPhotos(page: page,
                                 perPage: perPage,
                                 order: orderBy.rawValue)
        networkClient.executeRequest(apiRequest) { [weak self] result in
            switch result {
            case .failure(let error):
                #if DEBUG
                print("ERROR_READING_EVENT_LIST", error.localizedDescription)
                #endif
                completion(.failure(error))
                
            case .success(let data):
                guard
                    let response = try? JSONDecoder().decode([Photo].self, from: data) else {
                    return
                }
                
                completion(.success(response))
            }

        }
    }
}
