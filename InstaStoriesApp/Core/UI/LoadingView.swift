//
//  LoadingView.swift
//  InstaStoriesApp
//
//  Created by Usman on 17.05.25.
//

import SwiftUI

struct LoadingView: View {
    private let message: String
    
    init(
        message: String = String(format: "%@%@", "Loading", "...")
    ) {
        self.message = message
    }
        
    var body: some View {
        ZStack(alignment: .center) {
            ProgressView(message)
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1)
        }
    }
}
