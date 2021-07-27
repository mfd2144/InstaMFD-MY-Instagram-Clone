//
//  CountryCodesViewModel.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 14.07.2021.
//

import UIKit


final class CountryCodesViewModel:CountryCodesViewModelProtocol{
    weak var delegate: CountryCodesViewModelDelegate?
    var lastIndex = 0
    let firsIndex = 20
    var countryCodes: [CountryCode]!{
        didSet{
            callMorePresentation(index: firsIndex)
        }
    }
    var newResults = [CountryPresentation]()
    typealias complete = (Data?, URLResponse?, Error?) -> ()
    
    
    func callMorePresentation(index: Int) {
        guard let countryCodes = countryCodes else { return }
        
        var indexPlus = index+5
        if  indexPlus > countryCodes.count {
            indexPlus = countryCodes.count
        }
        
        guard indexPlus > lastIndex else {return}
        let dividedResult = Array(countryCodes[lastIndex..<indexPlus])
        lastIndex = indexPlus
       
        modelConverter(dividedResult) { [unowned self] results in
        
            switch results{
            case .success(let output):
                delegate?.handleOutPut(output: .success(output))
            case.failure(let err):
                delegate?.handleOutPut(output: .failure(err))
         
            }
        }
    }
    
    private func modelConverter(_ input:[CountryCode],completion:@escaping (Results<Any>)->Void){
        var escapeLogic = 0
        input.forEach({
            var flagImage: UIImage?
            let name = $0.name
            let code = $0.dialCode
            appContainer.photoDownloader.downloadImage($0.flag) { [unowned self] result in
                
                switch result{
                case.failure(let err):
                    completion(Results.failure(err))
                case.success(let image):
                    escapeLogic += 1
                    guard let image = image as? UIImage else {return}
                    flagImage = image
                }
                let new = CountryPresentation(flagImage: (flagImage ?? UIImage(systemName: "flag.circle"))!, name: name, code: code)
                newResults.append(new)
                if escapeLogic == input.count{
                    completion(Results.success(newResults))
                }
            }
            
            
            
        })
    }
    
    
    private func getData(from url: URL, completion: @escaping complete) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    private func downloadImage(_ url :URL,completion:@escaping (Results<Any>)->()){
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { completion(.failure(DecodeErrors.decodeError("Empty data/connection error")));return }
            let image = UIImage(data: data)
            completion(Results.success(image))
            
            
        }
    }
}
