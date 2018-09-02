//
//  RepositoryDetailViewModelTest.swift
//  GHTrendingRepositoriesTests
//
//  Created by Lilia Dassine Belaid on 2018-09-02.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import XCTest

@testable import Pods_GHTrendingRepositories

class RepositoryDetailViewModelTest: XCTestCase {
    
    let apiServiceMock = APIServiceMock()
    
    override func setUp() {
        super.setUp()
    }

    func testTitle() {
        apiServiceMock.isGetTrendingSuccessful = true
        
        let repositoriesViewModel = RepositoriesViewModel(apiService: apiServiceMock)
        repositoriesViewModel.selectCellViewModel(at: IndexPath(row: 0, section: 0))
        
        let repository = repositoriesViewModel.selectedRepository
        let repositoryDetailViewModel = RepositoryDetailViewModel(apiService: apiServiceMock, repository: repository!)
        
        XCTAssertEqual(repositoryDetailViewModel.title, repository?.name)
    }
    
    
    func testAvatarURL() {
        apiServiceMock.isGetTrendingSuccessful = true
        
        let repositoriesViewModel = RepositoriesViewModel(apiService: apiServiceMock)
        repositoriesViewModel.selectCellViewModel(at: IndexPath(row: 0, section: 0))
        
        let repository = repositoriesViewModel.selectedRepository
        let repositoryDetailViewModel = RepositoryDetailViewModel(apiService: apiServiceMock, repository: repository!)
        
        XCTAssertEqual(repositoryDetailViewModel.avatarURL, URL(string: (repository?.owner!.avatar_url!)!)!)
    }
    
    func testDescription() {
        apiServiceMock.isGetTrendingSuccessful = true
        
        let repositoriesViewModel = RepositoriesViewModel(apiService: apiServiceMock)
        repositoriesViewModel.selectCellViewModel(at: IndexPath(row: 0, section: 0))
        
        let repository = repositoriesViewModel.selectedRepository
        let repositoryDetailViewModel = RepositoryDetailViewModel(apiService: apiServiceMock, repository: repository!)
        
        XCTAssertEqual(repositoryDetailViewModel.description, repository?.description)
    }
    
    func testStargazersCount() {
        apiServiceMock.isGetTrendingSuccessful = true
        
        let repositoriesViewModel = RepositoriesViewModel(apiService: apiServiceMock)
        repositoriesViewModel.selectCellViewModel(at: IndexPath(row: 0, section: 0))
        
        let repository = repositoriesViewModel.selectedRepository
        let repositoryDetailViewModel = RepositoryDetailViewModel(apiService: apiServiceMock, repository: repository!)
        
        XCTAssertEqual(repositoryDetailViewModel.stargazersCount,  "\(repository?.stargazers_count as! Int) Stars")
    }
    
    func testForksCount() {
        apiServiceMock.isGetTrendingSuccessful = true
        
        let repositoriesViewModel = RepositoriesViewModel(apiService: apiServiceMock)
        repositoriesViewModel.selectCellViewModel(at: IndexPath(row: 1, section: 0))
        
        let repository = repositoriesViewModel.selectedRepository
        let repositoryDetailViewModel = RepositoryDetailViewModel(apiService: apiServiceMock, repository: repository!)
        
        XCTAssertEqual(repositoryDetailViewModel.forksCount, "\(repository?.forks_count as! Int) Forks")
    }
    
    
    func testReadMe() {
        apiServiceMock.isGetTrendingSuccessful = true
        apiServiceMock.isetReadMeSuccessful = true

        let repositoriesViewModel = RepositoriesViewModel(apiService: apiServiceMock)
        repositoriesViewModel.selectCellViewModel(at: IndexPath(row: 1, section: 0))

        let repository = repositoriesViewModel.selectedRepository
        let repositoryDetailViewModel = RepositoryDetailViewModel(apiService: apiServiceMock, repository: repository!)
        
        //TODO: test ReadMe content
//        XCTAssertEqual()
    }
}
