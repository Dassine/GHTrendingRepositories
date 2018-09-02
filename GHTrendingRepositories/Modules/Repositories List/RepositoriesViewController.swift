//
//  RepositoriesViewController.swift
//  GHTrendingRepositories
//
//  Created by Lilia Dassine Belaid on 2018-08-27.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import UIKit

import ReactiveCocoa
import ReactiveSwift

class RepositoriesViewController: UIViewController {

    private let repositoryCellIdentifier = "RepositoryCell"
    private let repositoryCellHeight: CGFloat = 130.0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(RepositoriesViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    var selectedRepository: Repository?
    var selectedRepositoryModelView: RepositoryDetailViewModel? {
        guard let repo = selectedRepository else { return nil }
        return RepositoryDetailViewModel(repository: repo)
    }
    
    //Set the view model of Projects list
    lazy var viewModel: RepositoriesViewModel = {
        return RepositoriesViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // To remove "Trending" back button text
        self.navigationItem.title = " "
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Trending"
    }
    
    private func configureTableView() {
        tableView.addSubview(self.refreshControl)
    }

    private func bindViewModel() {
        viewModel.searchRepositorySignal <~ searchBar.reactive.continuousTextValues

        //Observe repositories update and reload the tablevie
        viewModel.repositoriesUpdateSignal
            .observe(on: UIScheduler())
            .observeValues {
                guard let tableView = self.tableView else { return }

                tableView.reloadData()
        }

        //Observe beginning and refreshing action
        viewModel.isLoading.producer
            .observe(on: UIScheduler())
            .startWithValues { (isLoading) in
                if isLoading {
                    self.refreshControl.beginRefreshing()
                } else {
                    self.refreshControl.endRefreshing()
                }
        }
        
        //Show error
        viewModel.errorSignal
            .observe(on: UIScheduler())
            .observeValues { (error) in
                self.showError(error: error)
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.searchBar.text = ""
        viewModel.refresh()
    }
    
    func showError(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension RepositoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return repositoryCellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: repositoryCellIdentifier, for: indexPath) as! RepositoryTableViewCell
        
        let cellViewModel = viewModel.getCellViewModel(at: indexPath)
        
        cell.nameLabel.text = cellViewModel.nameText
        cell.scoreLabel.text = cellViewModel.scoreText
        cell.descriptionLabel.text = cellViewModel.descriptionText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.viewModel.selectCellViewModel(at: indexPath)
        return indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? RepositoryDetailViewController {
            controller.viewModel = viewModel.selectedRepositoryModelView
        }
    }
    
}
