//
//  CachyExtension.swift
//  Cachy
//
//  Created by Federico Gentile on 28/12/16.
//  Copyright © 2016 Federico Gentile. All rights reserved.
//

import UIKit

extension UIImageView {
    
    //download image from url
    private func downloadedFrom(url: URL, completion: @escaping (_ success: Bool, _ image: UIImage) -> () ) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            completion(true, image)
            
            }.resume()
    }
    
    //download image from string
    private func downloadedFrom(link: String, completion: @escaping (_ success: Bool, _ image: UIImage) -> () ) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, completion: {
            (success, image) in
            if success {
                completion(true, image)
            }
        })
    }
    
    func cachyImageFrom(link: String, withHandler handler: @escaping (_ success: Bool) -> ()) {
        DispatchQueue.global().async {
            if Cachy.getFirstTime() {
                Cachy.refreshDirectory()
            }
            
            if let image = Cachy.getCachyImage(link: link) {
                DispatchQueue.main.async() { () -> Void in
                    self.image = image
                }
            } else {
                self.downloadedFrom(link: link, completion: { (success, image) in
                    if success {
                        Cachy.saveImage(image: image, name: link)
                        DispatchQueue.main.async() { () -> Void in
                            self.image = image
                            handler(true)
                        }
                    }
                    handler(false)
                })
            }
        }
    }
    
    func cachyImageFrom(link: String) {
        cachyImageFrom(link: link, withHandler: {_ in})
    }
    
}
