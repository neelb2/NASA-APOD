//
//  BaseNetworkManager.swift
//  NASA-APOD
//
//  Created by Neel Bhasin on 05/09/22.
//

import Foundation

class BaseNetworkManager: NSObject {
    
    class func makeWebRequest(urlString:String,onCompletion: @escaping (Data) -> Void, OnError: @escaping (Error)->Void){
        let cached = hasFile(key: urlString)
        if cached.0 {
            if let d = cached.1{
                DispatchQueue.main.async {
                    onCompletion(d)
                    return
                }
            }
        }
        if let url = URL.init(string: urlString){
            let urlRequest = URLRequest.init(url: url)
            let session = URLSession.shared
            let task = session.dataTask(with: urlRequest, completionHandler: {data, response, error in
                if let e = error{
                    DispatchQueue.main.async {
                        OnError(e)
                    }
                }else if let d = data{
                    DispatchQueue.main.async {
                        onCompletion(d)
                        BaseNetworkManager.cacheData(data: d, key: urlString)
                    }
                }
            })
            task.resume()
        }
    }
    
    class func cacheData(data: Data, key: String) {
        var fileName = "abc.json"
        if let name = key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            fileName = name + ".json"
        }
        let fm = FileManager.default
        if let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first{
            let filePath = dir.appendingPathComponent(fileName)
            if !hasFile(key: key).0 {
                fm.createFile(atPath: filePath.path, contents: data)
            }
        }
    }
    
    class func hasFile(key: String) -> (Bool, Data?) {
        var fileName = "abc.json"
        if let name = key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            fileName = name + ".json"
        }
        let fm = FileManager.default
        if let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first{
            let filePath = dir.appendingPathComponent(fileName)
            if fm.fileExists(atPath: filePath.path) {
                let data = fm.contents(atPath: filePath.path)
                return (true, data)
            }else{
                return (false, nil)
            }
        }
        return (false, nil)
    }
    
    
    class func dowloadImage(urlString:String, onCompletion: @escaping (Data,String) -> Void, OnError: @escaping (Error)->Void){
        let cachedImage = hasFile(key: urlString)
        if cachedImage.0 {
            if let d = cachedImage.1 {
                DispatchQueue.main.async {
                    onCompletion(d, urlString)
                    return
                }
            }
        }
        if let url = URL.init(string: urlString){
            let urlRequest = URLRequest.init(url: url)
            let session = URLSession.shared
            let task = session.dataTask(with: urlRequest, completionHandler: {data, response, error in
                if let e = error{
                    DispatchQueue.main.async {
                        OnError(e)
                    }
                }else if let d = data{
                        DispatchQueue.main.async {
                            onCompletion(d, (urlRequest.url?.absoluteString)!)
                            BaseNetworkManager.cacheData(data: d, key: (urlRequest.url?.absoluteString)!)
                        }
                }
            })
            task.resume()
        }
    }
}
