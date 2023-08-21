//
//  Utils.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/27.
//

import Foundation
import UIKit

final class Utils {
    static func languageCode() -> String {
//        print("[1] preferredLocalizations: \(Bundle.main.preferredLocalizations.first)")
//        print("[1] list: \(Bundle.main.preferredLocalizations)")
//        print("[2] current: \(Locale.current.languageCode)")
        return Bundle.main.preferredLocalizations.first ?? "en"
    }
    
    static func regionCode() -> String {
        return Locale.current.regionCode ?? "US"
    }
    
    static func intervalToHour(_ interval: Int) -> String {
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_kr")
        date.dateFormat = "a hh시"

        return date.string(from: Date(timeIntervalSince1970: TimeInterval(interval)))
    }
    
    static func intervalToWeekday(_ interval: Int) -> String {
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_kr")
        date.dateFormat = "EEEE"

        return date.string(from: Date(timeIntervalSince1970: TimeInterval(interval)))
    }
    
    static func intervalToHourMin(_ interval: Int) -> String {
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_kr")
        date.dateFormat = "hh:mm"
        return date.string(from: Date(timeIntervalSince1970: TimeInterval(interval)))
    }
}
