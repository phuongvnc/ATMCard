//
//  LoginViewController.swift
//  ATMCard
//
//  Created by framgia on 5/12/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

class ShakeView: UIView, Shake { }

class LoginViewController: BaseViewController, AlertViewController {

    @IBOutlet var numberViews: [UIView]!
    @IBOutlet weak var inputNumberTextField: UITextField!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var pinCodeView: ShakeView!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        view.backgroundColor = Color.mainColor
        for numberView in numberViews {
            numberView.cornerRadius(cornerRadius: numberView.frame.width / 2)
        }
        inputNumberTextField.delegate = self
        inputNumberTextField.becomeFirstResponder()

        if let user =  UserManager.shared.getUser() {
            userNameLabel.text = user.username
        }
        userFingerPrint()
    }



    //MARK: - Actions
    @IBAction private func inputValueChanged(textField: UITextField) {
        guard let text = textField.text, let user = UserManager.shared.getUser() else {
            return
        }

        if text.characters.count <= 4 {
            updateNumberViewWithNumberCharacter(number: text.characters.count)
            if text.characters.count == 4 {
                if text == user.pincode {
                    inputNumberTextField.resignFirstResponder()
                    dismiss(animated: true, completion: nil)
                } else {
                    showAlertView(title: "Warning", message: "Pin do not math", cancelButton:  "OK", cancelAction: {
                        textField.text = ""
                        self.updateNumberViewWithNumberCharacter(number: 0)
                    })
                    wrongPinCodeOrFingerPrint()
                }
            }

        }
    }

    @IBAction private func handlerUseFingerPrint(sender: UIButton?) {
        userFingerPrint()
    }



    //MARK: - Private

    private func userFingerPrint() {
        ATMFinger().checkAuthorizationUser(completion: {
            DispatchQueue.main.async {
                self.inputNumberTextField.resignFirstResponder()
                self.updateNumberViewWithNumberCharacter(number: 4)
                self.dismiss(animated: true, completion: nil)
            }
        }) { (error) in
            if error != .userCancel {
                self.wrongPinCodeOrFingerPrint()
            }

        }
    }

    private func updateNumberViewWithNumberCharacter(number: Int) {
        for (index, numberView) in numberViews.enumerated()  {
            if index < number {
                UIView.animate(withDuration: 0.25, animations: {
                    numberView.backgroundColor =  Color.subColor
                })
            } else {
                numberView.backgroundColor = UIColor.white

            }

        }
    }

    private func wrongPinCodeOrFingerPrint() {
        pinCodeView.shake()
        Helper.vibration()
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        return textField.text!.characters.count + string.characters.count <= 4 ? true : false
    }
}

