//
//  GalleryService.swift
//  GalleryApp
//
//  Created by Swosti Sambit Yadab on 02/05/26.
//

import Foundation

protocol GalleryServiceProtocol {
    func fetchPhotos(page: Int) async throws -> [UnsplashPhoto]
}

final class GalleryService: GalleryServiceProtocol {
    
    private let accessKey = "PXvlcWbcF8tifyM0uU90f2MjXx1QnVxrj3y5vh4-8dk"
    
    func fetchPhotos(page: Int) async throws -> [UnsplashPhoto] {
        
        guard NetworkMonitor.shared.isConnected == true else {
            throw NetworkError.noInternetConnection
        }
        
        guard let url = URL(string: "https://api.unsplash.com/photos?page=\(page)&per_page=20")
        else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        print("D>\nRequest: ", request)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        print("D>\nResponse: ", response)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }
        
        guard !data.isEmpty else {
            throw NetworkError.noData
        }
        
        do {
            let decoded = try JSONDecoder().decode([UnsplashPhoto].self, from: data)
            return decoded
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
