//
//  UserManager.swift
//  ATMCard
//
//  Created by framgia on 5/12/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import Foundation

class UserManager {

    static var shared = UserManager()
    private var user: User?

    init() {
        reloadUserFromDB()
    }

    func reloadUserFromDB() {
        let path = pathForUserDataFile()
        if FileManager.default.fileExists(atPath: path) {
            user = (NSKeyedUnarchiver.unarchiveObject(withFile: path) as? User)
        }
    }

    func save() {
        if let user = user {
            let path = pathForUserDataFile()
            let saved = NSKeyedArchiver.archiveRootObject(user, toFile: path)
            if !saved {
                assertionFailure("Save user info failed")
            }
        }
    }

    private func pathForUserDataFile() -> String {

        let documentsFolderPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/" + "user_data.file"
        return documentsFolderPath
    }

    func getUser() -> User? {
        return user
    }

    func setUser(user: User) {
        self.user = user
        save()
    }


}
