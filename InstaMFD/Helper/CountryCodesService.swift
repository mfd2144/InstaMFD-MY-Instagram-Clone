//
//  CountryCodesService.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 13.07.2021.
//

import Foundation



protocol CodesServiceProtocol:AnyObject{
    func fetchCodes( completion: @escaping (Results<CountryCodeResponse>)->Void)
}

final class CodesService:CodesServiceProtocol{
    func fetchCodes(completion: @escaping (Results<CountryCodeResponse>) -> Void) {
        let bundle = Bundle.test
        guard  let url = bundle.url(forResource: "countryPhoneCodes", withExtension: "json") else {
            completion(Results.failure(DecodeErrors.urlPathFail("Path Fail")))
            return}
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let results = try decoder.decode(CountryCodeResponse.self, from: data)
            completion(Results.success(results))
        } catch  {
            completion(Results.failure(DecodeErrors.decodeError("Decode error")))
        }
    }
}
