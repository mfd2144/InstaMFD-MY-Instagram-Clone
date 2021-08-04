//
//  File.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 20.07.2021.
//

import Foundation
import Contacts



protocol ContactsDelegate:AnyObject{
    typealias results = (Results<[CNContact]>)->()
    func contactResult(completion:results)
}


final class Contacts:ContactsDelegate{
    private var contactList = [CNContact]()
    private var contacts = [ContactPresentation]()
    
    internal func contactResult(completion: (Results<[CNContact]>) -> ()) {
        
        guard let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),CNContactPhoneNumbersKey,CNContactEmailAddressesKey] as? [CNKeyDescriptor] else {return}
        
        let request = CNContactFetchRequest(keysToFetch:keys )
        let contactStore = CNContactStore()
        
        request.mutableObjects = false
        request.unifyResults = true
        request.sortOrder = .userDefault
        
        
        do{
            try contactStore.enumerateContacts(with: request, usingBlock: {[unowned self] contact, stop in
                contactList.append(contact)
            })
            completion(.success(contactList))
        }catch{
            completion(.failure(GeneralErrors.unspesificError(error.localizedDescription)))
        }
    }
    
    public func getContact(completion:@escaping (Results<[ContactPresentation]>) -> ()){
        contactList = [CNContact]()
        contacts = [ContactPresentation]()
        
        DispatchQueue.main.async(execute: {[unowned self] in
            
            contactResult { results in
                switch results{
                case .failure(let error):
                    completion(.failure(error))
                case.success(let cnContacts):
                  
                    cnContacts?.forEach({ cnContact in
                        let phones = cnContact.phoneNumbers.map({$0.value.stringValue})
                        var phonesWithoutChar = [String]()
                        phones.forEach { phone in
                            var _phone = phone
                            _phone.removeAll { char in
                                if char == " " || char == "(" || char == ")" || char == "-" || char == "+" {
                                    return true
                                }
                                else{
                                    return false
                                }
                            }
                            phonesWithoutChar.append(_phone)
                        }
                        
                        let emails = cnContact.emailAddresses.map({$0.value as String})
                        let contactPresentation = ContactPresentation(name: cnContact.familyName, phones:phonesWithoutChar, emails: emails)
                        contacts.append(contactPresentation)
                    })
                    completion(.success(contacts))
                }
            }
            
            
            
        })
        
    }
}
