//
//  GalleryDetailView.swift
//  GalleryApp
//
//  Created by Swosti Sambit Yadab on 03/05/26.
//

import SwiftUI

struct GalleryDetailView: View {
    
    let item: Gallery
    let animation: Namespace.ID
    
    var body: some View {
        let url = ImageCacheManager.shared.fileURL(for: item.fullImageFileName)
        
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            if let image = UIImage(contentsOfFile: url.path) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
                    .tint(.white)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTransition(.zoom(sourceID: item.id, in: animation))
    }
}
