//
//  ImageCacheManager.swift
//  GalleryApp
//
//  Created by Rahul Kiumar on 02/05/26.
//

import Foundation
import CryptoKit

final class ImageCacheManager {
    
    static let shared = ImageCacheManager()
    private init() {}
    
    private let fileManager = FileManager.default
    
    private var directory: URL {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    
    private var inProgress: [String: Task<String?, Never>] = [:]
        
    func getImage(from urlString: String) async -> String? {
        
        guard let url = URL(string: urlString) else { return nil }
        
        let filename = hashedFileName(for: urlString)
        let fileURL = directory.appendingPathComponent(filename)
        
        //  Already cached
        if fileManager.fileExists(atPath: fileURL.path) {
            return filename
        }
        
        // Already downloading
        if let task = inProgress[urlString] {
            return await task.value
        }
        
        // Download task
        let task = Task<String?, Never> {
            defer { inProgress[urlString] = nil }
            
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                
                guard let http = response as? HTTPURLResponse,
                      http.statusCode == 200 else {
                    return nil
                }
                
                try data.write(to: fileURL)
                return filename
                
            } catch {
                print("Download failed:", error)
                return nil
            }
        }
        
        inProgress[urlString] = task
        return await task.value
    }
    
    // MARK: - Helpers
    func fileURL(for filename: String) -> URL {
        directory.appendingPathComponent(filename)
    }
    
    private func hashedFileName(for url: String) -> String {
        let data = Data(url.utf8)
        let hash = SHA256.hash(data: data)
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
