//
//  Repository.swift
//  GHTrendingRepositories
//
//  Created by Lilia Dassine Belaid on 2018-08-27.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import Foundation

struct Repositories: Codable {
    var items: [Repository]?
}

struct Repository: Codable {
    
    var id: Int
    var name: String?
    var full_name: String?
    var owner: Owner?
    var `private`: Bool?
    var html_url: String?
    var description: String?
    var fork: Bool?
    var url: String?
    var stargazers_count: Int?
    var forks_count: Int?
    var score: Float?
}
