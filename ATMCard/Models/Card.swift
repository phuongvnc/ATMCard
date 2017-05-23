//
//  Card.swift
//  ATMCard
//
//  Created by framgia on 5/12/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import Foundation
import RealmS
import RealmSwift

enum CardType: Int {
    case visa
    case master
    case discover
    case amex
    case jcb
    case atm

    var name: String {
        switch self {
        case .visa:
            return "Visa"
        case .master:
            return "Master"
        case .discover:
            return "Discover"
        case .amex:
            return "American Express"
        case .jcb:
            return "JCB"
        case .atm:
            return "ATM"
        }
    }

    var image: UIImage? {
        switch self {
        case .visa:
            return UIImage(named:"logo_visa_type")
        case .master:
            return UIImage(named:"logo_master_type")
        case .discover:
            return UIImage(named:"logo_discover_type")
        case .amex:
            return UIImage(named:"logo_amex_type")
        case .jcb:
            return UIImage(named:"logo_jcb_type")
        case .atm:
            return nil
        }
    }

    static var list:[CardType] = [.visa,.master,.discover,.amex,.jcb,.atm]
}
final class Card: Object {
    dynamic var bank: Bank?
    dynamic var accountNumber: String = ""
    dynamic var cardNumber: String = ""
    dynamic var cardPlaceHolder: String = ""
    dynamic var expireDate: Date?
    dynamic var cvc: String = ""
    dynamic private var cardType = CardType.atm.rawValue
    var type: CardType {
        get {
            if let type = CardType(rawValue: cardType) {
                return type
            }

            return CardType.atm
        }

        set {
            cardType = newValue.rawValue
        }
    }
    dynamic var internetBanking: InternetBanking?
}


