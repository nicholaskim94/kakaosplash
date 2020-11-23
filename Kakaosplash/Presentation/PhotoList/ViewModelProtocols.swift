//
//  PhotoViewModel.swift
//  Kakaosplash
//
//  Created by Nicholas Kim on 2020/11/23.
//

protocol HasObservablePhotos {
    
    var photos: Observable<[Photo]> { get }
    var error: Observable<KakaosplashError?> { get }
    
}

protocol HasObservableFocusedIndex {
    
    var focusedIndex: Observable<Int?> { get }
}
