//
//  ContentView.swift
//  Git-In-My-Hub
//
//  Created by Keon Pourboghrat on 9/29/23.
//

import SwiftUI

struct ContentView: View {
    
    // Stores user search input
    @State private var input: String = ""
    // Stores an array of randomly searched users on github
    @State private var users: [GithubUser] = []
    // Controls the title for the results section
    @State private var listState = "Discover"
    // Controls if the whether to display the "No Users found message"
    @State private var searchState: Bool = false
    // Controls whether the Section text shows "the no user found message"
    @State private var searchResultsText: String = ""
    
    var body: some View {
        
        NavigationStack {
            List {
                Section(listState) {
                    if searchState {
                        Text(searchResultsText)
                            .foregroundColor(.black)
                            .padding()
                    }
                    
                    ForEach(users, id: \.login) { user in
                        NavigationLink(value: user) {
                            UserCell(user: user)
                        }
                        .navigationDestination(for: GithubUser.self) { GithubUser in
                            UserView(username: GithubUser.login)
                        }
                    }
                    
                }
                .foregroundColor(.secondary)
            }
            .navigationTitle("GitHub Search")
            .task {
                do {
                    if !input.isEmpty {
                        listState = "Result"
                        let oneUser = try await getUser(username: input)
                        users = []
                        users.append(oneUser)
                    } else {
                        if users.isEmpty {
                            users = try await getRandomUsers()
                            listState = "Discover"
                        }
                    }
                } catch GHError.invalidURL {
                    print("invalid URL")
                } catch GHError.invalidData {
                    print("invalid data")
                } catch GHError.invalidResponse {
                    print("invalid response")
                } catch {
                    print("Unknown error occurred")
                }
            }
            .searchable(text: $input, prompt: "Search Username")
            .onSubmit(of: .search) {
                Task {
                    do {
                        listState = "Results"
                        let oneUser = try await getUser(username: input)
                        users = []
                        users.append(oneUser)
                        searchState = false
                        searchResultsText = ""
                    } catch GHError.invalidURL {
                        print("invalid URL")
                    } catch GHError.invalidData {
                        print("invalid data")
                    } catch GHError.invalidResponse {
                        print("invalid response")
                        users = []
                        searchState = true
                        searchResultsText = "No Results Found for \(input)"
                    } catch {
                        print("Unknown error occurred")
                    }
                }
            }
            .refreshable() {
                do {
                    if !input.isEmpty {
                        listState = "Result"
                        let oneUser = try await getUser(username: input)
                        users = []
                        users.append(oneUser)
                    } else {
                        users = try await getRandomUsers()
                        listState = "Discover"
                    }
                } catch GHError.invalidURL {
                    print("invalid URL")
                } catch GHError.invalidData {
                    print("invalid data")
                } catch GHError.invalidResponse {
                    print("invalid response")
                } catch {
                    print("Unknown error occurred")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
