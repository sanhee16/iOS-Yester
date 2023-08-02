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
        print("[1] preferredLocalizations: \(Bundle.main.preferredLocalizations.first)")
        print("[1] list: \(Bundle.main.preferredLocalizations)")
        print("[2] current: \(Locale.current.languageCode)")
        return Bundle.main.preferredLocalizations.first ?? "en"
    }
    
    static func regionCode() -> String {
        return Locale.current.regionCode ?? "US"
    }
    
}
