//
//  Color.swift
//  ATMCard
//
//  Created by framgia on 5/12/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

class Color {
    
    static var mainColor = UIColor.colorRGB(red: 176, green: 0, blue: 109)
    static var subColor  = UIColor.colorRGB(red: 122, green: 1, blue: 78)
    static var navigationColor = UIColor.colorRGB(red: 50, green: 83, blue: 64)
    static var backgroundTextField = UIColor.colorRGB(red: 234, green: 239, blue: 242)
    static var borderTextField = UIColor.colorRGB(red: 218, green: 225, blue: 230)

}

extension UIColor {
    class func colorRGB(red: Int, green: Int, blue: Int) -> UIColor {
        return colorRGBA(red: red, green: green, blue: blue, alpha: 1)
    }

    class func colorRGBA(red: Int, green: Int , blue: Int, alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(red) / 255.0,
                       green: CGFloat(green) / 255.0,
                       blue: CGFloat(blue) / 255.0,
                       alpha: alpha)
    }
}
