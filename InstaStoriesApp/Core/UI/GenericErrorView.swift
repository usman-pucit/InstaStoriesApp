//
//  GenericErrorView.swift
//  InstaStoriesApp
//
//  Created by Usman on 17.05.25.
//


import SwiftUI

struct GenericErrorView: View {
    let errorMessage: String
    var retryAction: (() -> Void)?
    
    init(
        errorMessage: String,
        retryAction: (() -> Void)? = nil
    ) {
        self.errorMessage = errorMessage
        self.retryAction = retryAction
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 70))
                .foregroundColor(.red.opacity(0.8))
                .padding(.bottom, 16)
            
            Text(errorMessage)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .padding(.horizontal, 32)
            
            if let retryAction = retryAction {
                Button(action: retryAction) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                        Text("Try Again")
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        Capsule()
                            .fill(Color.blue)
                    )
                    .foregroundColor(.white)
                    .font(.headline)
                }
                .padding(.top, 16)
                .accessibilityLabel("Retry Button")
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}
