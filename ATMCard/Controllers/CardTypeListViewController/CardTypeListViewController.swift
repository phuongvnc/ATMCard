//
//  CardTypeListViewController.swift
//  ATMCard
//
//  Created by framgia on 5/16/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

import UIKit
import RealmS
import RealmSwift

protocol CardTypeListViewControllerDelegate: class {
    func cardTypeViewControleller(viewController: CardTypeListViewController, didSelectCardType cardType: CardType)
}

class CardTypeListViewController : BaseViewController {

    @IBOutlet private weak var tableView: UITableView!
    weak var delegate: CardTypeListViewControllerDelegate?
    var model: CardTypeViewModel!


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        super.setupUI()
        title = "Bank"
        tableView.registerCell(aClass: CardTypeCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeHeaderTableView()
        delegate = model.delegate
    }

    override func setupData() {
        super.setupData()
    }
}

extension CardTypeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfRow(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(aClass: CardTypeCell.self) else {
            fatalError("Register Cell")
        }
        
        let cardType  = model.cardType[indexPath.row]
        cell.cardType = cardType
        cell.isChecked = model.checkSelectCardType(cardType)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return model.heighForRow(atIndexPath: indexPath)
    }
}

extension CardTypeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.cardTypeViewControleller(viewController: self,
                                       didSelectCardType: model.cardType[indexPath.row])
        navigationController?.popToViewController(animated: true)
    }
}
