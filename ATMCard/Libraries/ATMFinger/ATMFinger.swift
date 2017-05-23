//
//  ATMFinger.swift
//  ATMCard
//
//  Created by framgia on 5/12/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import Foundation
import LocalAuthentication

enum ATMFingerError: Int {

    case authenticationFailed

    case userCancel

    case userFallback

    case systemCancel

    case passcodeNotSet

    case touchIDNotAvailable

    case touchIDNotEnrolled

    case touchIDLockout

    case appCancel

    case invalidContext

    case other
}

class ATMFinger {

    func checkAuthorizationUser(completion: @escaping () -> (), failure:  ((ATMFingerError) -> ())?) {
        let context = LAContext()

        var error: NSError?
        let localizeReason = "ATM Card need access your fingerprint"

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizeReason , reply: { (success, error) in
                if success {
                    completion()
                } else {
                    if let error = error as? NSError {
                        failure?(self.checkErrorCode(code: error.code))
                    } else {
                        failure?(ATMFingerError.other)
                    }
                }
            })
        }
    }

    func checkErrorCode(code: Int) -> ATMFingerError {
        switch code {
        case LAError.authenticationFailed.rawValue:
            return ATMFingerError.authenticationFailed
        case LAError.userCancel.rawValue:
            return ATMFingerError.userCancel
        case LAError.userFallback.rawValue:
            return ATMFingerError.userFallback
        case LAError.systemCancel.rawValue:
            return ATMFingerError.systemCancel
        case LAError.passcodeNotSet.rawValue:
            return ATMFingerError.passcodeNotSet
        case LAError.touchIDNotAvailable.rawValue:
            return ATMFingerError.touchIDNotAvailable
        case LAError.touchIDNotEnrolled.rawValue:
            return ATMFingerError.touchIDNotEnrolled
        case LAError.touchIDLockout.rawValue:
            return ATMFingerError.touchIDLockout
        case LAError.appCancel.rawValue:
            return ATMFingerError.appCancel
        case LAError.invalidContext.rawValue:
            return ATMFingerError.invalidContext
        default:
            return ATMFingerError.other
        }
    }
}
