//
//  ShareView.swift
//  Git-In-My-Hub
//
//  Created by Keon Pourboghrat on 9/29/23.
//

import UIKit
import SwiftUI

struct ActivityViewController: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}

}

struct ShareView: View {

    @State private var isSharePresented: Bool = false
    @State var url: String

    var body: some View {
        Image(systemName: "square.and.arrow.up")
            .foregroundColor(Color(.systemBlue))
        
        Button("Share") {
            self.isSharePresented = true
        }
        .sheet(isPresented: $isSharePresented, onDismiss: {
            print("Dismiss")
        }, content: {
            ActivityViewController(activityItems: [URL(string: url)!])
        })
    }
}
