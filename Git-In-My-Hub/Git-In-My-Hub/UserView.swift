//
//  UserView.swift
//  Git-In-My-Hub
//
//  Created by Keon Pourboghrat on 9/29/23.
//

import SwiftUI

struct UserView: View {
    
    @State var username: String
    @State var user: GithubUser?
    @State var repos: [Repo]?
    @State var followers: [GithubUser]?
    @State var following: [GithubUser]?
    
    // Internal State for
    @State private var isLoading = false
    @State private var isError = false
    @State private var errorMsg = ""
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: user?.avatarUrl ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                } placeholder: {
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(Color.purple, lineWidth: 5)
                        .frame(width: 100, height: 100)
                        .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                        .foregroundColor(.secondary)
                        .animation(Animation.default.repeatForever(autoreverses: false))
                        .onAppear() {
                            self.isLoading = true
                        }
                }
                .frame(width: 120, height: 120)
                
                Text(user?.login ?? "Username Unknown")
                    .bold()
                    .font(.title3)
                
                HStack {
                    ShareView(url: "https://github.com/\(username)")
                }
                
                HStack {
                    Image(systemName: "person.fill")
                    Text("Followers: \(user?.followers ?? 0)")
                    Image(systemName: "person")
                    Text("Following: \(user?.following ?? 0)")
                }
                .font(.system(size: 14))
                .foregroundColor(.secondary)
    //            .padding()
                
                Text(user?.bio ?? "User has no Bio")
                    .padding()
                
                List {
                    Section("Repositories") {
                        ForEach(repos ?? [], id: \.name) { repo in
                            NavigationLink(value: repo) {
                                RepoCell(repo: repo)
                                    .frame(width: 100, height: 100)
                            }
                            .navigationDestination(for: Repo.self) { Repo in
                                RepoView(fullName: Repo.fullName)
                            }
                        }
                    }
                }
                .frame(height: 220)
                .task {
                    do {
                        repos = []
                        repos = try await getRepos(reposUrl: user?.reposUrl ?? "https://api.github.com/users/\(username)/repos")
                    } catch GHError.invalidURL {
                        print("invalid URL")
                        self.isError = true
                        self.errorMsg = "Invalid URL, please try again."
                    } catch GHError.invalidData {
                        print("invalid data")
                        self.isError = true
                        self.errorMsg = "Invalid Data submitted, please try again."
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
                
                List {
                    Section("Followers") {
                        ForEach(followers ?? [], id: \.login) { follower in
                            NavigationLink(value: follower) {
                                UserCell(user: follower)
                            }
                            .navigationDestination(for: GithubUser.self) { User in
                                UserView(username: "\(username)/followers")
                            }
                        }
                    }
                }
                .frame(height: 180)
                .task {
                    do {
                        followers = []
                        followers = try await getSocials(socialPath: "\(username)/followers")
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
                
                List {
                    Section("Following") {
                        ForEach(following ?? [], id: \.login) { follow in
                            NavigationLink(value: follow) {
                                UserCell(user: follow)
                            }
                            .navigationDestination(for: GithubUser.self) { User in
                                UserView(username: "\(username)/following")
                            }
                        }
                    }
                }
                .frame(height: 180)
                .task {
                    do {
                        following = []
                        following = try await getSocials(socialPath: "\(username)/following")
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
                    
                Spacer()
            }
            .padding()
            .task {
                // Grabs the single user from the user input provided
                do {
                    user = try await getUser(username: username)
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

//struct UserView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserView(username: "kekons4", user: UserList.list.first!)
//    }
//}

