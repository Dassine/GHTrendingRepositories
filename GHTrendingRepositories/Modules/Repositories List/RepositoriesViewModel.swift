//
//  RepositoriesViewModel.swift
//  GHTrendingRepositories
//
//  Created by Lilia Dassine Belaid on 2018-08-27.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import Foundation

import ReactiveSwift
import Result

struct RepositoryCellViewModel {
    
    let nameText: String
    let scoreText: String
    let descriptionText: String
    
}

class RepositoriesViewModel {
    
    let apiService: APIServiceProtocol
    
    private let repositoriesUpdateObserver: Signal<Void, NoError>.Observer
    let repositoriesUpdateSignal: Signal<Void, NoError>
    
    private let errorObserver: Signal<String, NoError>.Observer
    let errorSignal: Signal<String, NoError>
    
    let searchRepositorySignal = MutableProperty<String?>(nil)
    
    private var allRepositories: [Repository]
    private var filteredRepositories: [Repository]
    
    private var isRefreshing = false
    let isLoading = MutableProperty(false)

    var reloadTableViewClosure: (()->())?
    
    var selectedRepository: Repository?
    var selectedRepositoryModelView: RepositoryDetailViewModel? {
        guard let repo = selectedRepository else { return nil }
        return RepositoryDetailViewModel(repository: repo)
    }
    
    private var cellViewModels: [RepositoryCellViewModel] = [RepositoryCellViewModel]() {
        
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    init( apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
        
        //Set the signals and observers
        let (repositoriesUpdateSignal, repositoriesUpdateObserver) = Signal<Void, NoError>.pipe()
        self.repositoriesUpdateSignal = repositoriesUpdateSignal
        self.repositoriesUpdateObserver = repositoriesUpdateObserver
        
        let (errorSignal, errorObserver) = Signal<String, NoError>.pipe()
        self.errorSignal = errorSignal
        self.errorObserver = errorObserver
        
        self.allRepositories = []
        self.filteredRepositories = []
        
        self.isLoading.value = false
        
        SignalProducer(searchRepositorySignal)
            .on(starting: { self.isLoading.value = true })
            .map { (query) -> [Repository] in
                if let query = query {
                    if query.isEmpty {
                        return self.allRepositories
                    }
                    return self.allRepositories.filter { $0.description != nil && $0.name != nil && ($0.description!.lowercased().contains(query.lowercased()) ||
                            $0.name!.lowercased().contains(query.lowercased())) }
                } else {
                    return self.allRepositories
                }
            }
            .startWithValues { (repos) in
                
                self.filteredRepositories.removeAll()
                self.filteredRepositories.append(contentsOf: repos)
                self.setCellViewModels(self.filteredRepositories)
                
                self.repositoriesUpdateObserver.send(value: ())
                
                self.isLoading.value = false
        }
        
        loadReposistory()
    }
    
    func refresh() {
        isRefreshing = true
        loadReposistory()
    }
    
    private func loadReposistory() {
        apiService.fetchTrendingRepositories()
            .on(starting: { self.isLoading.value = true })
            .flatMap(.latest, { (repos) -> SignalProducer<[Repository], AnyError> in
                return SignalProducer<[Repository], AnyError>(value: repos)
            })
            .on(completed: { self.isLoading.value = false })
            .observe(on: UIScheduler())
            .startWithResult({ (result) in
                if let repos = result.value {
                    
                    //Handle refrenshing
                    if self.isRefreshing {
                        self.filteredRepositories.removeAll()
                        self.isRefreshing = false
                    }
                    
                    //Update repositories arrays and cells
                    self.allRepositories.append(contentsOf: repos)
                    self.filteredRepositories.append(contentsOf: repos)
                    self.setCellViewModels(self.filteredRepositories)
                    
                    //Notify observer about repositoriesUpdate
                    self.repositoriesUpdateObserver.send(value: ())
                } else {
                    self.isLoading.value = false
                }
            })
    }
    
    private func setCellViewModels(_ repositories: [Repository] ) {
        var cellViewModel = [RepositoryCellViewModel]()
        
        for repo in repositories {
            cellViewModel.append(createCellViewModel(with: repo))
        }
        
        self.cellViewModels = cellViewModel
    }
    
    func createCellViewModel(with repository: Repository) -> RepositoryCellViewModel {
        return RepositoryCellViewModel(nameText: repository.name ?? "", scoreText: "\(repository.stargazers_count) Star(s)", descriptionText: repository.description ?? "")
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> RepositoryCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func selectCellViewModel(at indexPath: IndexPath ){
        let repo = self.allRepositories[indexPath.row]
        self.selectedRepository = repo
    }
}
