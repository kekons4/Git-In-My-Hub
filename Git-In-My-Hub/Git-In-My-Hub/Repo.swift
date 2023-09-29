//
//  Repo.swift
//  Git-In-My-Hub
//
//  Created by Keon Pourboghrat on 9/29/23.
//

import Foundation

// Single Repo object owned by GH user
struct Repo: Decodable, Hashable {
    let id: Int
    let name: String
    let fullName: String
    let owner: GithubUser?
    let htmlUrl: String?
    let description: String?
    let url: String?
    let homepage: String?
    let size: Int?
    let stargazersCount: Int?
    let forkCounts: Int?
//    let license: String?
    let createdAt: String?
    let updatedAt: String?
    let pushedAt: String?
    let forks: Int?
}
