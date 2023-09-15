//
//  Extensions.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/23.
//

import Foundation
import Combine
import Alamofire
import UIKit

extension String {
    func localizedCountryName() -> String {
        if let name = (NSLocale(localeIdentifier: Utils.languageCode())).displayName(forKey: .countryCode, value: self) {
            // Country name was found
            return name
        } else {
            // Country name cannot be found
            return self
        }
    }
    
    func localized(_ argu: [CVarArg] = []) -> String {
        String(format: NSLocalizedString(self, comment: ""), arguments: argu)
    }
}

extension Publisher {
    func run(in set: inout Set<AnyCancellable>, next: ((Self.Output) -> Void)? = nil, complete: (() -> Void)? = nil) {
        self.subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                complete?()
            } receiveValue: { value in
                next?(value)
            }
            .store(in: &set)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    convenience init(hex: String, opacity: CGFloat = 1.0) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            self.init(.gray)
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(opacity)
        )
    }
    
    //MARK: WeatherColor
    public static let thunderstorm: UIColor = UIColor(hex: "#5F6165", opacity: 1)
    public static let drizzle: UIColor = UIColor(hex: "#A8D8E3", opacity: 1)
    public static let rain: UIColor = UIColor(hex: "#64B9FF", opacity: 1)
    public static let snow: UIColor = UIColor(hex: "#DCDCDC", opacity: 1)
    public static let atmosphere: UIColor = UIColor(hex: "#7A8B8C", opacity: 1)
    public static let clearSky: UIColor = UIColor(hex: "#FFE766", opacity: 1)
    public static let clouds: UIColor = UIColor(hex: "#B0C4DE", opacity: 1)

    
    //MARK: primeColor
    public static let backgroundColor: UIColor = UIColor(hex: "#F3F6FB")
    public static let inputBoxColor: UIColor = UIColor(hex: "#DADADA")
    public static let primeColor1: UIColor = UIColor(hex: "#F07167")
    public static let primeColor2: UIColor = UIColor(hex: "#F3968F")
    public static let primeColor3: UIColor = UIColor(hex: "#FECCB7")
    public static let primeColor4: UIColor = UIColor(hex: "#FFE8D2")
    public static let primeColor5: UIColor = UIColor(hex: "#FFEAE1")
    public static let primeColor6: UIColor = UIColor(hex: "#FFF9F9")
    
    

    //MARK: Weather
//    public static let clearSky60: UIColor = UIColor(hex: "#78D7FF", opacity: 0.4)
//    public static let fewClouds60: UIColor = UIColor(hex: "#76A5FF", opacity: 0.4)
//    public static let scatteredClouds60: UIColor = UIColor(hex: "#4971FF", opacity: 0.4)
//    public static let brokenClouds60: UIColor = UIColor(hex: "#42339B", opacity: 0.4)
//    public static let showerRain60: UIColor = UIColor(hex: "#53FFC1", opacity: 0.4)
//    public static let rain60: UIColor = UIColor(hex: "#FFB629", opacity: 0.4)
//    public static let thunderStorm60: UIColor = UIColor(hex: "#907DFF", opacity: 0.4)
//    public static let snow60: UIColor = UIColor(hex: "#FFFFFF", opacity: 0.4)
//    public static let mist60: UIColor = UIColor(hex: "#B9B9B9", opacity: 0.4)
//    public static let unknown60: UIColor = UIColor(hex: "#76A5FF", opacity: 0.4)

}


extension UIFont {
    public static let en6: UIFont = UIFont.systemFont(ofSize: 6)
    public static let en7: UIFont = UIFont.systemFont(ofSize: 7)
    public static let en8: UIFont = UIFont.systemFont(ofSize: 8)
    public static let en9: UIFont = UIFont.systemFont(ofSize: 9)
    public static let en10: UIFont = UIFont.systemFont(ofSize: 10)
    public static let en12: UIFont = UIFont.systemFont(ofSize: 12)
    public static let en14: UIFont = UIFont.systemFont(ofSize: 14)
    public static let en16: UIFont = UIFont.systemFont(ofSize: 16)
    public static let en18: UIFont = UIFont.systemFont(ofSize: 18)
    public static let en20: UIFont = UIFont.systemFont(ofSize: 20)
    public static let en22: UIFont = UIFont.systemFont(ofSize: 22)
    public static let en24: UIFont = UIFont.systemFont(ofSize: 24)
    public static let en26: UIFont = UIFont.systemFont(ofSize: 26)
    public static let en28: UIFont = UIFont.systemFont(ofSize: 28)
    public static let en30: UIFont = UIFont.systemFont(ofSize: 30)
    public static let en32: UIFont = UIFont.systemFont(ofSize: 32)
    public static let en34: UIFont = UIFont.systemFont(ofSize: 34)
    public static let en36: UIFont = UIFont.systemFont(ofSize: 36)
    public static let en38: UIFont = UIFont.systemFont(ofSize: 38)
    public static let en40: UIFont = UIFont.systemFont(ofSize: 40)
    public static let en42: UIFont = UIFont.systemFont(ofSize: 42)
    public static let en44: UIFont = UIFont.systemFont(ofSize: 44)
    public static let en46: UIFont = UIFont.systemFont(ofSize: 46)
    public static let en48: UIFont = UIFont.systemFont(ofSize: 48)
    
    public static let en6r: UIFont = UIFont.systemFont(ofSize: 6, weight: .regular)
    public static let en7r: UIFont = UIFont.systemFont(ofSize: 7, weight: .regular)
    public static let en8r: UIFont = UIFont.systemFont(ofSize: 8, weight: .regular)
    public static let en9r: UIFont = UIFont.systemFont(ofSize: 9, weight: .regular)
    public static let en10r: UIFont = UIFont.systemFont(ofSize: 10, weight: .regular)
    public static let en12r: UIFont = UIFont.systemFont(ofSize: 12, weight: .regular)
    public static let en14r: UIFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    public static let en16r: UIFont = UIFont.systemFont(ofSize: 16, weight: .regular)
    public static let en18r: UIFont = UIFont.systemFont(ofSize: 18, weight: .regular)
    public static let en20r: UIFont = UIFont.systemFont(ofSize: 20, weight: .regular)
    public static let en22r: UIFont = UIFont.systemFont(ofSize: 22, weight: .regular)
    public static let en24r: UIFont = UIFont.systemFont(ofSize: 24, weight: .regular)
    public static let en26r: UIFont = UIFont.systemFont(ofSize: 26, weight: .regular)
    public static let en28r: UIFont = UIFont.systemFont(ofSize: 28, weight: .regular)
    public static let en30r: UIFont = UIFont.systemFont(ofSize: 30, weight: .regular)
    public static let en32r: UIFont = UIFont.systemFont(ofSize: 32, weight: .regular)
    public static let en34r: UIFont = UIFont.systemFont(ofSize: 34, weight: .regular)
    public static let en36r: UIFont = UIFont.systemFont(ofSize: 36, weight: .regular)
    public static let en38r: UIFont = UIFont.systemFont(ofSize: 38, weight: .regular)
    public static let en40r: UIFont = UIFont.systemFont(ofSize: 40, weight: .regular)
    public static let en42r: UIFont = UIFont.systemFont(ofSize: 42, weight: .regular)
    public static let en44r: UIFont = UIFont.systemFont(ofSize: 44, weight: .regular)
    public static let en46r: UIFont = UIFont.systemFont(ofSize: 46, weight: .regular)
    public static let en48r: UIFont = UIFont.systemFont(ofSize: 48, weight: .regular)
    
    public static let en6b: UIFont = UIFont.systemFont(ofSize: 6, weight: .bold)
    public static let en7b: UIFont = UIFont.systemFont(ofSize: 7, weight: .bold)
    public static let en8b: UIFont = UIFont.systemFont(ofSize: 8, weight: .bold)
    public static let en9b: UIFont = UIFont.systemFont(ofSize: 9, weight: .bold)
    public static let en10b: UIFont = UIFont.systemFont(ofSize: 10, weight: .bold)
    public static let en12b: UIFont = UIFont.systemFont(ofSize: 12, weight: .bold)
    public static let en14b: UIFont = UIFont.systemFont(ofSize: 14, weight: .bold)
    public static let en16b: UIFont = UIFont.systemFont(ofSize: 16, weight: .bold)
    public static let en18b: UIFont = UIFont.systemFont(ofSize: 18, weight: .bold)
    public static let en20b: UIFont = UIFont.systemFont(ofSize: 20, weight: .bold)
    public static let en22b: UIFont = UIFont.systemFont(ofSize: 22, weight: .bold)
    public static let en24b: UIFont = UIFont.systemFont(ofSize: 24, weight: .bold)
    public static let en26b: UIFont = UIFont.systemFont(ofSize: 26, weight: .bold)
    public static let en28b: UIFont = UIFont.systemFont(ofSize: 28, weight: .bold)
    public static let en30b: UIFont = UIFont.systemFont(ofSize: 30, weight: .bold)
    public static let en32b: UIFont = UIFont.systemFont(ofSize: 32, weight: .bold)
    public static let en34b: UIFont = UIFont.systemFont(ofSize: 34, weight: .bold)
    public static let en36b: UIFont = UIFont.systemFont(ofSize: 36, weight: .bold)
    public static let en38b: UIFont = UIFont.systemFont(ofSize: 38, weight: .bold)
    public static let en40b: UIFont = UIFont.systemFont(ofSize: 40, weight: .bold)
    public static let en42b: UIFont = UIFont.systemFont(ofSize: 42, weight: .bold)
    public static let en44b: UIFont = UIFont.systemFont(ofSize: 44, weight: .bold)
    public static let en46b: UIFont = UIFont.systemFont(ofSize: 46, weight: .bold)
    public static let en48b: UIFont = UIFont.systemFont(ofSize: 48, weight: .bold)
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let newSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { context in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }

    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let scale = width / size.width
        let newHeight = size.height * scale
        let newSize = CGSize(width: width, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { context in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    
    func resized(toSize newSize: CGSize, isOpaque: Bool = true) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { context in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
