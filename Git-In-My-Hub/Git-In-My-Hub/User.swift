//
//  User.swift
//  Git-In-My-Hub
//
//  Created by Keon Pourboghrat on 9/29/23.
//

import Foundation

// Single GitHub User
struct GithubUser: Codable, Hashable {
    let id: Int
    let login: String
    let avatarUrl: String
    let name: String?
    let bio: String?
    let followers: Int?
    let following: Int?
    let followersUrl: String?
    let followingUrl: String?
    let starredUrl: String?
    let reposUrl: String?
    let type: String?
    let htmlUrl: String?
}
