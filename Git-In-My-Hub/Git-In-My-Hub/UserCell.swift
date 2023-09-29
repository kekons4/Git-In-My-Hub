//
//  UserCell.swift
//  Git-In-My-Hub
//
//  Created by Keon Pourboghrat on 9/29/23.
//

import SwiftUI

struct UserCell: View {
    
    @Environment (\.colorScheme) var colorScheme
    
    @State var user: GithubUser
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: user.avatarUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .foregroundColor(.secondary)
            }
            .frame(width: 120, height: 120)
            
            VStack(alignment: .leading) {
                Text(user.login)
                    .fontWeight(.semibold)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .padding(.leading)
                
                Text(user.type ?? "Unknown")
                    .foregroundColor(.secondary)
                    .padding(.top, 5)
                    .padding(.leading, 17)
            }
        }
    }
}

//struct UserCell_Previews: PreviewProvider {
//    static var previews: some View {
//        UserCell(user: user)
//    }
//}

