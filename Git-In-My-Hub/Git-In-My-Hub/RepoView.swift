//
//  RepoView.swift
//  Git-In-My-Hub
//
//  Created by Keon Pourboghrat on 9/29/23.
//

import SwiftUI

struct RepoView: View {
    
    @Environment (\.colorScheme) var colorScheme
    
    @State var contributers: [GithubUser]?
    @State var fullName: String
    @State var repo: Repo?
    
    var body: some View {
//        VStack(spacing: 200) {
//            Text("\(fullName) Repo")
//            Text(repo?.name ?? "FAILED to get the Repo Name")
//                .fontWeight(.bold)
//                .foregroundColor(colorScheme == .dark ? .white : .black)
//                .padding(.leading)
//
//            Text("Stars: \(String(repo?.stargazersCount ?? 0))")
//                .foregroundColor(.secondary)
//
//            Text(repo?.description ?? "\(repo?.name ?? "ERROR") does not have a description")
//                .fontWeight(.semibold)
//                .foregroundColor(colorScheme == .dark ? .white : .black)
//                .padding(.leading)
//        }
        VStack {
//            Text(repo?.name ?? "No Repo Name")
//                .font(.title)
            
            HStack {
                Image(systemName: "star.fill")
                Text("\(repo?.stargazersCount ?? 0)")
                Image(systemName: "arrow.up.right.circle.fill")
                Text("\(repo?.forks ?? 0)")
            }
            .font(.system(size: 20))
            .padding()
            
            HStack {
                ShareView(url: "https://github.com/\(fullName)")
            }
            .padding(.bottom)
            
            VStack {
                Text("Created: \(repo?.createdAt ?? "N/A")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Updated: \(repo?.updatedAt ?? "N/A")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom)
            
            Section("Description") {
                Text(repo?.description ?? "No Description available")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom)
            
            List {
                Section("Contributers") {
                    ForEach (contributers ?? [], id: \.login) { user in
                        NavigationLink (value: user) {
                            UserCell(user: user)
                        }
                        .navigationDestination(for: GithubUser.self) { GithubUser in
                            UserView(username: GithubUser.login)
                        }
                        
                    }
                }
            }
            .task {
                do {
                    contributers = []
                    contributers = try await getContributers(fullName: fullName)
                } catch GHError.invalidURL {
                    print("invalid URL")
                } catch GHError.invalidData {
                    print("invalid data")
                } catch GHError.invalidResponse {
                    print("invalid response")
                } catch (let error) {
                    print(error)
                    print("Unknown error occurred")
                }
            }
            
            Spacer()
            
        }
        .padding()
        .navigationTitle(repo?.name ?? "No Repo Name")
        .task {
            do {
                repo = try await getRepo(fullName: fullName)
            } catch GHError.invalidURL {
                print("invalid URL")
            } catch GHError.invalidData {
                print("invalid data")
            } catch GHError.invalidResponse {
                print("invalid response")
            } catch (let error) {
                print(error)
                print("Unknown error occurred")
            }
        }
    }
    
}
