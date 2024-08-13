//
//  Extensions.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 13.08.2024.
//

import Foundation

extension Date {
    static func fromUnixTimeToRussianDateString(unixTime: Double) -> String {
        let date = Date(timeIntervalSince1970: unixTime)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
}
