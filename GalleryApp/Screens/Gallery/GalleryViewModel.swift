//
//  GalleryViewModel.swift
//  GalleryApp
//
//  Created by Rahul Kiumar on 02/05/26.
//

import Foundation
import SwiftData
import Combine

@MainActor
final class GalleryViewModel: ObservableObject {
    
    @Published var images: [Gallery] = []
    @Published var isInitialLoading = false
    
    private let service: GalleryServiceProtocol
    
    private var page = 1
    private var isLoading = false
    private var hasMore = true
    
    init(service: GalleryServiceProtocol) {
        self.service = service
    }
    
    // MARK: - Load
    func loadInitial(context: ModelContext) async {
        isInitialLoading = true
        
        // Always load local DB first
        let stored = (try? context.fetch(FetchDescriptor<Gallery>())) ?? []
        self.images = stored
        
        // Then try network
        if images.isEmpty {
            await fetchNext(context: context)
        }
        isInitialLoading = false
    }
    
    // MARK: - Pagination
    func fetchNext(context: ModelContext) async {
        guard !isLoading, hasMore else { return }
        isLoading = true
        page = (images.count / 20) + 1
        
        do {
            let response = try await service.fetchPhotos(page: page)
            
            var newItems: [Gallery] = []
            
            for photo in response {
                
                // Avoid duplicates
                if images.contains(where: { $0.id == photo.id }) {
                    continue
                }
                
                if let item = await Gallery.from(photo) {
                    context.insert(item)
                    newItems.append(item)
                }
            }
            
            self.images.append(contentsOf: newItems)
            
            if newItems.count < 20 {
                hasMore = false
            }
        } catch let error as NetworkError {
            print("Network Error: ", error.errorDescription)
        } catch {
            print("Unknown Error:", error.localizedDescription)
        }
        isLoading = false
    }
}
