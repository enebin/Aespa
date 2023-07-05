//
//  URLIdentifierMap.swift
//  
//
//  Created by 이영빈 on 2023/07/05.
//

import Foundation

struct URLIdentifierBidirectionalMap {
    static private let identifierTableKey = "Aespa.UserDefaults.LocalIdentifierTableKey"
    static private let urlTableKey = "Aespa.UserDefaults.URLTableKey"

    static private let storage = UserDefaults.standard
    
    static func add(address: URL, localIdentifier: String) {
        var identifierTable = storage.object(forKey: identifierTableKey) as? [String: String] ?? [:]
        var urlTable = storage.object(forKey: urlTableKey) as? [String: String] ?? [:]
        
        identifierTable[address.absoluteString] = localIdentifier
        urlTable[localIdentifier] = address.absoluteString
        
        storage.set(identifierTable, forKey: identifierTableKey)
        storage.set(urlTable, forKey: urlTableKey)
    }
    
    static subscript(address: URL) -> String? {
        guard let identifierTable = storage.object(forKey: identifierTableKey) as? [String: String] else {
            return nil
        }
        
        return identifierTable[address.absoluteString]
    }
    
    static subscript(localIdentifier: String) -> URL? {
        guard let urlTable = storage.object(forKey: urlTableKey) as? [String: String],
              let urlString = urlTable[localIdentifier] else {
            return nil
        }
        
        return URL(string: urlString)
    }
}
