//
//  Helper.swift
//  ATMCard
//
//  Created by framgia on 5/15/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

protocol Shake { }

extension Shake where Self: UIView {
    func shake() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        let x = self.center.x
        let values = [0, 10, -10, 10, -5, 5, -5, 0 ].map({ (number) -> CGFloat in
            return x + number
        })
        animation.values = values
        animation.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]
        animation.duration = 0.4
        animation.isRemovedOnCompletion = false
        self.layer.add(animation, forKey: "shake")

    }
}

class Helper {
    class func vibration() {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }

    class func readBankJSON() -> [String: Any]? {
        guard let path = Bundle.main.path(forResource: "bank", ofType: "json") else {
            return nil
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        } catch {
            return nil
        }
    }

    class func convertStringToAccount(string: String) -> String {
        var index = 1
        var accountNumber = ""
        string.characters.forEach { (character) in
            if index % 4 == 0 {
                accountNumber.append(character)
                if index < string.characters.count  {
                    accountNumber.append(" ")
                }

            } else {
                accountNumber.append(character)
            }
            index += 1
        }
        return accountNumber
    }

    class func convertAccountToString(string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "")
    }
}


extension CGRect {
    var x: CGFloat {
        get {
            return origin.x
        }

        set {
            origin.x = newValue
        }

    }

    var y: CGFloat {
        get {
            return origin.y
        }
        set {
            origin.y = newValue
        }
    }
}


extension Optional {
    var isEmpty: Bool {
        switch self {
        case .none:
            return true
        case .some(_):
            return false
        }
    }
}
