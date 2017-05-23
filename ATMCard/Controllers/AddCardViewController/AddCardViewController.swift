//
//  AddCardViewController.swift
//  ATMCard
//
//  Created by framgia on 5/15/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit
import RealmS

enum SectionIndex: Int {
    case bank = 0
    case account
}

enum BankIndex : Int {
    case bank = 0
    case cardType
    case accountNumber
    case cardNumber
    case cardPlaceHolder
    case expireDate
    case cvc

    var title: String {
        switch self {
        case .bank:
            return "Bank"
        case .accountNumber:
            return "Account number"
        case .cardType:
            return "Card type"
        case .cardNumber:
            return "Card number"
        case .cardPlaceHolder:
            return "Card placeholder"
        case .expireDate:
            return "Expire date"
        case .cvc:
            return "CVC"
        }
    }

    var tag: Int {
        switch self {
        case .accountNumber:
            return 100
        case .cardNumber:
            return 200
        case .cardPlaceHolder:
            return 300
        case .cvc:
            return 400
        default:
            return 0
        }
    }

}

enum AccountIndex: Int {
    case accountName = 0
    case accountPass

    var title: String {
        switch self {
        case .accountName:
            return "Account"
        case .accountPass:
            return "Password"
        }
    }

    var tag: Int {
        switch self {
        case .accountName:
            return 500
        case .accountPass:
            return 600
        }
    }
}

class AddCardViewController: BaseViewController, AlertViewController {

    @IBOutlet fileprivate weak var tableView: UITableView!
    let realm = RealmS()
    var bank: Bank?

    fileprivate var cardType: CardType?
    fileprivate var accountNumber = ""
    fileprivate var cardNumber = ""
    fileprivate var cardPlaceHolder = ""
    fileprivate var expireDate: Date?
    fileprivate var cvc = ""
    fileprivate var accountName = ""
    fileprivate var accountPass = ""

    fileprivate var datePickerView: ATMDatePicker?




    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        title = "Add Card"
        tableView.registerCell(aClass: AddCardTextFieldCell.self)
        tableView.registerCell(aClass: AddCardButtonCell.self)
        tableView.registerCell(aClass: BankCell.self)
        tableView.registerCell(aClass: CardTypeCell.self)
        tableView.delegate = self
        tableView.dataSource = self

        addRightBarButton(title: "Add", action: #selector(didSelectAdd(sender:)))
    }

    override func setupData() {

    }

    fileprivate func setupDatePickerView() {
        
    }


    fileprivate func cellForBank(bankIndex: BankIndex) -> UITableViewCell {
        switch bankIndex {
        case .bank:
            if let bank = bank {
                let cell = tableView.dequeueCell(aClass: BankCell.self)!
                cell.bank = bank
                return cell
            } else {
                let cell = tableView.dequeueCell(aClass: AddCardButtonCell.self)!
                cell.title = bankIndex.title
                return cell
            }
        case .cardType:
            if let cardType = cardType {
                let cell = tableView.dequeueCell(aClass: CardTypeCell.self)!
                cell.cardType = cardType
                return cell
            } else {
                let cell = tableView.dequeueCell(aClass: AddCardButtonCell.self)!
                cell.title = bankIndex.title
                return cell
            }

        case .accountNumber:
            let cell = tableView.dequeueCell(aClass: AddCardTextFieldCell.self)!
            cell.inputText = accountNumber
            cell.title = bankIndex.title
            cell.returnKey = .next
            cell.keyboardType = .numberPad
            cell.delegate = self
            cell.textFieldTag = bankIndex.tag
            return cell
        case .cardNumber:
            let cell = tableView.dequeueCell(aClass: AddCardTextFieldCell.self)!
            cell.inputText = cardNumber
            cell.title = bankIndex.title
            cell.returnKey = .next
            cell.delegate = self
            cell.textFieldTag = bankIndex.tag
            cell.keyboardType = .numberPad
            return cell
        case .cardPlaceHolder:
            let cell = tableView.dequeueCell(aClass: AddCardTextFieldCell.self)!
            cell.inputText = cardPlaceHolder
            cell.title = bankIndex.title
            cell.returnKey = .next
            cell.delegate = self
            cell.textFieldTag = bankIndex.tag
            return cell
        case .expireDate:
            let cell = tableView.dequeueCell(aClass: AddCardButtonCell.self)!
            cell.title = bankIndex.title
            cell.subTitle = expireDate?.toString(format: DateFormat.monthDate, localized: false)
            return cell
        case .cvc:
            let cell = tableView.dequeueCell(aClass: AddCardTextFieldCell.self)!
            cell.inputText = cvc
            cell.title = bankIndex.title
            cell.returnKey = .next
            cell.keyboardType = .numberPad
            cell.delegate = self
            cell.textFieldTag = bankIndex.tag
            return cell
        }
    }

    fileprivate func cellForAccount(accountIndex: AccountIndex) -> UITableViewCell {
        switch accountIndex {
        case .accountName:
            let cell = tableView.dequeueCell(aClass: AddCardTextFieldCell.self)!
            cell.inputText = accountName
            cell.title = accountIndex.title
            cell.returnKey = .next
            cell.delegate = self
            cell.textFieldTag = accountIndex.tag
            return cell
        case .accountPass:
            let cell = tableView.dequeueCell(aClass: AddCardTextFieldCell.self)!
            cell.inputText = accountPass
            cell.title = accountIndex.title
            cell.returnKey = .next
            cell.delegate = self
            cell.textFieldTag = accountIndex.tag
            cell.isPassword = true
            return cell
        }
    }


   fileprivate func updateExpireDate(date: Date) {
        expireDate = date
        let indexPath = IndexPath(row: BankIndex.expireDate.rawValue,
                                  section: SectionIndex.bank.rawValue)
        guard let cell = tableView.cellForRow(at: indexPath) as? AddCardButtonCell else {
            return
        }
        cell.subTitle = date.toString(format: DateFormat.monthDate, localized: false)
    }

    fileprivate func validateData() -> Bool{
        guard let _ = bank else {
            showAlertView(title: "Warning", message: "Please choose bank", cancelButton: "OK")
            return false
        }

        guard let _ = cardType else {
            showAlertView(title: "Warning", message: "Please choose cardtype", cancelButton: "OK")
            return false
        }


        guard !accountNumber.isEmpty else {
            showAlertView(title: "Warning", message: "Please input account number", cancelButton: "OK")
            return false
        }

        guard !cardNumber.isEmpty else {
            showAlertView(title: "Warning", message: "Please input card number", cancelButton: "OK")
            return false
        }

        guard !cardPlaceHolder.isEmpty else {
            showAlertView(title: "Warning", message: "Please input card placeholder", cancelButton: "OK")
            return false
        }

        return true
    }


    //MARK: - Actions

    func didSelectAdd(sender: UIBarButtonItem) {
        if validateData() {
            let card = Card()
            card.bank = bank
            card.type = cardType ?? .atm
            card.accountNumber = accountNumber
            card.cardNumber = cardNumber
            card.cardPlaceHolder = cardPlaceHolder
            card.expireDate = expireDate
            card.cvc = cvc
            let account = InternetBanking()
            account.username = accountName
            account.password = accountPass
            card.internetBanking = account
            realm.write {
                realm.add(card)
                self.dismiss(animated: true, completion: nil)
            }

        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }



}

extension AddCardViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionIndex = SectionIndex(rawValue: section) else {
            return 0
        }

        switch sectionIndex {
        case .bank:
            return cardType == .atm || cardType.isEmpty ? 5 : 7
        case .account:
            return 2
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionIndex = SectionIndex(rawValue: indexPath.section) else {
            fatalError()
        }
        switch sectionIndex {
        case .bank:
            guard let bankIndex = BankIndex(rawValue: indexPath.row) else {
                fatalError()
            }

            return cellForBank(bankIndex: bankIndex)

        case .account:
            guard let accountIndex = AccountIndex(rawValue: indexPath.row) else {
                fatalError()
            }

            return cellForAccount(accountIndex: accountIndex)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let sectionIndex = SectionIndex(rawValue: indexPath.section) else {
            return 0
        }
        switch sectionIndex {
        case .bank:
            guard let bankIndex = BankIndex(rawValue: indexPath.row) else {
                return 0
            }
            if bankIndex == .bank, let _ = bank {
                return 65
            }

            if bankIndex == .cardType, let _ = cardType {
                return 65
            }
            return 60
        default:
            return 60
        }
    }
}

extension AddCardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let sectionIndex = SectionIndex(rawValue: indexPath.section) else {
            return
        }
        if sectionIndex == .bank {
            guard let bankIndex = BankIndex(rawValue: indexPath.row) else {
                return
            }

            if bankIndex == .bank {
                let bankListViewController = BankListViewController()
                bankListViewController.delegate = self
                bankListViewController.selectedBank = bank
                push(viewController: bankListViewController)
            }

            if bankIndex == .cardType {
                let cardTypeViewController = CardTypeListViewController()
                cardTypeViewController.model = CardTypeViewModel(selectCardType: cardType,delegate : self)
                push(viewController: cardTypeViewController)
            }

            if bankIndex == .expireDate {
                view.endEditing(true)
                if datePickerView.isEmpty {
                    datePickerView = ATMDatePicker(mode: .date)
                    datePickerView?.delegate = self
                }

                datePickerView?.show(inView: view)
            }

        }
    }
}

extension AddCardViewController: AddCardTextFieldCellDelegate {
    func textFieldCell(cell: AddCardTextFieldCell, changeTextField textField: UITextField) {
        guard let indexPath = tableView.indexPath(for: cell),let sectionIndex = SectionIndex(rawValue: indexPath.section) else {
            return
        }

        switch sectionIndex {
        case .bank:
            guard let bankIndex = BankIndex(rawValue: indexPath.row) else {
                fatalError()
            }
            switch bankIndex {
            case .accountNumber:
                accountNumber = textField.text ?? ""
                break
            case .cardNumber:
                textField.text = Helper.convertStringToAccount(string: Helper.convertAccountToString(string: textField.text ?? ""))
                cardNumber = Helper.convertAccountToString(string: textField.text ?? "")

                break
            case .cardPlaceHolder:
                cardPlaceHolder = textField.text ?? ""
                break
            case .cvc:
                cvc = textField.text ?? ""
                break
            default:
                break
            }

        case .account:
            guard let accountIndex = AccountIndex(rawValue: indexPath.row) else {
                fatalError()
            }

            switch accountIndex {
            case .accountName:
                accountName = textField.text ?? ""
                break
            case .accountPass:
                accountPass = textField.text ?? ""
                break
            }
        }
        
        
    }

}

extension AddCardViewController: BankListViewControllerDelegate {

    func bankViewControleller(viewController: BankListViewController, didSelectBank bank: Bank) {
        self.bank = bank
        let indexPath = IndexPath(row: BankIndex.bank.rawValue,
                                  section: SectionIndex.bank.rawValue)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension AddCardViewController: CardTypeListViewControllerDelegate {

    func  cardTypeViewControleller(viewController: CardTypeListViewController, didSelectCardType cardType: CardType) {
        self.cardType = cardType
        tableView.reloadSections(IndexSet(integer: SectionIndex.bank.rawValue)
 ,with: .none)
    }
}

extension AddCardViewController: ATMDatePickerDelegate {
    func datePickerSelectCancel(datePicker: ATMDatePicker) {
        datePicker.hide(animated: true)
    }

    func datePicker(datePicker: ATMDatePicker, didSelectDate date: Date) {
        updateExpireDate(date: date)
    }

    func datePicker(datePicker: ATMDatePicker, selectDoneDate date: Date) {
        updateExpireDate(date: date)
        datePicker.hide(animated: true)
    }
}

extension AddCardViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let newTag = textField.tag + 100
        if let textField = view.viewWithTag(newTag) {
            textField.becomeFirstResponder()
        } else {
            if let textField = view.viewWithTag(textField.tag) {
                textField.resignFirstResponder()
            }
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        let tag = textField.tag
        if tag == BankIndex.cardNumber.tag {
            textField.text = Helper.convertAccountToString(string: cardNumber)
        }
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let tag = textField.tag
        if tag == BankIndex.cardNumber.tag {
            textField.text = Helper.convertStringToAccount(string: cardNumber)
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" { return true }
        let tag = textField.tag
        if tag == BankIndex.cardNumber.tag {
            let text = Helper.convertAccountToString(string: textField.text ?? "" + string)
            return text.characters.count < 16
        }
        return true



    }

}

