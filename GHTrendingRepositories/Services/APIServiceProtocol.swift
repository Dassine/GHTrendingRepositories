//
//  APIServiceProtocol.swift
//  GHTrendingRepositories
//
//  Created by Lilia Dassine Belaid on 2018-09-02.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result


protocol APIServiceProtocol {
    
    func fetchTrendingRepositories() -> SignalProducer<[Repository], APIServiceError>
    func getReadMe(owner: String, repositoryName: String) -> SignalProducer<ReadMe, APIServiceError>
    
}
