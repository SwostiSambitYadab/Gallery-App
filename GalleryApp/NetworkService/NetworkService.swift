//
//  NetworkService.swift
//  GalleryApp
//
//  Created by Rahul Kiumar on 02/05/26.
//

import Foundation

import Foundation

//final class NetworkService {
//    static let shared = NetworkService()
//    private init() {}
//    
//    func fetchSongsList(offset: Int) async -> MusicListModel? {
//        let clientID = "3d80b7b0"
//        let baseURLString = "https://api.jamendo.com/v3.0/tracks/?client_id=\(clientID)&format=json&limit=10&offset=\(offset)&fullcount=true"
//        
//        guard let baseURL = URL(string: baseURLString) else { return nil }
//        let request = URLRequest(url: baseURL)
//        debugPrint("REQUEST:\n", request)
//        do {
//            let (data, response) = try await URLSession.shared.data(for: request)
//            guard let response = response as? HTTPURLResponse else { return nil }
//            debugPrint("RESPONSE:\n", response)
//            if response.statusCode < 299 && response.statusCode >= 200 {
//                let jsonString = String(data: data, encoding: .utf8)
//                debugPrint("RESULT:\n", jsonString ?? "")
//                let decoder = JSONDecoder()
//                let musicListData = try decoder.decode(MusicListModel.self, from: data)
//                return musicListData
//            } else {
//                debugPrint("Error in parsing data")
//                return nil
//            }
//        } catch {
//            debugPrint("Unable to Fetch the data:: ", error.localizedDescription)
//            return nil
//        }
//    }
//}

protocol GalleryServiceProtocol {
    func fetchPhotos(page: Int) async throws -> [UnsplashPhoto]
}

final class GalleryService: GalleryServiceProtocol {
    
    private let accessKey = "PXvlcWbcF8tifyM0uU90f2MjXx1QnVxrj3y5vh4-8dk"
    // client_id=\(accessKey)&
    func fetchPhotos(page: Int) async throws -> [UnsplashPhoto] {
        
        guard NetworkMonitor.shared.isConnected == true else {
            throw NetworkError.noInternetConnection
        }
        
        guard let url = URL(string: "https://api.unsplash.com/photos?query=nature&orientation=landscape&page=\(page)&per_page=20")
        else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        print("REQUEST: ", request)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        print("RESPONSE: ", response)
        
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
            for res in decoded {
                print("========")
                print(res.id)
                print(res.urls.regular)
                print(res.urls.small)
                print("========")
            }
            return decoded
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
