//
//  Photo.swift
//  Kakaosplash
//
//  Created by Nicholas Kim on 2020/11/21.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let height: Int
    let width: Int
    let user: User
    let urls: PhotoUrlPack
    
    struct PhotoUrlPack: Decodable {
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String
    }
}
