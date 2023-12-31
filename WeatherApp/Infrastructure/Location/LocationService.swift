//
//  LocationService.swift
//  WeatherApp
//
//  Created by sandy on 2023/08/02.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    var completionHandler: ((CLLocationCoordinate2D) -> (Void))?
    var errorHandler: ((Error) -> (Void))?
    let authorStauts: Observable<CLAuthorizationStatus?> = Observable(nil)
    
    override init() {
        super.init()
        //CLLocationManager의 delegate 설정
        manager.delegate = self
        //manager.desiredAccuracy = kCLLocationAccuracyBest
        //위치 정보 승인 요청
        manager.requestWhenInUseAuthorization()
    }
    
    //위치 정보 요청 - 정보 요청이 성공하면 실행될 completionHandler를 등록
    func requestLocation(completion: @escaping ((CLLocationCoordinate2D) -> (Void)), error: @escaping ((Error) -> (Void))) {
        completionHandler = completion
        errorHandler = error
        manager.requestLocation()
    }
    
    func startUpdatingLocation(completion: @escaping ((CLLocationCoordinate2D) -> (Void))) {
        completionHandler = completion
        manager.startUpdatingLocation()
    }
    
    //위치 정보는 주기적으로 업데이트 되므로 이를 중단하기 위한 함수
    func stopUpdatingLocation() {
        manager.stopUpdatingHeading()
    }
    
    //위치 정보가 업데이트 될 때 호출되는 delegate 함수
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        //requestLocation 에서 등록한 completion handler를 통해 위치 정보를 전달
        if let completion = self.completionHandler {
            completion(location.coordinate)
        }
        //위치 정보 업데이트 중단
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        errorHandler?(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            print("locationManager() :: 위치 사용 권한 항상 허용]")
        }
        if status == .authorizedWhenInUse {
            print("locationManager() :: 위치 사용 권한 앱 사용 시 허용]")
        }
        if status == .denied {
            print("locationManager() :: 위치 사용 권한 거부]")
        }
        if status == .restricted || status == .notDetermined {
            print("locationManager() :: 위치 사용 권한 대기 상태]")
        }
        authorStauts.value = status
    }
    
    
}
