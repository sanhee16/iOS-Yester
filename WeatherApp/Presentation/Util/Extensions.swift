//
//  Extensions.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/23.
//

import Foundation
import Combine
import Alamofire

extension String {
    func localizedCountryName() -> String {
        if let name = (NSLocale(localeIdentifier: Bundle.main.preferredLocalizations.first ?? "en")).displayName(forKey: .countryCode, value: self) {
            // Country name was found
            return name
        } else {
            // Country name cannot be found
            return self
        }
    }

    func languageCode() -> String {
        return Bundle.main.preferredLocalizations.first ?? "en"
    }
    
    func regionCode() -> String {
        return Locale.current.regionCode ?? "US"
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

