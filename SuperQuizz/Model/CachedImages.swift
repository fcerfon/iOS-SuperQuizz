//
//  cachedImages.swift
//  SuperQuizz
//
//  Created by formation 1 on 06/12/2018.
//  Copyright © 2018 formation 1. All rights reserved.
//

import Foundation

class CachedImages {
    
    static let instance = CachedImages()
    private init() {}
    
    var imagesMap : [String : Data] = [:]

    func addImageToMap(imgUrl : String, data : Data?) {
        guard data != nil else {
            return
        }
        imagesMap[imgUrl] = data
    }
    
    func loadImageFromUrl(imageUrl: String, onSuccess : @escaping (Data) -> ()) {
        
        if imagesMap[imageUrl] != nil {
            onSuccess(imagesMap[imageUrl]!)
        }
        
        guard let url = URL(string: imageUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Failed fetching image:", error!)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Not a proper HTTPURLResponse or statusCode")
                return
            }
            
            self.addImageToMap(imgUrl: imageUrl, data: data)
            
            DispatchQueue.main.async {
                onSuccess(self.imagesMap[imageUrl]!)
            }
        }.resume()
    }
}
