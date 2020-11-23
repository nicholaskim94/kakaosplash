//
//  SearchedPhotoListViewModel.swift
//  Kakaosplash
//
//  Created by Nicholas Kim on 2020/11/23.
//

import Foundation

class SearchedPhotoListViewModel: HasObservablePhotos & HasObservableFocusedIndex {
    
    private let photoService: PhotoService
    
    private var currentPage = 1
    private var isLoading = false
    private var query = ""
    private var canLoadMore = true
    
    
    // Mark: Observables
    let photos: Observable<[Photo]> = Observable([])
    let error: Observable<KakaosplashError?> = Observable(nil)
    let focusedIndex: Observable<Int?> = Observable(nil)
    
    init(photoService: PhotoService) {
        self.photoService = photoService
    }
    
    func searchPhotoList(for query: String) {
        self.query = query
        currentPage = 1
        photos.value = []
        searchCurrentPhotoListPage()
    }
    
    func searchNextPhotoListPage() {
        if isLoading {
            return
        }
        
        if !canLoadMore {
            return
        }
            
        currentPage += 1
        
        searchCurrentPhotoListPage()
    }
    
    private func searchCurrentPhotoListPage() {
        isLoading = true
        
        photoService.searchPhotos(query: query,
                                  page: currentPage,
                                  orderBy: .latest) { [weak self] result in
            
            guard let self = self else { return }
            
            switch(result) {
            case .success(let photos):
                self.photos.value = self.photos.value + photos
                if photos.isEmpty {
                    self.canLoadMore = false
                }
            case .failure(let error):
                self.error.value = error
            }
            
            self.isLoading = false
        }
    }
}
