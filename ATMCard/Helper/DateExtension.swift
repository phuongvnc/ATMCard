//
//  File.swift
//  ATMCard
//
//  Created by framgia on 5/16/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import Foundation


let dateFormatter = DateFormatter()

struct DateFormat {
    static let monthDate = "MM/yy"
    static let date = "dd/MM/yyyy"
    static let dateTime12 = "dd/MM/yyyy hh:mm:ss"
    static let dateTime24 = "dd/MM/yyyy HH:mm:ss"
}

extension Date {
    func toString(format: String, localized: Bool) -> String {
        dateFormatter.settingDateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = localized ? TimeZone.current : TimeZone(secondsFromGMT: 0)
        return dateFormatter.string(from: self)
    }
}

extension String {
    func toDate(format: String, localized: Bool) -> Date {
        dateFormatter.settingDateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = localized ? TimeZone.current : TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: self)!
    }

}

extension DateFormatter {
    func settingDateFormatter() {
        calendar = Calendar(identifier: .gregorian)
    }
}
