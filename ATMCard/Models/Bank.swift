//
//  Bank.swift
//  ATMCard
//
//  Created by framgia on 5/15/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import Foundation
import RealmS
import RealmSwift
import ObjectMapper

final class Bank: Object, Mappable {
    dynamic var index  = 0
    dynamic var name  = ""
    dynamic var image  = ""
    dynamic var tradingName = ""

    override class func primaryKey() -> String {
        return "index"
    }

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        index <- map["index"]
        name  <- map["name"]
        image <- map["image"]
        tradingName <- map["trading_name"]
    }


}
