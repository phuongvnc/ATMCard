//
//  BaseXibView.swift
//  Blank Project
//
//  Created by framgia on 5/22/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

class BaseXibView: UIView {
    private var xibView: UIView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let xibView = UINib.loadSingleView(fromNib: type(of: self),owner: self)
        addSubview(xibView)
        self.xibView = xibView
    }

    required init() {
        super.init(frame: CGRect.zero)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        xibView.frame = bounds
    }
}
