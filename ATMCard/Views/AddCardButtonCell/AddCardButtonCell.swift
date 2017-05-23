//
//  AddCardButtonCell.swift
//  ATMCard
//
//  Created by framgia on 5/16/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

class AddCardButtonCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    var subTitle: String? {
        didSet {
            subTitleLabel.text = subTitle
        }
    }

    
}
