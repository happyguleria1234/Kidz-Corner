//
//  DownloadFile.swift
//  KidzCorner
//
//  Created by Happy Guleria on 31/07/24.
//

import UIKit

// Create a cache for storing downloaded and resized images
let imageCache = NSCache<NSURL, UIImage>()

// Function to download image from URL with caching and resizing
func downloadImage(from url: URL, targetSize: CGSize, completion: @escaping (UIImage?) -> Void) {
    // Check if the image is already cached
    if let cachedImage = imageCache.object(forKey: url as NSURL) {
        completion(cachedImage)
        return
    }
    
    // If not cached, download the image
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            print("Failed to download image: \(error?.localizedDescription ?? "No error description")")
            completion(nil)
            return
        }
        if let image = UIImage(data: data) {
            // Resize the image
            let resizedImage = image.resize(to: targetSize)
            imageCache.setObject(resizedImage, forKey: url as NSURL)
            completion(resizedImage)
        } else {
            completion(nil)
        }
    }
    task.resume()
}

// Function to convert an array of URLs to an array of resized UIImages
func convertURLsToUIImages(urls: [URL], targetSize: CGSize, completion: @escaping ([UIImage]) -> Void) {
    var images: [UIImage] = []
    let dispatchGroup = DispatchGroup()
    
    for url in urls {
        dispatchGroup.enter()
        downloadImage(from: url, targetSize: targetSize) { image in
            if let image = image {
                images.append(image)
            }
            dispatchGroup.leave()
        }
    }
    
    dispatchGroup.notify(queue: .main) {
        completion(images)
    }
}

// Extension to resize UIImage
extension UIImage {
    func resize(to targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Determine the scaling ratio that preserves aspect ratio
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // Create a new context to draw the resized image
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
