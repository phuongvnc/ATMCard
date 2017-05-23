//
//  Observerbale.swift
//  ATMCard
//
//  Created by framgia on 5/17/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import Foundation

class Dynamic<T> {
    typealias Listenser = (T) -> ()
    var listener : Listenser?

    func bind(_ listener: Listenser?) {
        self.listener = listener
    }

    func bindAndFire(_ listener: Listenser?) {
        bind(listener)
        listener?(value)
    }

    var value: T {
        didSet {
            self.listener?(value)
        }
    }

    init(value: T) {
        self.value = value
    }
}
