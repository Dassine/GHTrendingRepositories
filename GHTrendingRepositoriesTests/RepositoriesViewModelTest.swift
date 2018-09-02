//
//  RepositoriesViewModelTest.swift
//  GHTrendingRepositoriesTests
//
//  Created by Lilia Dassine Belaid on 2018-09-02.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import XCTest

@testable import Pods_GHTrendingRepositories

class RepositoriesViewModelTest: XCTestCase {
    
    let apiServiceMock = APIServiceMock()
    
    override func setUp() {
        super.setUp()
    }
    
    func testRepositoriesCount() {
        apiServiceMock.isGetTrendingSuccessful = true
        
        let repositoriesViewModel = RepositoriesViewModel(apiService: apiServiceMock)

        XCTAssert(!repositoriesViewModel.isLoading.value)
        XCTAssertEqual(repositoriesViewModel.numberOfCells, 2)
    }
    
    func testSelectRepository() {
        apiServiceMock.isGetTrendingSuccessful = true
        
        let repositoriesViewModel = RepositoriesViewModel(apiService: apiServiceMock)
        let repository = repositoriesViewModel.getCellViewModel(at: IndexPath(row: 1, section: 0))
        
        XCTAssertEqual(repository.nameText, "Repository 2")
    }
    
    func testRefreshRepositories() {
        apiServiceMock.isGetTrendingSuccessful = true
        
        let repositoriesViewModel = RepositoriesViewModel(apiService: apiServiceMock)
        repositoriesViewModel.refresh()

        XCTAssertEqual(repositoriesViewModel.numberOfCells, 2)
    }
    
}
