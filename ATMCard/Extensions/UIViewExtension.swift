//
//  UIViewExtension.swift
//  ATMCard
//
//  Created by framgia on 5/11/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

extension UIView {

    var snapshotImage: UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    func shadow(offset: CGSize = CGSize(width: 0 ,height: -5), color: UIColor = UIColor.black, radius: CGFloat = 2, opacity: Float = 0.35, cornerRadius: CGFloat = 20) {
        let shadowLayer = layer
        shadowLayer.cornerRadius = cornerRadius
        shadowLayer.masksToBounds = false

        shadowLayer.shadowOffset = offset
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowRadius = radius
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowPath = UIBezierPath(roundedRect: shadowLayer.bounds, cornerRadius: cornerRadius ).cgPath

        let bColor = self.backgroundColor?.cgColor
        shadowLayer.backgroundColor = bColor
    }

    func removeShadow() {
        let shadowLayer = self.layer
        shadowLayer.shadowOffset = CGSize(width: 0 ,height: 0)
        shadowLayer.shadowColor = UIColor.clear.cgColor
        shadowLayer.shadowRadius = 0
        shadowLayer.shadowOpacity = 0
        shadowLayer.shadowPath = UIBezierPath(roundedRect: shadowLayer.bounds, cornerRadius: shadowLayer.cornerRadius).cgPath
    }

    func cornerRadius(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }

    func border(borderWidth: CGFloat, color: UIColor) {
        layer.borderWidth = borderWidth
        layer.borderColor = color.cgColor
    }

    static var className: String {
        return String(describing: self)
    }

    class func loadView<T: UIView>(fromNib viewType: T.Type) -> T {
        let nibName = String(describing: viewType)
        let view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as! T
        return view
    }


}

extension UINib {
    static func load(nibName: String) -> UINib {
        return UINib(nibName: nibName, bundle: nil)
    }

    static func loadSingleView<T: BaseXibView>(fromNib viewType: T.Type, owner: Any?) -> UIView {
        let nibName = String(describing: viewType)
        let view = load(nibName: nibName).instantiate(withOwner: owner, options: nil)[0] as! UIView
        return view
    }
}

