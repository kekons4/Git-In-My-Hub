//
//  GetRepos.swift
//  Git-In-My-Hub
//
//  Created by Keon Pourboghrat on 9/29/23.
//

import Foundation

// Grabing details of a single repo from user
func getRepo(fullName: String) async throws -> Repo {
    guard let url: URL = URL(string: "https://api.github.com/repos/\(fullName)") else {
            throw GHError.invalidURL
        }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw GHError.invalidResponse
    }
    
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(Repo.self, from: data)
    } catch(let error) {
        print(error)
        throw GHError.invalidData
    }
}

// Grab all public repos from user
func getRepos(reposUrl: String) async throws -> [Repo] {
    print(reposUrl)
    guard let endpoint: URL = URL(string: reposUrl) else {
        throw GHError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: endpoint)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw GHError.invalidResponse
    }
    
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([Repo].self, from: data)
    } catch (let error) {
        print(error)
        throw GHError.invalidData
    }
}

// Grabs all contributers to selected repo
func getContributers(fullName: String) async throws -> [GithubUser] {
    guard let endpoint = URL(string: "https://api.github.com/repos/\(fullName)/contributors") else {
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
