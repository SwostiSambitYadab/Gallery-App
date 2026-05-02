//
//  GalleryModel.swift
//  GalleryApp
//
//  Created by Swosti Sambit Yadab on 02/05/26.
//

import Foundation
import SwiftData

/// Data persistant using `SwiftData`
import SwiftData

@Model
final class Gallery {
    
    @Attribute(.unique) var id: String
    var thumbnailFileName: String
    var fullImageFileName: String
    
    init(id: String, thumbnailFileName: String, fullImageFileName: String) {
        self.id = id
        self.thumbnailFileName = thumbnailFileName
        self.fullImageFileName = fullImageFileName
    }
}

extension Gallery {
    static func from(_ photo: UnsplashPhoto) async -> Gallery? {
        async let thumb = ImageCacheManager.shared.getImage(from: photo.urls.small)
        async let full = ImageCacheManager.shared.getImage(from: photo.urls.regular)
        
        guard let t = await thumb,
              let f = await full else { return nil }
        
        return Gallery(id: photo.id, thumbnailFileName: t, fullImageFileName: f)
    }
}

/// API Response
struct UnsplashPhoto: Decodable {
    let id: String
    let urls: Urls
}

struct Urls: Decodable {
    let small: String
    let regular: String
}
