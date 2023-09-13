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
        date.locale = Locale(identifier: languageCode())
        date.dateFormat = "a hh"

        return date.string(from: Date(timeIntervalSince1970: TimeInterval(interval)))
    }
    
    static func intervalToWeekday(_ interval: Int) -> String {
        let date = DateFormatter()
        date.locale = Locale(identifier: languageCode())
        date.dateFormat = "EEEE"

        return date.string(from: Date(timeIntervalSince1970: TimeInterval(interval)))
    }
    
    static func intervalToHourMin(_ interval: Int) -> String {
        let date = DateFormatter()
        date.locale = Locale(identifier: languageCode())
        date.dateFormat = "hh:mm"
        return date.string(from: Date(timeIntervalSince1970: TimeInterval(interval)))
    }
    
    static func intervalSunTime(_ interval: Int) -> String {
        let date = DateFormatter()
        date.locale = Locale(identifier: languageCode())
        date.dateFormat = "a hh:mm"
        return date.string(from: Date(timeIntervalSince1970: TimeInterval(interval)))
    }
    
    static func oneDayBefore() -> String {
        let today = Date()
        let date = DateFormatter()
        
        date.locale = Locale(identifier: languageCode())
        date.dateFormat = "yyyy-MM-dd"
        let modifiedDate = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        
        return date.string(from: modifiedDate)
    }
    
    private static func getUnitKey(key: String) -> String? {
        guard let value = C.units[key] else { return nil }
        switch key {
        case C.UNIT_TEMP:
            return TemperatureUnitV2(rawValue: value)?.keys
        case C.UNIT_WIND:
            return WindUnitV2(rawValue: value)?.keys
        case C.UNIT_PREC:
            return PrecipitationUnitV2(rawValue: value)?.keys
        default:
            return nil
        }
    }
    
    private static func getUnitText(key: String) -> String? {
        guard let value = C.units[key] else { return nil }
        switch key {
        case C.UNIT_TEMP:
            return TemperatureUnitV2(rawValue: value)?.units
        case C.UNIT_WIND:
            return WindUnitV2(rawValue: value)?.units
        case C.UNIT_PREC:
            return PrecipitationUnitV2(rawValue: value)?.units
        default:
            return nil
        }
    }
    
    static func getTempUnit() -> TemperatureUnitV2 { return TemperatureUnitV2(rawValue: C.units[C.UNIT_TEMP] ?? 0) ?? .celsius }
    static func getWindUnit() -> WindUnitV2 { return WindUnitV2(rawValue: C.units[C.UNIT_WIND] ?? 0) ?? .kph }
    static func getPrecUnit() -> PrecipitationUnitV2 { return PrecipitationUnitV2(rawValue: C.units[C.UNIT_PREC] ?? 0) ?? .inch }
    
    static func getTempUnitText() -> String { return "°" } // Self.getUnitText(key: C.UNIT_TEMP) ?? ""
    static func getWindUnitText() -> String { return Self.getUnitText(key: C.UNIT_WIND) ?? "" }
    static func getPrecUnitText() -> String { return Self.getUnitText(key: C.UNIT_PREC) ?? "" }
    
    static func systemImage(_ systemName: String, weight: UIImage.SymbolWeight = .medium, color: UIColor? = nil, size: CGFloat) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: size, weight: weight, scale: .large)
        let image = UIImage(systemName: systemName, withConfiguration: config)
        if let color = color {
            return image?.withTintColor(color, renderingMode: .alwaysOriginal)
        } else {
            return image
        }
    }
}
