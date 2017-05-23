//
//  HomeModelView.swift
//  ATMCard
//
//  Created by framgia on 5/17/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit
import RealmS
import RealmSwift

typealias RealmUpdateData = (_ notification: Realm.Notification, _ realm: RealmS) -> Void

protocol HomeModelViewProtocol {

    var selectCell: UICollectionViewCell! { get set}
    var color: [UIColor] { get }
    var cards: Results<Card>! { get }
    var realm: RealmS { get }
    var token: NotificationToken! { get }
    var collectionViewContentInset: UIEdgeInsets { get }

    func updateData(_ notification: @escaping RealmUpdateData)

}

class HomeModelView: HomeModelViewProtocol, CollectionViewProvider {

    var selectCell: UICollectionViewCell!
    var color: [UIColor]
    var realm: RealmS = RealmS()
    var cards: Results<Card>!
    var token: NotificationToken!
    var updateData: RealmUpdateData?
    var collectionViewContentInset: UIEdgeInsets

    init() {
        cards =  realm.objects(Card.self)
        color = [UIColor.yellow, UIColor.green, UIColor.red, UIColor.cyan,
                 UIColor.brown, UIColor.purple, UIColor.orange, UIColor.magenta]
        collectionViewContentInset =  UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }

    func updateData(_ notification: @escaping RealmUpdateData) {
        token = realm.addNotificationBlock(notification)
    }

    func numberOfItem() -> Int {
        return cards.count
    }

    func sizeForItem(atIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 2/3)
    }
}
