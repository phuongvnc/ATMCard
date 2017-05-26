//
//  Color.swift
//  ATMCard
//
//  Created by framgia on 5/12/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

extension UIColor {

    func isDistinct(compare color:UIColor) -> Bool {
        let mainComponents = self.cgColor.components!
        let compareComponents = color.cgColor.components!
        let threshold:CGFloat = 0.2

        if fabs(mainComponents[0] - compareComponents[0]) > threshold ||
        fabs(mainComponents[1] - compareComponents[1]) > threshold ||
            fabs(mainComponents[2] - compareComponents[2]) > threshold {
            if fabs(mainComponents[0] - mainComponents[1]) < 0.03 && fabs(compareComponents[0] - compareComponents[2]) < 0.03 {
                if fabs(compareComponents[0] - compareComponents[1]) < 0.03 && fabs(compareComponents[0] - compareComponents[2]) < 0.03 {
                    return false
                }
            }
            return true
        }
        return false
    }


    static let mainColor = UIColor.colorRGB(red: 176, green: 0, blue: 109)
    static let subColor  = UIColor.colorRGB(red: 122, green: 1, blue: 78)
    static let navigationColor = UIColor.colorRGB(red: 50, green: 83, blue: 64)
    static let backgroundTextField = UIColor.colorRGB(red: 234, green: 239, blue: 242)
    static let borderTextField = UIColor.colorRGB(red: 218, green: 225, blue: 230)
}
