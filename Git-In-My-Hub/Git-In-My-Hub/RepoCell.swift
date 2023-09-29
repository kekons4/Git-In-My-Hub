//
//  RepoCell.swift
//  Git-In-My-Hub
//
//  Created by Keon Pourboghrat on 9/29/23.
//

import SwiftUI

struct RepoCell: View {
    
    @Environment (\.colorScheme) var colorScheme
    
    @State var repo: Repo
    
    var body: some View {
        VStack(alignment: .center) {
            Text(repo.name)
                .fontWeight(.bold)
                .font(.system(size: 20))
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .padding([.top, .bottom])
                .lineLimit(1)
            
            HStack(spacing: 10) {
                Image(systemName: "star.fill")
                Text("\(repo.stargazersCount ?? 0)")
                Image(systemName: "arrow.up.right.circle.fill")
                Text("\(repo.forks ?? 0)")
            }.padding(.bottom)
            
            Text(repo.description ?? "\(repo.name) does not have a description")
                .fontWeight(.regular)
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .padding(.leading)
                .lineLimit(1)
            
        }
    }
}
