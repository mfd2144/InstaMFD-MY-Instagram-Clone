//
//  SmartAlbumCohoicer.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 28.07.2021.
//

import Foundation
import Photos


protocol AlbumProviderProtocol:AnyObject{
    func reloadData(_ list: [AlbumCollection])
}

final class AlbumProvider:NSObject{
    
  weak var delegate: AlbumProviderProtocol?
    
    var selectedFiles: [AlbumFile] {
        get {
            var array: [AlbumFile] = Array()
            for item in self.selectedItems {
                array.append(item.value)
            }
            return array
        }
    }
    
    
    
    
    var selectedItems = Dictionary<String, AlbumFile>()
    var maxSelectCount = 20
    var disableSelectedMore = false

    var albumList: [AlbumCollection]?{
        didSet{
            delegate?.reloadData(albumList!)
        }
    }

    fileprivate var isRefreshing = false
    
 
    override init() {
        super.init()
    checkAuthorization()
    }
    
    
    func checkAuthorization(){
        PHPhotoLibrary.requestAuthorization {[unowned self] status in
            switch status {
            case .authorized:
                self.refreshData {
                  
                }
            case .denied, .restricted:
                
            print("")
            case .notDetermined:
             requestAuthorization()
          
            default:
                print("")
            }
        }
    }

    func requestAuthorization(){
        PHPhotoLibrary.requestAuthorization {[unowned self] _ in
            checkAuthorization()
        }
    }

    func refreshData(_ complete: @escaping ()->Void ) {
        if isRefreshing {
            return
        } else {
            isRefreshing = true
        }
        self.albumList = self.fetchAlbumsList()
        complete()
        self.isRefreshing = false
    }

    
    
    func fetchAlbumsList() -> [AlbumCollection] {
       
        var collections = Array<AlbumCollection>()
        //ios 8
        self.fetchAlbum(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.smartAlbumUserLibrary, options: nil, toArray: &collections, reName:"Photo album")
        self.fetchAlbum(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.smartAlbumVideos, options: nil, toArray: &collections, reName:"Videos")
        //ios9 above
        self.fetchAlbum(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.smartAlbumScreenshots, options: nil, toArray: &collections, reName:"Screenshots")
        self.fetchAlbum(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.albumRegular, options: nil, toArray: &collections, reName:nil)
        return collections
    }

    
    func fetchAlbum(with: PHAssetCollectionType, subtype: PHAssetCollectionSubtype, options: PHFetchOptions?, toArray: UnsafeMutablePointer<[AlbumCollection]>, reName:String?) -> Void {
        let results: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAlbum(with: with, subtype: subtype, options: options)
        results.enumerateObjects({ (collection, index, stop) in
            let result = PHAsset.fetchAssets(in: collection, options: nil)
            if result.count > 0 {
                let mycollection = AlbumCollection.init(with: collection)
                if let reName = reName {
                    mycollection.name = reName
                }
                toArray.pointee.append(mycollection)
                
            }
        })
    }


}

