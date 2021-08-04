//
//  SmartAlbumCohoicer.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 28.07.2021.
//

import Foundation
import Photos


protocol SmartAlbumChoicerProtocol:AnyObject{
    func anyError(_ errorDescription: String)
    func sendImages(images:[ImageContainer])
    func endOfAlbum()
    //    func sendVideo()
}


final class SmartAlbumChoicer:NSObject{
    let imageManager = PHImageManager.default()
    var albums = [AlbumPresentation]()
    weak var delegate:SmartAlbumChoicerProtocol?
    var lastIndex = 0
    var albumType = PHAssetCollectionSubtype.smartAlbumRecentlyAdded
    
    
    override init() {
        super.init()
        authChecker()
        fetchAlbums()
        fetchSmartAlbums()
    }
    
    
    func authChecker(){
        PHPhotoLibrary.requestAuthorization {[unowned self] status in
            switch status {
            case .authorized:
                break
            case .denied, .restricted:
                delegate?.anyError("Not Allowed")
            case .notDetermined:
                // Should not see this when requesting
                delegate?.anyError("Not Detemined Yet")
            case.limited:
                delegate?.anyError("Limited")
            @unknown default:
                delegate?.anyError("Not Allowed")
            }
        }
    }
    
    
    func selectAlbumImages(title:String){
        
        var imagesContainer = [ImageContainer]()
        var assetCollection = PHAssetCollection()
        
        var photoAssets = PHFetchResult<PHAsset>()
        let fetchOptions = PHFetchOptions()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .opportunistic
        
        fetchOptions.predicate = NSPredicate(format: "title = %@", title)
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let firstObject = collection.firstObject{
            //found the album
            assetCollection = firstObject
            
        }
        else {
            delegate?.anyError("Album doesn't found")
        }
        _ = collection.count
        photoAssets = PHAsset.fetchAssets(in: assetCollection, options: nil)
        let imageManager = PHCachingImageManager()
        photoAssets.enumerateObjects{ [unowned self](asset,index,_) in
            
            let options = PHImageRequestOptions()
            options.deliveryMode = .fastFormat
            options.isSynchronous = true
            
            imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth/10, height: asset.pixelHeight/10), contentMode: .aspectFill, options:requestOptions ,resultHandler: { (image, info) -> Void in
                let container = ImageContainer(images: image, info: info)
                imagesContainer.append(container)
                
                if index == photoAssets.count-1{
                    delegate?.sendImages(images: imagesContainer)
                }
                
            })
            
        }
    }
    
    
    
    
    
    
    
    func selectSmartAlbumImages(albumTypeRawValue:Int?){
        if albumTypeRawValue != nil, let sendedAlbumType = PHAssetCollectionSubtype.init(rawValue: albumTypeRawValue!){
            albumType = sendedAlbumType
            lastIndex = 0
        }
        var imagesContainer = [ImageContainer]()
        //Create asset collection, request and fetch option classes
        var assetCollection: PHAssetCollection?
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .opportunistic
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let collectionfetchOptions = PHFetchOptions()
        //        collectionfetchOptions.predicate =  NSPredicate(format: "localIdentifier = %@", "9GAG")
        
        let  collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: albumType, options: collectionfetchOptions)
        if let firstObject = collection.firstObject{
            //found the album
            assetCollection = firstObject
        }
        else {
            delegate?.anyError("Album doesn't found")
            
        }
        
        guard let assetCollection = assetCollection else {return}
        let phAssets = PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
       
        
        phAssets.enumerateObjects {[unowned self] phAsset, index, _ in
            imageManager.requestImage(for: phAsset, targetSize: CGSize(width: phAsset.pixelWidth/6, height: phAsset.pixelHeight/6), contentMode:.aspectFill , options: requestOptions) { image, info in
                let container = ImageContainer(images: image, info: info)
                imagesContainer.append(container)
            }
            if index == phAssets.count-1{
                              delegate?.sendImages(images: imagesContainer)
                          }
            
        }
        

    }
    
    
    
    
    func fetchSmartAlbums(){
        
        let albumsType:[PHAssetCollectionSubtype] = [.smartAlbumUserLibrary,.smartAlbumRecentlyAdded, .smartAlbumFavorites]
        
        for type in albumsType{
            var album: AlbumPresentation?
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .highQualityFormat
            let fetchOptions = PHFetchOptions()
            let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype:type, options: nil)
            guard let firstObject = smartAlbums.firstObject else {return}
            let phAssetsResult = PHAsset.fetchAssets(in: firstObject, options: fetchOptions)
            
            guard let asset = phAssetsResult.firstObject else {return}
            
            imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth/4, height: asset.pixelHeight/4), contentMode:.aspectFill , options: requestOptions) {  image, info in
                album = AlbumPresentation(image: image, albumName: firstObject.localizedTitle ?? "unkonown", imageNumber: phAssetsResult.count, albumType: type.rawValue, smartAlbum: 1)
            }
            
            guard let album = album else {return}
            albums.append(album)
        }
        
    }
    
    
    private func fetchAlbums(){
        let option = PHFetchOptions()
        option.includeHiddenAssets = false
        option.includeAssetSourceTypes = .typeUserLibrary
        
        let phCollectionFetchResults = PHCollection.fetchTopLevelUserCollections(with: option)
        phCollectionFetchResults.enumerateObjects {[unowned self] phCollection, index, error in
            guard let title = phCollection.localizedTitle else {delegate?.anyError("list error");return}
            fetchCustomAlbums(title: title)
        }
    }
    
    
    private func fetchCustomAlbums(title:String){
        
        
        var assetCollection = PHAssetCollection()
        var photoAssets = PHFetchResult<PHAsset>()
        let fetchOptions = PHFetchOptions()
        
        fetchOptions.predicate = NSPredicate(format: "title = %@", title)
        let collectionResult :PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        if let firstObject = collectionResult.firstObject{
            //found the album
            assetCollection = firstObject
            
        }
        else {
            delegate?.anyError("album fetching error")
        }
        
        let option = PHFetchOptions()
        
        option.fetchLimit = 1
        photoAssets = PHAsset.fetchAssets(in: assetCollection, options: option)
        photoAssets.enumerateObjects{ [unowned self] asset,index,stop in
            
            
            let imageSize = CGSize(width: asset.pixelWidth/4,
                                   height: asset.pixelHeight/4)
            
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.isSynchronous = true
            
            
            imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: options, resultHandler: {
                (image, info) -> Void in
                let album = AlbumPresentation(image: image, albumName: title, imageNumber: assetCollection.estimatedAssetCount, albumType: nil)
                albums.append(album)
            })
            
        }
    }
    
}



