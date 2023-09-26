//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by sandy on 2023/07/14.
//

import XCTest
@testable import WeatherApp

/*
 TODO: 테스트할 항목
 - API 호출 테스트
    - 파싱잘 되는지
    - 언어
    - Geocoding -> ReverseGeocoding 잘 되는지?
        - ReverseGeocoding 실패시 어떻게 되는지
 - DB 테스트
    - 저장 잘 되는지
    - 삭제 잘 되는지
    - 불러오기 잘 되는지
    - 필터링 잘 되는지
 - UserDefaults
 - Local 검색
    - 빈 값 검색
    - 값 검색 후 다른 값 검색
 - Local 편집 / 추가
    - 삭제
    - 추가시 4개 이상 불가능한지
 - Splash 에서 현재 DB의 isCurrent가 잘 업데이트 되는지
 
 */

final class WeatherAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
