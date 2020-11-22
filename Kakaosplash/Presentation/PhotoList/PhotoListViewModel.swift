//
//  PhotoListViewModel.swift
//  Kakaosplash
//
//  Created by Nicholas Kim on 2020/11/21.
//

import Foundation

class PhotoListViewModel {
    
    private let photoService: PhotoService
    
    private var currentPage = 1
    private var isLoading = false
    
    
    // Mark: Observables
    let photos: Observable<[Photo]> = Observable([])
    let error: Observable<KakaosplashError?> = Observable(nil)
    let focusedIndex: Observable<Int?> = Observable(nil)
    
    init(photoService: PhotoService) {
        self.photoService = photoService
    }
    
    func fetchPhotoList() {
        if currentPage == 1 {
            fetchCurrentPhotoListPage()
        }
    }
    
    func fetchNextPhotoListPage() {
        if isLoading {
            return
        }
        
        currentPage += 1
        
        fetchCurrentPhotoListPage()
    }
    
    private func fetchCurrentPhotoListPage() {
        isLoading = true
        
        photoService.getPhotoList(page: currentPage, orderBy: .latest) { [weak self] result in
            
            guard let self = self else { return }
            
            switch(result) {
            case .success(let photos):
                self.photos.value = self.photos.value + photos
            case .failure(let error):
                self.error.value = error
            }
            
            self.isLoading = false
        }
    }
}
