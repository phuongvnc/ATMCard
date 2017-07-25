//
//  CardTypeViewModel.swift
//  ATMCard
//
//  Created by framgia on 5/17/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

protocol CardTypeViewModelProtocol {
    var selectedCardType: CardType? { get set }
    var cardType: [CardType] { get }
    func checkSelectCardType(_ cardType: CardType) -> Bool
    init(selectCardType: CardType?, delegate: CardTypeListViewControllerDelegate?)
}

class CardTypeViewModel: CardTypeViewModelProtocol, TableViewProvider {

    typealias DataType = CardTypeCell
    var selectedCardType: CardType?
    var cardType = CardType.list
    var delegate: CardTypeListViewControllerDelegate?

    func checkSelectCardType(_ cardType: CardType) -> Bool {
        if let selectedCardType = selectedCardType {
            return selectedCardType.rawValue == cardType.rawValue
        } else {
            return false
        }
    }

    func numberOfRow(inSection section: Int) -> Int {
        return cardType.count
    }

    func heighForRow(atIndexPath indexPath: IndexPath) -> CGFloat {
        return 65
    }

    required init(selectCardType: CardType?, delegate: CardTypeListViewControllerDelegate?) {
        self.selectedCardType = selectCardType
        self.delegate = delegate
    }




}
