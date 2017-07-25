//
//  RegisterViewController.swift
//  ATMCard
//
//  Created by framgia on 5/12/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

private struct Options {
    static let textFieldCornerRadius: CGFloat = 25
    static let buttonCornerRadius: CGFloat = 20
}

class RegisterViewController: BaseViewController, AlertViewController {

    @IBOutlet private weak var fullNameTextField: UITextField!
    @IBOutlet private weak var passCodeTextField: UITextField!
    @IBOutlet private weak var confirmPassCodeTextField: UITextField!
    @IBOutlet private weak var registerButton: UIButton!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        title = "Register"
        fullNameTextField.cornerRadius(cornerRadius: Options.textFieldCornerRadius)
        passCodeTextField.cornerRadius(cornerRadius: Options.textFieldCornerRadius)
        confirmPassCodeTextField.cornerRadius(cornerRadius: Options.textFieldCornerRadius)
        registerButton.cornerRadius(cornerRadius: Options.buttonCornerRadius)

        passCodeTextField.delegate = self
        confirmPassCodeTextField.delegate = self
    }


    private func validateData() -> Bool {

        guard let userName = fullNameTextField.text, !userName.isEmpty else {
            showAlertView(title: "Warning", message: "Please input full name", cancelButton: "OK")
            return false
        }

        guard let pinCode = passCodeTextField.text, !pinCode.isEmpty else {
            showAlertView(title: "Warning", message: "Please input PIN code", cancelButton: "OK")
            return false
        }

        guard let confirmPinCode = confirmPassCodeTextField.text, !confirmPinCode.isEmpty else {
            showAlertView(title: "Warning", message: "Please input confirm PIN code", cancelButton: "OK")
            return false
        }

        guard pinCode == confirmPinCode else {
            showAlertView(title: "Warning", message: "Pin code and confirm pin code are diffrent", cancelButton: "OK")
            return false
        }

        return true
    }

    @IBAction private func handlerSelectRegister(sender: UIButton) {
        if validateData() {
            let user = User(username: fullNameTextField.text!, pincode: passCodeTextField.text!)
            UserManager.shared.setUser(user: user)
            AppDelegate.shared().changeHomeViewControler()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

}

extension RegisterViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        return textField.text!.characters.count +  string.characters.count <= 4 ? true : false
    }
}
