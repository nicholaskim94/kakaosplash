//
//  Observable.swift
//  Kakaosplash
//
//  Created by Nicholas Kim on 2020/11/22.
//

import Foundation

// Simple Observable, cannot be shared
class Observable<T> {

    var value: T {
        didSet {
            listener?(value)
        }
    }

    private var listener: ((T) -> Void)?

    init(_ value: T) {
        self.value = value
    }

    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
}
