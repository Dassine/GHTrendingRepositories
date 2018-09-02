//
//  RepositoryDetailViewController.swift
//  GHTrendingRepositories
//
//  Created by Lilia Dassine Belaid on 2018-08-27.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import UIKit

import ReactiveSwift
import SDWebImage
import Down

class RepositoryDetailViewController: UIViewController {
    
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var ownerLoginLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var stargazersCountLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var readMeView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: RepositoryDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCircularAvatar()
        bindViewModel()
    }
    
    private func setCircularAvatar() {
        ownerImage.layer.cornerRadius = 40.0
        ownerImage.layer.masksToBounds = true
    }
    
    private func bindViewModel() {
        //Set Navigation Title
        title = viewModel.title
        
        //Set Repository information
        self.ownerImage.sd_setImage(with: viewModel.avatarURL, placeholderImage: UIImage(named: "avatar"))
        self.ownerLoginLabel.text = viewModel.ownerLogin
        self.descriptionLabel.text = viewModel.description
        self.stargazersCountLabel.text = viewModel.stargazersCount
        self.forksCountLabel.text = viewModel.forksCount 
        
        
        //Set ReadMe section
        viewModel.readMeUpdateSignal
            .observe(on: UIScheduler())
            .observeValues { (readMeString) in
                guard let downView = try? DownView(frame: self.view.bounds, markdownString: readMeString, didLoadSuccessfully: {}) else { return }
                self.readMeView.addSubview(downView)
        }
 
        //Stop loading indicator
        viewModel.isLoading.producer
            .observe(on: UIScheduler())
            .startWithValues { (isLoading) in
                if isLoading {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
        }
        
        //Show error
        viewModel.errorSignal
            .observe(on: UIScheduler())
            .observeValues { (error) in
                self.showError(error: error)
        }
    }
    
    func showError(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

}
