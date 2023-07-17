////
////  SampleViewModel.swift
////  WeatherApp
////
////  Created by sandy on 2023/07/15.
////
//
//import Foundation
//import Combine
//
//
//class SampleViewModel: BaseViewModel, ViewModelType {
//    func transform(input: Input) -> Output {
//        let isUserCreateButtonAvailablePublisher = input.userName
//            .map { value in
//                value.count >= 5
//            }.eraseToAnyPublisher()
//        return Output(isUserCreateButtonAvailable: isUserCreateButtonAvailablePublisher)
//    }
//    
//    
//    struct Input {
//        let userName: AnyPublisher<String, Never>
//    }
//
//    struct Output {
//        let isUserCreateButtonAvailable: AnyPublisher<Bool, Never>
//    }
//
//}
//
