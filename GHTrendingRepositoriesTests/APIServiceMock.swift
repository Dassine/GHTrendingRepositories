//
//  APIServiceMock.swift
//  GHTrendingRepositoriesTests
//
//  Created by Lilia Dassine Belaid on 2018-09-02.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import Foundation

import ReactiveSwift
import Result

class APIServiceMock : APIServiceProtocol {
    
    let error = NSError(domain: "Error", code: 100, userInfo: nil)
    
    var isGetTrendingSuccessful = false
    var isetReadMeSuccessful = false
    
    private func createRepositoriesMock() -> [Repository] {
        var repositories = [Repository]()
        
        let owner = Owner(login: "Owner", avatar_url: "avatar-test")

        let repo1 = Repository(name: "Repository 1", owner: owner, description: "Repository 1 Description", stargazers_count: 120, forks_count: 30)
        let repo2 = Repository(name: "Repository 2", owner: owner, description: "Repository 1 Description", stargazers_count: 122, forks_count: 4)
        
        repositories.append(repo1)
        repositories.append(repo2)
        
        return repositories
    }
    
    func fetchTrendingRepositories() -> SignalProducer<[Repository], AnyError> {
        if isGetTrendingSuccessful {
            return SignalProducer<[Repository], AnyError>(value: self.createRepositoriesMock())
        } else {
            return SignalProducer<[Repository], AnyError>(error: AnyError(error))
        }
    }
    
    func getReadMe(owner: String, repositoryName: String) -> SignalProducer<ReadMe, AnyError> {
        if isetReadMeSuccessful {
            return SignalProducer<ReadMe, AnyError>(value: ReadMe())
        } else {
            return SignalProducer<ReadMe, AnyError>(error: AnyError(error))
        }
    }
    
}
