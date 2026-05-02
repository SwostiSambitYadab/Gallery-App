//
//  NetworkError.swift
//  GalleryApp
//
//  Created by Swosti Sambit Yadab on 02/05/26.
//

import Foundation

enum NetworkError: Error {
    case noInternetConnection
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decodingFailed
    case noData
    
    var errorDescription: String {
        switch self {
        case .noInternetConnection:
            return "No Internet Connection"
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .statusCode(let code):
            return "Server error with status code: \(code)"
        case .decodingFailed:
            return "Failed to decode response"
        case .noData:
            return "No data received"
        }
    }
}
