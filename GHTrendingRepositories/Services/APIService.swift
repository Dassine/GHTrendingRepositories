//
//  APIService.swift
//  GHTrendingRepositories
//
//  Created by Lilia Dassine Belaid on 2018-08-27.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import Foundation

import ReactiveSwift
import Result

enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}

protocol APIServiceProtocol {
    
    func fetchTrendingRepositories() -> SignalProducer<[Repository], AnyError>
    func getReadMe(owner: String, repositoryName: String) -> SignalProducer<ReadMe, AnyError>
    
}

class APIService: APIServiceProtocol {
    
    private var apiUrl = ""
    
    
    init() {
        if let api = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String {
            apiUrl = api
        }
    }

    func fetchTrendingRepositories() -> SignalProducer<[Repository], AnyError> {
        
        return SignalProducer { observer, disposable in
            
            //Set date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
            let createdDate = dateFormatter.string(from: lastWeekDate)
            
            //Set api url to fetch repositories
            let urlString = "\(self.apiUrl)/search/repositories?q=created:>\(createdDate)&sort=stars&order=desc"
            let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            guard let url = URL(string:encodedURLString) else {
                observer.send(error: Result<Any, AnyError>.error("URL Error") as! AnyError)
                return
            }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                //Notify about error
                guard error == nil else {
                    DispatchQueue.main.async {
                        observer.send(error: error as! AnyError)
                    }
                    return
                }
                
                //Notify observer about the new data
                guard let data = data else {
                    DispatchQueue.main.async {
                        observer.send(error: error as! AnyError)
                    }
                    return
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                do {
                    let repos = try decoder.decode(Repositories.self, from: data)
                    let items = repos.items ?? [Repository]()
                    DispatchQueue.main.async {
                        observer.send(value: items)
                        observer.sendCompleted()

                    }
                } catch {
                    DispatchQueue.main.async {
                        observer.send(error:error as! AnyError)
                    }
                }
                
                }.resume()
        }
    }
    
    func getReadMe(owner: String, repositoryName: String) -> SignalProducer<ReadMe, AnyError> {
        
        return SignalProducer { observer, disposable in
            
            //Set api url to fetch repositories
            let urlString = "\(self.apiUrl)/repos/\(owner)/\(repositoryName)/readme"
            let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            guard let url = URL(string:encodedURLString) else {
                observer.send(error: Result<Any, AnyError>.error("URL Error") as! AnyError)
                return
            }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                //Notify about error
                guard error == nil else {
                    DispatchQueue.main.async {
                        observer.send(error: error as! AnyError)
                    }
                    return
                }
                
                //Notify observer about the new data
                guard let data = data else {
                    DispatchQueue.main.async {
                        observer.send(error: error as! AnyError)
                    }
                    return
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                do {
                    let readMe = try decoder.decode(ReadMe.self, from: data)
                    DispatchQueue.main.async {
                        observer.send(value: readMe)
                        observer.sendCompleted()
                    }
                } catch {
                    DispatchQueue.main.async {
                        observer.send(error: error as! AnyError)
                    }
                }
                
                }.resume()
        }
    }
    
}
