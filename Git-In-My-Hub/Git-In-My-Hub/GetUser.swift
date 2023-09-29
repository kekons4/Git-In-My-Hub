//
//  GetUser.swift
//  Git-In-My-Hub
//
//  Created by Keon Pourboghrat on 9/29/23.
//

import Foundation

func getUser(username: String) async throws -> GithubUser {
    guard let url: URL = URL(string: "https://api.github.com/users/\(username)") else {
        throw GHError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw GHError.invalidResponse
    }
    
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(GithubUser.self, from: data)
    } catch(let error) {
        print(error)
        throw GHError.invalidData
    }
}

// Grabs all contributers to selected repo
func getSocials(socialPath: String) async throws -> [GithubUser] {
    guard let endpoint = URL(string: "https://api.github.com/users/\(socialPath)") else {
        throw GHError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: endpoint)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw GHError.invalidResponse
    }
    
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([GithubUser].self, from: data)
    } catch (let error) {
        print(error)
        throw GHError.invalidData
    }
}

func getRandomUsers() async throws -> [GithubUser] {
    // Generates Random Integer from 0 to 100,000
    let randInt: Int = Int.random(in: 0...100000)
    // URL used to grab 10 random GitHub users
    let url: String = "https://api.github.com/users?since=\(randInt)&per_page=10"
    
    guard let endpoint: URL = URL(string: url) else {
        throw GHError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: endpoint)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw GHError.invalidResponse
    }
    
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([GithubUser].self, from: data)
    } catch(let error) {
        print(error)
        throw GHError.invalidData
    }
}

enum GHError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
