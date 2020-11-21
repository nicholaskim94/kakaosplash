//
//  Photo.swift
//  Kakaosplash
//
//  Created by Nicholas Kim on 2020/11/21.
//

import Foundation

struct PhotoUrlPack: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct Photo: Decodable {
    let id: String
    let user: User
    let urls: PhotoUrlPack
    
}
