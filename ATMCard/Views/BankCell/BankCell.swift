//
//  BankCell.swift
//  ATMCard
//
//  Created by framgia on 5/16/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

class BankCell: UITableViewCell {

    @IBOutlet private weak var bankNameLabel: UILabel!
    @IBOutlet private weak var bankImageView: UIImageView!
    @IBOutlet private weak var bankView: UIView!
    @IBOutlet private weak var checkedImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        bankView.border(borderWidth: 1, color: Color.borderTextField)
        bankView.cornerRadius(cornerRadius: 3)
    }

    var bank: Bank? {
        didSet {
            guard let bank = bank else {
                return
            }

            bankNameLabel.text = bank.name
            bankImageView.image = UIImage(named: bank.image)
        }
    }

    var isChecked = false {
        didSet {
            checkedImageView.image = isChecked ? UIImage(named: "icon_tick") : nil
        }
    }



    
}
