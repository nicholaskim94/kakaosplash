//
//  Dependencies.swift
//  Kakaosplash
//
//  Created by Nicholas Kim on 2020/11/21.
//

import Foundation

protocol UsesNetworkClient {
    var networkClient: NetworkClient { get }
}

struct Dependencies: UsesNetworkClient {
    
    let networkClient: NetworkClient
    
    init(
        networkClient: NetworkClient = NetworkClient()
    ) {
        self.networkClient = networkClient
    }
}


protocol ServiceFactory {
    func makePhotoService() -> PhotoService
}

extension Dependencies: ServiceFactory {
    func makePhotoService() -> PhotoService {
        return PhotoService(dependencies: self)
    }
}


protocol ViewModelFactory {
    func makePhotoListViewModel() -> PhotoListViewModel
    func makeSearchedPhotoListViewModel() -> SearchedPhotoListViewModel
}

extension Dependencies: ViewModelFactory {
    func makePhotoListViewModel() -> PhotoListViewModel {
        return PhotoListViewModel(photoService: makePhotoService())
    }
    
    func makeSearchedPhotoListViewModel() -> SearchedPhotoListViewModel {
        return SearchedPhotoListViewModel(photoService: makePhotoService())
    }
}
