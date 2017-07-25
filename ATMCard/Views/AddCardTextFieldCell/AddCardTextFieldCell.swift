//
//  AddCardTextFieldCell.swift
//  ATMCard
//
//  Created by framgia on 5/15/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

protocol AddCardTextFieldCellDelegate:class {
    func textFieldCell(cell: AddCardTextFieldCell, changeTextField textField: UITextField)
}

class AddCardTextFieldCell: UITableViewCell {

    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var visibleButton: UIButton!
    weak var delegate: AddCardTextFieldCellDelegate? {
        didSet {
            textField.delegate =  delegate as? UITextFieldDelegate
        }
    }


    var inputText: String? {
        didSet {
            textField.text = inputText
        }
    }

    var textPlaceHolder: String = "" {
        didSet {
            textField.placeholder = textPlaceHolder
        }
    }

    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }

    var keyboardType: UIKeyboardType = .default {
        didSet {
            textField.keyboardType = keyboardType
        }
    }

    var returnKey: UIReturnKeyType = .next {
        didSet {
            textField.returnKeyType = returnKey
        }
    }

    var textFieldTag: Int = 0 {
        didSet {
            textField.tag = textFieldTag
        }
    }

    var isPassword = false {
        didSet {
            textField.isSecureTextEntry = isPassword
            visibleButton.isHidden = !isPassword
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    //MARK: Action 
    @IBAction private func didChangeValueTextField(sender: UITextField) {
        delegate?.textFieldCell(cell: self,
                                changeTextField: textField)
    }

    @IBAction private func didSelectVisibleText(sender: UIButton) {
        textField.isSecureTextEntry = !textField.isSecureTextEntry
        let image = textField.isSecureTextEntry ? UIImage(named: "icon_visible") : UIImage(named: "icon_invisible")
        visibleButton.setImage(image, for: .normal)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
         isPassword = false
        keyboardType = .default
    }
}


