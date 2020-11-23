//
//  ImageCache.swift
//  Kakaosplash
//
//  Created by Nicholas Kim on 2020/11/22.
//

import UIKit
import Foundation

class ImageCache {
    
    public static let shared = ImageCache()
    
    private let cachedImages = NSCache<NSURL, UIImage>()
    private var loadingResponses = [NSURL: [(Photo, UIImage?) -> Swift.Void]]()
    
    public func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
    func load(url: NSURL, item: Photo, completion: @escaping (Photo, UIImage?) -> Swift.Void) {
        // Check for a cached image
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                completion(item, cachedImage)
            }
            return
        }
        
        if loadingResponses[url] != nil {
            loadingResponses[url]?.append(completion)
            return
        } else {
            loadingResponses[url] = [completion]
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url as URL)) { (data, response, error) in
            
            guard let responseData = data, let image = UIImage(data: responseData),
                let blocks = self.loadingResponses[url], error == nil else {
                DispatchQueue.main.async {
                    completion(item, nil)
                }
                return
            }
            self.cachedImages.setObject(image, forKey: url, cost: responseData.count)

            for block in blocks {
                DispatchQueue.main.async {
                    block(item, image)
                }
                return
            }
        }.resume()
    }
        
}
