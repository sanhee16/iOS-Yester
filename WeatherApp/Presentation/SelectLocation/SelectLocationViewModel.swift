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
//    var results: Observable<[Geocoding]> { get }
//    var isSearching: Observable<Bool> { get }
    var existItems: [Location] { get }
    var status: Observable<AddLocationStatus> { get }
}

class DefaultSelectLocationViewModel: BaseViewModel, SelectLocationViewModel {
    private let weatherService: WeatherService
    private let locationService: LocationService
    private let weatherServiceV2: WeatherServiceV2
    private let locationRespository: AnyRepository<Location>
    
//    var results: [Geocoding] = []
    var name: Observable<String> = Observable("")
    var isSearching: Bool = false
//    var selectedItem: Observable<GeocodingItem?> = Observable(nil)
    var existItems: [Location] = []
    var status: Observable<AddLocationStatus> = Observable(.ready)
    
    
    init(_ coordinator: AppCoordinator, locationRespository: AnyRepository<Location>, weatherService: WeatherService, weatherServiceV2: WeatherServiceV2, locationService: LocationService) {
        self.locationRespository = locationRespository
        self.weatherService = weatherService
        self.weatherServiceV2 = weatherServiceV2
        self.locationService = locationService
        super.init(coordinator)
    }
    
    func viewWillAppear() {
        
    }
    
    func viewDidLoad() {
        self.existItems = Defaults.locations
    }
    
    func onClickSearch() {
        if self.isSearching || self.name.value.isEmpty || self.name.value == " " {
            return
        }
        
        self.isSearching = true
        self.status.value = .searching
        
        Publishers.Zip(
            self.weatherService.getGeocoding("\(name.value),\(Utils.regionCode())"),
            self.weatherService.getGeocoding(name.value)
        )
        .run(in: &self.subscription) {[weak self] (res1, res2) in
            guard let self = self else { return }
            var apiResult = res1.value ?? []
            let result2 = res2.value?.filter({ geo in
                !apiResult.contains { i in
                    i.lat == geo.lat && i.lon == geo.lon
                }
            })
            
            apiResult.append(contentsOf: result2 ?? [])
            self.isSearching = false
//            self.results = apiResult
            self.status.value = .finished(result: apiResult)
        } complete: {[weak self] in
            guard let self = self else { return }
            self.isSearching = false
            print("complete")
        }
    }
    
    func onClickAddLocation() {
        guard case let .select(_, item) = self.status.value else { return }
        print(item)
        let location = Location(lat: item.lat, lon: item.lon, isStar: false, isCurrent: false, name: item.localName)
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
