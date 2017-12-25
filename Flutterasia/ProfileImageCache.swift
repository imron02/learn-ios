//
//  ProfileImageCache.swift
//  Flutterasia
//
//  Created by Imron Rosdiana on 07/10/17.
//  Copyright © 2017 Imron Rosdiana. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject> ()

extension UIImageView {
    func loadProfileImageCache(urlString: String) {
        // Check image cache
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        let url = URLRequest(url: URL(string: urlString)!)
        URLSession.shared.dataTask(with: url as URLRequest, completionHandler: { (data, _, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
            }
        }).resume()
    }
}
