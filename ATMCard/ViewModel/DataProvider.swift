//
//  DataProvider.swift
//  ATMCard
//
//  Created by framgia on 5/17/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

protocol TableViewProvider {
    func numberOfRow(inSection section: Int) -> Int
    func heighForRow(atIndexPath indexPath: IndexPath) -> CGFloat
}

protocol CollectionViewProvider {

    func numberOfItem() -> Int
    func sizeForItem(atIndexPath indexPath: IndexPath) -> CGSize
}
