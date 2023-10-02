//
//  LocationStorageTest.swift
//  WeatherAppTests
//
//  Created by sandy on 2023/09/25.
//

import XCTest
@testable import WeatherApp

// https://fomaios.tistory.com/entry/iOS-Unit-Test%EC%97%90-%EB%8C%80%ED%95%B4%EC%84%9C-%EA%B0%84%EB%8B%A8%ED%9E%88-%EC%95%8C%EC%95%84%EB%B3%B4%EA%B8%B0
/*
 TODO: 테스트할 항목
 - DB 테스트
 - 저장 잘 되는지
 - 삭제 잘 되는지
 - 불러오기 잘 되는지
 - 필터링 잘 되는지
 
 
 여기서 테스트를 하는 메소드의 이름을 작성하는 방법은 아래와 같습니다.
 1. 앞에 test를 붙이고 테스트를 할 클래스 이름을 적어준다.
 2. 테스트를 할 상황에 대해 설명한다.
 3. 예상되는 결과를 적어준다.
 ex. test_whenInvalidResponse_shouldNotDecodeObject
 */

final class LocationStorageTest: XCTestCase {
    var sut: AnyRepository<Location>!
    
    override func setUpWithError() throws {
        // 테스트에서 가장 먼저 실행되는 메소드로 보통 어떤 모델이나 시스템을 정의하는 역할을 합니다.
        sut = AnyRepository<Location>()
        try? sut.deleteAll()
        try? sut.insert(item: Location(lat: 10.0, lon: 10.5, isStar: false, isCurrent: true, name: "item1", address: "address1"))
        try? sut.insert(item: Location(lat: 20.0, lon: 20.5, isStar: false, isCurrent: false, name: "item2", address: "address2"))
        try? sut.insert(item: Location(lat: 30.0, lon: 30.5, isStar: false, isCurrent: false, name: "item3", address: "address3"))
    }
    
    override func tearDownWithError() throws {
        // 테스트에서 가장 마지막에 실행되는 메소드로 보통 정의했던 것들 해제시키는 역할을 합니다.
        sut = nil
    }
    
    func test_whenInsertNewData_shouldStoredForLastItem() throws {
        /*
         //Arrange
         let user = User(email: "Fomagran6@naver.com", password: "1234")
         
         //Action
         let isValidEmail = sut.isValidEmail(email: user.email)
         
         //Assert
         XCTAssertTrue(isValidEmail,XCTAssertTrue(isValidEmail,"isValidEmail은 True를 반환해야되는데 False를 반환했어 @를 포함시켜야 해!"))

         */
        //Arrange
        let newItem = Location(lat: 40.0, lon: 40.5, isStar: false, isCurrent: false, name: "item4", address: "address4")
        
        //Action
        try? sut.insert(item: newItem)
        let count = sut.getAll().count
        print(sut.getAll())
        
        //Assert
        XCTAssertEqual(count, 4)
    }
    
    func test_whenGetFirstItem_shouldIsCurrentTrue() throws {
        let newItem = Location(lat: 40.0, lon: 40.5, isStar: false, isCurrent: false, name: "item4", address: "address4")
        
        //Action
        try? sut.insert(item: newItem)
        let count = sut.getAll().count
        print(sut.getAll())
        
        //Assert
        XCTAssertEqual(count, 4)
    }
    
    
    func test_whenGetNotFirstItem_shouldIsCurrentFalse() throws {
        
    }
    
    
//    func testExample() throws {
//        // 테스트를 할 코드를 작성하는 역할을 합니다.
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
//
//    func testPerformanceExample() throws {
//        // 성능을 테스트하고 코드의 실행 속도를 테스트하는 역할을 합니다.
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//
}
