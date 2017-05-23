//
//  BaseViewController.swift
//  ATMCard
//
//  Created by framgia on 5/12/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol AlertViewController { }

extension AlertViewController where Self: UIViewController {
    func showAlertView(title: String?, message: String?, cancelButton: String?, otherButtons: [String]? = nil, cancelAction: (() -> ())? = nil, otherAction: ((Int) -> ())? = nil) {
        let alertViewController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)

        if let cancelButton = cancelButton {
            let cancelAction = UIAlertAction(title: cancelButton, style: .cancel, handler: { (action) in
                cancelAction?()
            })
            alertViewController.addAction(cancelAction)
        }

        if let otherButtons = otherButtons {
            for (index, otherButton) in otherButtons.enumerated() {
                let otherAction = UIAlertAction(title: otherButton,
                                                style: .default, handler: { (action) in
                                                    otherAction?(index)
                })
                alertViewController.addAction(otherAction)
            }
        }

        present(alertViewController, animated: true, completion: nil)

    }
}

class BaseViewController: UIViewController {

    var isLeftBarButtonHidden = false

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setup() { }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
        setUpNavigation()
    }

    func setupUI() { }
    
    func setupData() { }

    func setUpNavigation() {
        if !isLeftBarButtonHidden {
            if let navigationController = navigationController {
                if let first = navigationController.viewControllers.first {
                    if first.className == self.className {
                        addCloseButton()
                    } else {
                        addBackButton()
                    }
                }
            }
        }

    }


    func addLeftBarButton(image: UIImage, action: Selector) {
        let leftButton = UIBarButtonItem(image: image, style: .done, target: self, action: action)
        navigationItem.leftBarButtonItem = leftButton
    }

    func addLeftBarButton(title: String, action: Selector) {
        let leftButton = UIBarButtonItem(title: title, style: .done, target: self, action: action)
        navigationItem.leftBarButtonItem = leftButton
    }

    func addRightBarButton(image: UIImage, action: Selector) {
        let rightButton = UIBarButtonItem(image: image, style: .done, target: self, action: action)
        navigationItem.rightBarButtonItem = rightButton
    }

    func addRightBarButton(title: String, action: Selector) {
        let rightButton = UIBarButtonItem(title: title, style: .done, target: self, action: action)
        navigationItem.rightBarButtonItem = rightButton
    }

    func addCloseButton() {
        let closeBarButton = UIBarButtonItem(image: UIImage(named: "icon_close"), style: .done, target: self, action: #selector(close))
        navigationItem.leftBarButtonItem = closeBarButton
    }

    func addBackButton() {
        let backBarButton = UIBarButtonItem(image: UIImage(named: "icon_back"), style: .done, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = backBarButton

    }

    @IBAction func back() {
        view.endEditing(true)
        let _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func close() {
        view.endEditing(true)
        navigationController?.dismiss(animated: true, completion: nil)

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
}

// MARK: UIViewController
extension UIViewController {

    var className: String {
        return String(describing: type(of: self))
    }

    static func vc() -> Self? {
        if let strClass = self as? AnyClass {
            let className = String(describing: type(of: self))
            let bundle = Bundle(for: strClass)
            return self.init(nibName: className, bundle: bundle)
        }
        return nil
    }

    func push(viewController: UIViewController, animation: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animation)
    }

    var isTopViewController: Bool {
        if let topViewController = UIApplication.topViewController(), self == topViewController {
            return true
        } else {
            return false
        }
    }
}
