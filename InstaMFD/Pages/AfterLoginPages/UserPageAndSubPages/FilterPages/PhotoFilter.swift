//
//  PhotoFilter.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 29.07.2021.
//

import CoreImage
import UIKit.UIImage
import Combine


protocol PhotoFilterProtocol:AnyObject{
    func carryToContainer(_ container: [FilteredImageContainer])
}


struct FilteredImageContainer:Hashable{
    let name:String
    let container:ImageContainer
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func == (lhs:FilteredImageContainer,rhs:FilteredImageContainer)->Bool{
        return lhs.name == rhs.name
    }
}



final class PhotoFilters {
    
    private let originalImagesContainer:ImageContainer
    private let info:[AnyHashable : Any]?
    private var ciImage:CIImage
    var delegate:PhotoFilterProtocol?{
        didSet{
            filterImage()
        }
    }
    
    
    init(container: ImageContainer)  {
        originalImagesContainer = container
        self.info = container.info
        if let image = CIImage(image: container.images!) {
            ciImage = image
      
        }else{
            fatalError()
        }
        
    }
    
    private func filterImage(){
        
        var container = Array<FilteredImageContainer>()
        if let sepiaImage = sepiaFilter(ciImage, intensity: 0.9){
            let filtered = FilteredImageContainer(name: "sepia", container: ImageContainer(images: UIImage(ciImage: sepiaImage), info: info))
            container.append(filtered)
            
        }
        if let  bloomImage = bloomFilter(ciImage, intensity: 1, radius: 1){
            let filtered = FilteredImageContainer(name: "bloom", container: ImageContainer(images: UIImage(ciImage: bloomImage), info: info))
            container.append(filtered)
            
            if let  increasedContrastImage = increaseContrastFilter(ciImage, intensity: 1, radius: 1){
                let filtered = FilteredImageContainer(name: "increased contrast", container: ImageContainer(images: UIImage(ciImage: increasedContrastImage), info: info))
                container.append(filtered)
                
                if let  sharpenLuminanceImage = increaseSharpenLuminance(ciImage, sharpness: 1){
                    let filtered = FilteredImageContainer(name: "sharpen luminance", container: ImageContainer(images: UIImage(ciImage: sharpenLuminanceImage), info: info))
                    container.append(filtered)
                    
                    if let  vignetteFilter = vignetteFilter(ciImage, intensity: 2, radius: 2){
                        let filtered = FilteredImageContainer(name: "vignette", container: ImageContainer(images: UIImage(ciImage: vignetteFilter), info: info))
                        container.append(filtered)
                        
                        if let vintageFilter = vintageFilter(ciImage){
                            let filtered = FilteredImageContainer(name: "vintage", container: ImageContainer(images: UIImage(ciImage: vintageFilter), info: info))
                            container.append(filtered)
                            
                            if let  exaggeratedFilter = exaggeratedBlackAndWhiteFilter(ciImage){
                                let filtered = FilteredImageContainer(name: "exaggerated  b&w", container: ImageContainer(images: UIImage(ciImage: exaggeratedFilter), info: info))
                                container.append(filtered)
                                
                                if let  photoeffect = photoEffectTransferFilter(ciImage){
                                    let filtered = FilteredImageContainer(name: "effect transfer", container: ImageContainer(images: UIImage(ciImage: photoeffect), info: info))
                                    container.append(filtered)
                                    
                                    let original = FilteredImageContainer(name: "original", container: originalImagesContainer)
                                    container.append(original)
                                    delegate?.carryToContainer(container)
                                }
                            }
                        }
                    }
                }
                
                
            }
            
            
        }
        
        
        
    }
    
    
    //        if let  posterizeFilter = posterizeFilter(ciImage, inputLevel: 2){
    //            let filtered = FilteredImageContainer(name: "poster", container: ImageContainer(images: UIImage(ciImage: posterizeFilter), info: info))
    //            container.append(filtered)
    //        }
    
    
    
    
    
    
    
    private func sepiaFilter(_ input: CIImage, intensity: Double) -> CIImage?
    {
        let sepiaFilter = CIFilter(name:"CISepiaTone")
        sepiaFilter?.setValue(input, forKey: kCIInputImageKey)
        sepiaFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        return sepiaFilter?.outputImage
    }
    
    private func bloomFilter(_ input:CIImage, intensity: Double, radius: Double) -> CIImage?
    {
        let bloomFilter = CIFilter(name:"CIBloom")
        bloomFilter?.setValue(input, forKey: kCIInputImageKey)
        bloomFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        bloomFilter?.setValue(radius, forKey: kCIInputRadiusKey)
        return bloomFilter?.outputImage
    }
    
    private func increaseContrastFilter(_ input:CIImage , intensity: Double, radius: Double) -> CIImage?{
        let unsharpFilter = CIFilter(name:"CIUnsharpMask")
        unsharpFilter?.setValue(input, forKey: kCIInputImageKey)//check
        unsharpFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        unsharpFilter?.setValue(radius, forKey: kCIInputRadiusKey)
        return unsharpFilter?.outputImage
    }
    
    private func increaseSharpenLuminance(_ input:CIImage , sharpness: Double)->CIImage?{
        
        let increaseSharpenLuminanceFilter = CIFilter(name:"CISharpenLuminance")
        increaseSharpenLuminanceFilter?.setValue(input, forKey: kCIInputImageKey)//check
        increaseSharpenLuminanceFilter?.setValue(sharpness, forKey: kCIInputSharpnessKey)
        return increaseSharpenLuminanceFilter?.outputImage
    }
    
    private func vignetteFilter(_ input:CIImage , intensity: Double, radius: Double)->CIImage?{
        let vignetteFilter = CIFilter(name:"CIVignette")
        vignetteFilter?.setValue(input, forKey: kCIInputImageKey)//check
        vignetteFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        vignetteFilter?.setValue(radius, forKey: kCIInputRadiusKey)
        return vignetteFilter?.outputImage
    }
    
    private func photoEffectTransferFilter(_ input:CIImage )->CIImage?{
        let photoEffectTransfer = CIFilter(name:"CIPhotoEffectTransfer")
        photoEffectTransfer?.setValue(input, forKey: kCIInputImageKey)//check
        
        return photoEffectTransfer?.outputImage
    }
    
    private  func blackAndWhiteFilter(_ input:CIImage )->CIImage?{
        let photoEffectTonal = CIFilter(name:" CIPhotoEffectTonal")
        photoEffectTonal?.setValue(input, forKey: kCIInputImageKey)//check
        
        return photoEffectTonal?.outputImage
    }
    
    
    
    private func exaggeratedBlackAndWhiteFilter(_ input:CIImage )->CIImage?{
        let photoEffectNoir = CIFilter(name:"CIPhotoEffectNoir")
        photoEffectNoir?.setValue(input, forKey: kCIInputImageKey)//check
        return photoEffectNoir?.outputImage
    }
    
    private func vintageFilter(_ input:CIImage )->CIImage?{
        let vintage = CIFilter(name:"CIPhotoEffectInstant")
        vintage?.setValue(input, forKey: kCIInputImageKey)//check
        return vintage?.outputImage
    }
    
    
    
    
    //    func posterizeFilter(_ input:CIImage , inputLevel: Double)->CIImage?{
    //
    //        let increaseSharpenLuminanceFilter = CIFilter(name:"CIColorPosterize")
    //        increaseSharpenLuminanceFilter?.setValue(input, forKey: kCIInputImageKey)//check
    //        increaseSharpenLuminanceFilter?.setValue(inputLevel, forKey: kCIInputScaleKey)
    //        return increaseSharpenLuminanceFilter?.outputImage
    //    }
    
    
    
    
    
}
