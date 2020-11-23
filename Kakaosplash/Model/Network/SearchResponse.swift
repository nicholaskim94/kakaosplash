//
//  SearchResponse.swift
//  Kakaosplash
//
//  Created by Nicholas Kim on 2020/11/23.
//

import Foundation

struct SearchResponse<T: Decodable>: Decodable {
    let total: Int
    let results: [T]
}
