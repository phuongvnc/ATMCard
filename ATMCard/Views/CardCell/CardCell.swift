//
//  CardCell.swift
//  ATMCard
//
//  Created by framgia on 5/10/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

private struct Options {
    let padding = 10
    let heightCardImageViewDefault = 50
    
}

class CardCell: UICollectionViewCell {

    @IBOutlet weak var bankImageView: UIImageView!
    @IBOutlet weak var typeCardImageView: UIImageView!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!

    override var backgroundColor: UIColor? {
        didSet {
            backgroundView?.backgroundColor = backgroundColor
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundView?.cornerRadius(cornerRadius: 20)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

    }

    var card: Card? {
        didSet {
            guard let card = card else {
                return
            }

            bankImageView.image = UIImage(named: card.bank!.image)
            cardNumberLabel.text = Helper.convertStringToAccount(string: card.cardNumber)
            cardNameLabel.text = card.cardPlaceHolder
            typeCardImageView.image = card.type.image
            shadow()
        }
    }


}
