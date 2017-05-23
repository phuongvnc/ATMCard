//
//  User.swift
//  ATMCard
//
//  Created by framgia on 5/12/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import Foundation

private enum UserKey: String {
    case username = "username"
    case pincode = "pincode"
}

final class User: NSObject, NSSecureCoding {

    var username: String = ""
    var pincode: String = ""
    static var supportsSecureCoding: Bool = true

    init(username: String, pincode: String) {
        self.username = username
        self.pincode = pincode
    }

    required init?(coder aDecoder: NSCoder) {
        if let username = aDecoder.decodeObject(forKey: UserKey.username.rawValue) as? String,
            let passcode = aDecoder.decodeObject(forKey: UserKey.pincode.rawValue) as? String {
            self.username = username
            self.pincode = passcode
        }
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: UserKey.username.rawValue)
        aCoder.encode(pincode, forKey: UserKey.pincode.rawValue)
    }
}
