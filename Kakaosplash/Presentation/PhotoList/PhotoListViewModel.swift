//
//  PhotoListViewModel.swift
//  Kakaosplash
//
//  Created by Nicholas Kim on 2020/11/21.
//

import Foundation

class PhotoListViewModel {
    
    private let photoService: PhotoService
    
    init(photoService: PhotoService) {
        self.photoService = photoService
    }
}
