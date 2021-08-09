//
//  Photo.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 4.08.2021.
//

import Foundation
import Photos

extension PHAssetCollection {

    //get album
    class func fetchAlbum(with: PHAssetCollectionType, subtype: PHAssetCollectionSubtype, options: PHFetchOptions?) -> PHFetchResult<PHAssetCollection> {
        return PHAssetCollection.fetchAssetCollections(with: with, subtype: subtype, options: options)
    }
    
    //get all element in album
    func fetchAssets(block: @escaping ((_ result: PHFetchResult<PHAsset>) -> Void)) -> Void {
        block(PHAsset.fetchAssets(in: self, options: nil))
    }
    
    func fetchAssets(options: PHFetchOptions?, block: @escaping ((_ result: PHFetchResult<PHAsset>) -> Void)) -> Void {
        block(PHAsset.fetchAssets(in: self, options: options))
    }
}

extension PHAsset {
    
    class func createWith(identifier: String) -> PHAsset? {
        return PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil).firstObject
    }
    
    @discardableResult
    func requestURL(block: @escaping ((URL?, AVAsset?) -> Void)) -> PHImageRequestID {
        if self.mediaType != .video {
            Debug.AlbumDebug("requestURL error")
            block(nil, nil)
            return 0
        }
        let options: PHVideoRequestOptions = PHVideoRequestOptions()
        options.version = .current
        options.deliveryMode = .automatic
        
        return PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: { (asset, audioMix, info) in
            if let urlAsset: AVURLAsset = asset as? AVURLAsset {
                block(urlAsset.url, asset)
            } else {
                block(nil, nil)
            }
        })
    }
    
    

    func requestImage(size: CGSize, block: @escaping ((Dictionary<String, Any>) -> Void)) -> PHImageRequestID {
        let options = PHImageRequestOptions.init()
        options.deliveryMode = .opportunistic
        options.isNetworkAccessAllowed = true
        return self.requestImage(options: options, size: size, block: block)
    }
    

    func requestImage(options: PHImageRequestOptions, size: CGSize, block: @escaping ((Dictionary<String, Any>) -> Void)) -> PHImageRequestID {
        return PHCachingImageManager.default().requestImage(for: self, targetSize: size, contentMode: PHImageContentMode.aspectFill, options: options) { (image, info) in
            var dic = Dictionary<String, Any>()
            if let image = image {
                dic.updateValue(image, forKey: AlbumConstant.ImageKey)
            }
            if let info = info {
                dic.updateValue(info, forKey: AlbumConstant.ImageInfoKey)
            }
            block(dic)
        }
    }
    
    //Only valid for image verification, video is not tested
    func isICloudImageAsset() -> Bool {
        let options = PHImageRequestOptions.init()
        options.resizeMode = .fast
        options.isSynchronous = true
        
        
        var isICloudImageAsset = false
        PHImageManager.default().requestImage(for: self, targetSize: CGSize.init(width: 60, height: 60), contentMode: PHImageContentMode.aspectFill, options: options) { (image, info) in
            if (info?[PHImageResultIsInCloudKey] as? Bool) == true {
                isICloudImageAsset = true
            }
        }
        return isICloudImageAsset
    }

    //File path, size, id
    func requestAllInfo(block: @escaping (_ path: String, _ size: Double, _ identifier: String) -> Void) -> Void {
        if self.mediaType == .image {
            let options = PHImageRequestOptions.init()
            options.deliveryMode = .opportunistic
            options.isNetworkAccessAllowed = true
            PHImageManager.default().requestImageDataAndOrientation(for: self, options: options) { data, string, orient, info in
                Debug.AlbumDebug("requestImageData:\(String(describing: data?.count))")
                var filePath: String?, fileSize: Double?, identitier: String?
                identitier = self.localIdentifier
                if data != nil {
                    fileSize = Double(data?.count ?? 0)
                    if let newInfo = info {
                        if let imageUrl = newInfo["PHImageFileURLKey"] as? URL {
                            filePath = imageUrl.path
                            
                            if filePath != nil , fileSize != nil, identitier != nil {
                                block(filePath!, fileSize!, identitier!)
                            } else {
                                Debug.AlbumDebug("requestAllInfo：Get Failed, \(String(describing: filePath)),\(String(describing: fileSize)),\(String(describing: identitier))")
                            }
                        } else {
                            Debug.AlbumDebug("requestAllInfo：Get Failed，imageUrl is empty")
                        }
                        
                    } else {
                        Debug.AlbumDebug("requestAllInfo： Get Failed，info is empty")
                    }
                }
            }
            
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .current
            options.deliveryMode = .automatic
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: { (asset, audioMix, info) in
                var filePath: String?, fileSize: Double?, identitier: String?
                if let urlAsset: AVURLAsset = asset as? AVURLAsset {
                    filePath = urlAsset.url.path
                    fileSize = self.getFileSize(url: urlAsset.url)
                    identitier = self.localIdentifier
                    if filePath != nil , fileSize != nil, identitier != nil {
                        block(filePath!, fileSize!, identitier!)
                    } else {
                        Debug.AlbumDebug("requestAllInfo：Get failed, \(String(describing: filePath)),\(String(describing: fileSize)),\(String(describing: identitier))")
                    }
                } else {
                    Debug.AlbumDebug("requestAllInfo: Failed to get urlAsset")
                }
            })
        } else {
            Debug.AlbumDebug("requestAllInfo： Obtaining failed, the file type is out of the processing range")
        }
    }
    
    fileprivate func getFileSize(url: URL) -> Double {
        do {
            let handle: FileHandle = try FileHandle.init(forReadingFrom: url)
            handle.seekToEndOfFile()
            let size = Double(handle.offsetInFile)
            handle.closeFile()
            Debug.AlbumDebug("filesize: \(size)")
            return size
        } catch {
            Debug.AlbumDebug("\(error)")
            return 0.0
        }
    }
}





