//
//  ContentView.swift
//  Git-In-My-Hub
//
//  Created by Keon Pourboghrat on 9/29/23.
//

import SwiftUI

struct ContentView: View {
    
    @Environment (\.colorScheme) var colorScheme
    
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
    // If an API error occured set the Error message
    @State private var errorMsg = ""
    // Bool var to control if error occured
    @State private var isError = false
    
    var body: some View {
        
        NavigationStack {
            List {
                Section(listState) {
                    if searchState {
                        Text(searchResultsText)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
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
                    self.isError = true
                    self.errorMsg = "Invalid URL provided, please try again later."
                } catch GHError.invalidData {
                    print("invalid data")
                    self.isError = true
                    self.errorMsg = "Invalid Data provided, please try again later."
                } catch GHError.invalidResponse {
                    print("invalid response")
                    self.isError = true
                    self.errorMsg = "Invalid Response from GitHub, please try again later."
                } catch {
                    print("Unknown error occurred")
                    self.isError = true
                    self.errorMsg = "Unknown Error occured, please try again later."
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
                        self.isError = true
                        self.errorMsg = "Invalid URL provided, please try again later."
                    } catch GHError.invalidData {
                        print("invalid data")
                        self.isError = true
                        self.errorMsg = "Invalid URL provided, please try again later."
                    } catch GHError.invalidResponse {
                        print("invalid response")
                        users = []
                        searchState = true
                        searchResultsText = "No Results Found for \(input)"
                        self.isError = true
                        self.errorMsg = "Invalid Response from GitHub, please try again later."
                    } catch {
                        print("Unknown error occurred")
                        self.isError = true
                        self.errorMsg = "Unknown Error occured, please try again later."
                    }
                }
            }
            .refreshable() {
                do {
                    self.searchState = false
                    
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
                    self.isError = true
                    self.errorMsg = "Invalid URL provided, please try again later."
                } catch GHError.invalidData {
                    print("invalid data")
                    self.isError = true
                    self.errorMsg = "Invalid Data provided, please try again later."
                } catch GHError.invalidResponse {
                    print("invalid response")
                    self.isError = true
                    self.errorMsg = "Invalid Response from GitHub, please try again later."
                } catch {
                    print("Unknown error occurred")
                    self.isError = true
                    self.errorMsg = "Unknown Error occured, please try again later."
                }
            }
            .alert(self.errorMsg, isPresented: $isError) {
                Button("OK", role: .cancel) {}
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
