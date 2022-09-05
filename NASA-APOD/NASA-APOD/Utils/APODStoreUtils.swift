//
//  APODStoreUtils.swift
//  NASA-APOD
//
//  Created by Neel Bhasin on 05/09/22.
//

import Foundation

class APODStoreUtils {
    static let sharedInstance = APODStoreUtils()
    private let lastFetch = "lastFetch"
    private let favArray = "favArray"
    private let ud = UserDefaults.standard
    private init() {
        
    }
    
    func storeLastFetchKey(_ value: String) {
        ud.set(value, forKey: lastFetch)
        ud.synchronize()
    }
    
    func getLastFetchKey() -> String? {
        return ud.value(forKey: lastFetch) as? String
    }
    
    func addToFav(_ value: String) {
        if let favs = getFavs() {
            var updated = favs
            updated.append(value)
            ud.set(updated, forKey: favArray)
        }else {
            ud.set([value], forKey: favArray)
        }
        ud.synchronize()
    }
    
    func removeFromFav(_ value: String) {
        if let favs = getFavs() {
            var index = -1
            for i in 0..<favs.count {
                if value == favs[i]{
                    index = i
                    break
                }
            }
            if index != -1 {
                var updated = favs
                updated.remove(at: index)
                ud.set(updated, forKey: favArray)
            }
        }
        ud.synchronize()
    }
    
    func getFavs() -> [String]? {
        let favs = ud.value(forKey: favArray) as? [String]
        return favs
    }
    
    func isStoredInFav(_ value: String) -> Bool {
        if let favs = getFavs() {
            return favs.contains(value)
        }
        return false
    }
}
