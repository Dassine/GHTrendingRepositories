//
//  RepositoryDetailViewModel.swift
//  GHTrendingRepositories
//
//  Created by Lilia Dassine Belaid on 2018-08-27.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import Foundation

import ReactiveSwift
import Result

class RepositoryDetailViewModel {
    
    private let apiService: APIService

    private let repository: Repository
    
    private let readMeUpdateObserver: Signal<String, NoError>.Observer
    let readMeUpdateSignal: Signal<String, NoError>
    
    private let errorObserver: Signal<String, NoError>.Observer
    let errorSignal: Signal<String, NoError>
    
    let isLoading = MutableProperty(false)
    
    lazy var title: String = { [unowned self] in
        return repository.name
        }()!
    
    lazy var avatarURL: URL = { [unowned self] in
        return URL(string: repository.owner!.avatar_url!)!
        }()

    lazy var ownerLogin: String = { [unowned self] in
        return repository.owner!.login
        }()!

    lazy var description: String = { [unowned self] in
        return repository.description
        }()!

    lazy var stargazersCount: String = { [unowned self] in
        return "\(String(describing: repository.stargazers_count)) Stars"
        }()

    lazy var forksCount: String = { [unowned self] in
        return "\(String(describing: repository.forks_count)) Forks"
        }()
    
    init(apiService: APIServiceProtocol = APIService(), repository: Repository) {
        
        self.apiService = apiService as! APIService
        self.repository = repository
        
        //Set the signals and observers
        let (readMeUpdateSignal, readMeUpdateObserver) = Signal<String, NoError>.pipe()
        self.readMeUpdateSignal = readMeUpdateSignal
        self.readMeUpdateObserver = readMeUpdateObserver
        
        let (errorSignal, errorObserver) = Signal<String, NoError>.pipe()
        self.errorSignal = errorSignal
        self.errorObserver = errorObserver
        
        //Get ReadMe fo
        apiService.getReadMe(owner: repository.owner!.login!, repositoryName: repository.name!)
            .on(starting: { self.isLoading.value = true })
            .flatMap(.latest) { (readMe) -> SignalProducer<ReadMe, NoError> in
                return SignalProducer<ReadMe, NoError>(value: readMe)
            }
            .on(completed: { self.isLoading.value = false })
            .observe(on: UIScheduler())
            .startWithResult { (result) in
                if let readMe = result.value {
                    if let data = Data(base64Encoded: readMe.content!, options: .ignoreUnknownCharacters) {
                        if let decoded = String(data: data, encoding: .utf8)  {
                            readMeUpdateObserver.send(value: decoded)
                        }
                    }
                } else {
                    if let error = result.error {
                        errorObserver.send(value: error.localizedDescription)
                    }
                }
        }
    }
}
