//
//  IjjeumingaTests.swift
//  IjjeumingaTests
//
//  Created by BH on 2024/07/14.
//

import XCTest

import RxSwift

@testable import Ijjeuminga

final class DestinationTest: XCTestCase {
    
    var destinationViewModel: DestinationViewModel!
    var busRouteInfoAPIService: BusRouteInfoAPIService!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        
        self.destinationViewModel = DestinationViewModel()
        self.busRouteInfoAPIService = BusRouteInfoAPIService()
        self.disposeBag = DisposeBag()
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
    }
    
    override func tearDownWithError() throws {
        try? super.tearDownWithError()
        self.destinationViewModel = nil
        self.busRouteInfoAPIService = nil
        self.disposeBag = nil
    }
    
    func test_busRouteInfoAPIService() throws {
        // given
        let busRouteId = "100100124"
        
        // expectation
        let expectation = self.expectation(description: "Fetch station by route should succeed")
        var fetchedStationList: [Rest.BusRouteInfo.ItemList]?
        
        // when
        BusRouteInfoAPIService()
            .getStaionByRoute(with: busRouteId)
            .subscribe { response in
                fetchedStationList = response.msgBody.itemList
                expectation.fulfill()
                print("expectation: \(expectation)")
            }
            .disposed(by: disposeBag)
        
        // then
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                XCTFail("Timeout error: \(error)")
            } else {
                XCTAssertTrue(fetchedStationList?.isEmpty == false, "response's itemList is empty")
            }
        }
    }
}
