//
//  BankListViewController.swift
//  ATMCard
//
//  Created by framgia on 5/16/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit
import RealmS
import RealmSwift

protocol BankListViewControllerDelegate: class {
    func bankViewControleller(viewController: BankListViewController, didSelectBank bank: Bank)
}

class BankListViewController: BaseViewController {

    @IBOutlet private weak var tableView: UITableView!
    fileprivate var banks: Results<Bank>!
    var selectedBank: Bank?

    weak var delegate: BankListViewControllerDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func setupUI() {
        super.setupUI()
        title = "Bank"
        tableView.registerCell(aClass: BankCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeHeaderTableView()
    }

    override func setupData() {
        super.setupData()
        banks = RealmS().objects(Bank.self)
    }
}

extension BankListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return banks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(aClass: BankCell.self) else {
            fatalError("Register Cell")
        }
        let bank  = banks[indexPath.row]
        cell.bank = bank
        if let selectedBank = selectedBank {
            cell.isChecked = selectedBank.index == bank.index
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}

extension BankListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.bankViewControleller(viewController: self,
                                       didSelectBank: banks[indexPath.row])
       let _ = navigationController?.popViewController(animated: true)
    }
}
