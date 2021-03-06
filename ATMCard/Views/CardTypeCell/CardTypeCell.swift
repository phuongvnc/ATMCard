//
//  BankCell.swift
//  ATMCard
//
//  Created by framgia on 5/16/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

class CardTypeCell: UITableViewCell {

    @IBOutlet private weak var bankNameLabel: UILabel!
    @IBOutlet private weak var bankImageView: UIImageView!
    @IBOutlet private weak var bankView: UIView!
    @IBOutlet private weak var checkedImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        bankView.border(borderWidth: 1, color: Color.borderTextField)
        bankView.cornerRadius(cornerRadius: 3)
    }

    var cardType: CardType? {
        didSet {
            guard let cardType = cardType else {
                return
            }
            bankNameLabel.text = cardType.name
            bankImageView.image = cardType.image
        }
    }

    var isChecked = false {
        didSet {
            checkedImageView.image = isChecked ? UIImage(named: "icon_tick") : nil
        }
    }



    
}
