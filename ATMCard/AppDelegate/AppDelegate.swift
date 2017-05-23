//
//  AppDelegate.swift
//  ATMCard
//
//  Created by framgia on 5/4/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import RealmS

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var label: UILabel?

    class func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        saveBankToDisk()
        window = UIWindow(frame: UIScreen.main.bounds)
        if let _ = UserManager.shared.getUser() {
            changeHomeViewControler()
        } else {
            changeRegisterViewController()
        }
        UIApplication.shared.statusBarStyle = .lightContent
        window?.makeKeyAndVisible()
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        saveBankToDisk()
        showRequireLogin()
        return true
    }

    func changeRootViewController(viewController: UIViewController) {
        window?.rootViewController =  viewController
    }

    func changeHomeViewControler() {
        let homeNavigation = BaseNavigationController(rootViewController: HomeViewController())
        window?.rootViewController = homeNavigation
    }

    func changeRegisterViewController() {
        window?.rootViewController = RegisterViewController()
    }

    func saveBankToDisk() {
        let realm = RealmS()
        if realm.objects(Bank.self).isEmpty {
            if let dictionary = Helper.readBankJSON(), let banks = dictionary["banks"] as? [[String : Any]] {
                realm.write {
                    realm.map(Bank.self, json: banks)
                }
            }
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        showRequireLogin()
    }

    func showRequireLogin() {
        if let _ = UserManager.shared.getUser() {
            guard let viewController = UIApplication.topViewController() else {
                return
            }

            if !viewController.isKind(of: LoginViewController.self) {
                viewController.present(LoginViewController(), animated: false, completion: nil)
            }
        }

    }
}

