//
//  SelectLocationViewModel.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/18.
//

import Foundation
import Combine
import Alamofire
import CoreLocation

enum AddLocationStatus {
    case ready
    case entering
    case searching
    case finished(result: [Geocoding])
    case select(result: [Geocoding], item: Geocoding)
}

typealias GeocodingItem = (idx: Int, item: Geocoding)

protocol SelectLocationViewModel: SelectLocationViewModelInput, SelectLocationViewModelOutput { }

protocol SelectLocationViewModelInput {
    var name: Observable<String> { get }
    //    var selectedItem: Observable<GeocodingItem?> { get }
    func viewWillAppear()
    func viewDidLoad()
    func onClickSearch()
    func onClickAddLocation()
    func onClickCancel()
    func entering(_ value: String?)
    func onClickItem(_ idx: Int)
}

protocol SelectLocationViewModelOutput {
    var isLoading: Observable<Bool> { get }
    var existItems: [Location] { get }
    var status: Observable<AddLocationStatus> { get }
}

class DefaultSelectLocationViewModel: BaseViewModel, SelectLocationViewModel {
    private let weatherService: WeatherService
    private let locationService: LocationService
    private let weatherServiceV2: WeatherServiceV2
    private let locationRespository: AnyRepository<Location>
    private let geocodingService: GeocodingService
    
    //    var results: [Geocoding] = []
    var name: Observable<String> = Observable("")
    var isLoading: Observable<Bool> = Observable(false)
    //    var selectedItem: Observable<GeocodingItem?> = Observable(nil)
    var existItems: [Location] = []
    var status: Observable<AddLocationStatus> = Observable(.ready)
    
    
    init(_ coordinator: AppCoordinator, locationRespository: AnyRepository<Location>, weatherService: WeatherService, weatherServiceV2: WeatherServiceV2, locationService: LocationService, geocodingService: GeocodingService) {
        self.locationRespository = locationRespository
        self.weatherService = weatherService
        self.weatherServiceV2 = weatherServiceV2
        self.locationService = locationService
        self.geocodingService = geocodingService
        super.init(coordinator)
    }
    
    func viewWillAppear() {
        
    }
    
    func viewDidLoad() {
        self.existItems = Defaults.locations
    }
    
    func onClickSearch() {
        if self.isLoading.value || self.name.value.isEmpty || self.name.value == " " {
            return
        }
        
        self.isLoading.value = true
        self.status.value = .searching
        var geocodings: [Geocoding] = []
        var geocodingResponses: [GeocodingResponse] = []
        var reverseResponses: [ReverseGeocoding] = []
        
        self.geocodingService.getGeocoding(name.value)
            .map {responses -> [GeocodingResponse] in
                geocodingResponses = responses.value ?? []
                print("[step1] \(geocodingResponses)")
                return geocodingResponses
            }
            .flatMap { (responses: [GeocodingResponse]) in
                responses.publisher
                    .flatMap { response in
                        self.geocodingService.getReverseGeocoding(response).eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
                    .collect()
            }
            .eraseToAnyPublisher()
            .collect()
            .flatMap({ responses in
                for response in responses {
                    for output in response {
                        if let value = output.value {
                            reverseResponses.append(value)
                        }
                    }
                }
                print("[step2] \(reverseResponses)")
                let publisher1 = geocodingResponses.publisher
                let publisher2 = reverseResponses.publisher
                return Publishers.Zip(publisher1, publisher2).eraseToAnyPublisher()
            })
            .run(in: &self.subscription, next: { output in
                geocodings.append(Geocoding(geocoding: output.0, reverse: output.1))
            }, complete: {[weak self] in
                guard let self = self else { return }
                print("complete")
                self.status.value = .finished(result: geocodings)
                self.isLoading.value = false
            })
    }
    
    func onClickAddLocation() {
        guard case let .select(_, item) = self.status.value else { return }
        if Defaults.locations.count >= C.LOCATION_LIMMIT {
            self.coordinator.presentAlertView(.ok(onClickOk: {
                
            }), title: "location_limit_title".localized(), message: "location_limit_description".localized([String(C.LOCATION_LIMMIT)]))
            return
        }
        
        
        let location = Location(lat: item.lat, lon: item.lon, isStar: false, isCurrent: false, name: item.localName, address: item.address)
        try? self.locationRespository.insert(item: location)
        Defaults.locations.append(location)
        self.coordinator.pop()
    }
    
    func onClickCancel() {
        self.status.value = .ready
    }
    
    func entering(_ value: String?) {
        self.status.value = .entering
        self.name.value = value ?? ""
    }
    
    func onClickItem(_ idx: Int) {
        switch self.status.value {
        case .ready, .entering, .searching:
            return
        case let .finished(result):
            if result.count - 1 < idx { return }
            if self.existItems.contains(where: {  loc in
                loc.lat == result[idx].lat && loc.lon == result[idx].lon
            }) {
                return
            }
            self.status.value = .select(result: result, item: result[idx])
            return
        case let .select(result, item):
            if result.count - 1 < idx { return }
            if self.existItems.contains(where: {  loc in
                loc.lat == result[idx].lat && loc.lon == result[idx].lon
            }) {
                return
            }
            if result[idx] == item {
                self.status.value = .finished(result: result)
            } else {
                self.status.value = .select(result: result, item: result[idx])
            }
            return
        }
        
    }
}
