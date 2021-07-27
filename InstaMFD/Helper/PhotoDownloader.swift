//
//  PhotoDownloader.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 26.07.2021.
//

import UIKit


final class PhotoDownloader:NSObject{
    typealias result = (Results<UIImage>)->()
    typealias completion = (Data?, URLResponse?, Error?) -> ()
    
    
    private func getData(from url: URL, completion: @escaping completion) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    public func downloadImage(_ url :URL,completion:@escaping result){
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { completion(.failure(DecodeErrors.decodeError("Empty data/connection error")));return }
            let image = UIImage(data: data)
            completion(Results.success(image))
            
            
        }
    }
    
}
