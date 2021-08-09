//
//  AlbumCollection.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 4.08.2021.
//

import Foundation
import Photos
import UIKit.UIImage

class AlbumCollection: NSObject {
    //MARK: - Properties
    var collection: PHAssetCollection
    var name: String
    var count: Int? {
        get {
            return self.assetsResult?.count
        }
    }
    
    var lastImage: UIImage?
    var assetsResult: PHFetchResult<PHAsset>?
    
    
    init(with collection: PHAssetCollection) {
        self.collection = collection
        self.name = collection.localizedTitle ?? "photoAlbum"
        super.init()
        }
    
    func getLastImage(size: CGSize, complete: @escaping ((_ image: UIImage?) -> Void)) -> Void {
        self.fetchAssets(block: {[weak self] (result: PHFetchResult<PHAsset>) in
            self?.getImage(with: result.lastObject, size: size, complete: { [weak self] (image) in
                self?.lastImage = image
                complete(image)
            })
        })
    }
    
  
    fileprivate func getImage(with asset: PHAsset?, size: CGSize, complete: @escaping ((_ image: UIImage?) -> Void)) -> Void {
        if asset != nil {
            let options:PHImageRequestOptions = PHImageRequestOptions.init()
            options.resizeMode = .fast
            options.deliveryMode = .highQualityFormat
            options.isNetworkAccessAllowed = true
            let _ = asset?.requestImage(options: options, size: size, block: { (dic) in
                         complete(dic[AlbumConstant.ImageKey] as? UIImage)
                     })
        } else {
            complete(nil)
        }
    }
    
    
    func fetchAssets(block: @escaping ((_ result: PHFetchResult<PHAsset>) -> Void)) -> Void {
        let options = PHFetchOptions.init()
        options.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false)]
        self.assetsResult = PHAsset.fetchAssets(in: self.collection, options: options)
        block(self.assetsResult!)
    }
    

    

}



