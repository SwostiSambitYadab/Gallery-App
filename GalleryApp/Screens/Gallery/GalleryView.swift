//
//  GalleryGridView.swift
//  GalleryApp
//
//  Created by Rahul Kiumar on 02/05/26.
//

import SwiftUI

struct GalleryView: View {
    
    @StateObject private var vm = GalleryViewModel(service: GalleryService())
    @Environment(\.modelContext) private var context
    
    @AppStorage("columnCount") var columnCount: Int = 2
    @Namespace private var animation

    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 1), count: columnCount)
    }
    
    var iconName: String {
        switch columnCount {
        case 1: return "square"
        case 2: return "square.grid.2x2"
        case 3: return "square.grid.3x3"
        default: return "square.grid.2x2"
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if vm.isInitialLoading && vm.images.isEmpty {
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(0..<10, id: \.self) { _ in
                            SkeletonView()
                                .frame(height: 150)
                        }
                    }
                    .padding(2)
                    
                } else {
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(vm.images, id: \.id) { item in
                            NavigationLink {
                                GalleryDetailView(item: item, animation: animation)
                            } label: {
                                let url = ImageCacheManager.shared
                                    .fileURL(for: item.thumbnailFileName)
                                
                                ZStack {
                                    if FileManager.default.fileExists(atPath: url.path),
                                       let image = UIImage(contentsOfFile: url.path) {
                                        
                                        Image(uiImage: image)
                                            .resizable()
                                    } else {
                                        Color.gray.opacity(0.3)
                                    }
                                }
                                .aspectRatio(1, contentMode: .fit)
                                .clipped()
                                .clipShape(.rect(cornerRadius: 10))
                            }
                            .matchedTransitionSource(id: item.id, in: animation)
                            .buttonStyle(.plain)
                            
                            // Pagination trigger
                            if item.id == vm.images.last?.id, NetworkMonitor.shared.isConnected == true {
                                ProgressView()
                                    .onAppear {
                                        Task {
                                            await vm.fetchNext(context: context)
                                        }
                                    }
                            }
                        }
                    }
                    .padding(2)
                }
            }
            .task {
                await vm.loadInitial(context: context)
            }
            .navigationTitle("Gallery")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        columnCount = columnCount % 3 + 1
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    } label: {
                        Image(systemName: iconName)
                    }
                }
            }
        }
        .animation(.easeInOut, value: columnCount)
    }
}

#Preview {
    GalleryView()
}

struct GalleryDetailView: View {
    
    let item: Gallery
    var animation: Namespace.ID
    
    var body: some View {
        let url = ImageCacheManager.shared
            .fileURL(for: item.fullImageFileName)
        
        ZStack {
            Color.black.ignoresSafeArea()
            
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
