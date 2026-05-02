//
//  SkeletonView.swift
//  GalleryApp
//
//  Created by Rahul Kiumar on 02/05/26.
//

import SwiftUI

struct SkeletonView: View {
    
    @State private var isAnimating = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.3))
            .overlay(
                LinearGradient(
                    colors: [.clear, .white.opacity(0.6), .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: isAnimating ? 200 : -200)
            )
            .mask(RoundedRectangle(cornerRadius: 8))
            .onAppear {
                withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}

#Preview {
    SkeletonView()
}
