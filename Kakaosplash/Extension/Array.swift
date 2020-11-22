//
//  Array.swift
//  Kakaosplash
//
//  Created by Nicholas Kim on 2020/11/22.
//

import Foundation

extension Array {

    public var isNotEmpty: Bool {
        return !self.isEmpty
    }

    init(repeating: (() -> Element), count: Int) {
        self = []
        for _ in 0..<count {
            self.append(repeating())
        }
    }

    func item(at index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }

}
