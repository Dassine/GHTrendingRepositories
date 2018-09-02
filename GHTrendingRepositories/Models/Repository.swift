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

    var name: String?
    var owner: Owner?
    var description: String?
    var stargazers_count: Int
    var forks_count: Int

}

