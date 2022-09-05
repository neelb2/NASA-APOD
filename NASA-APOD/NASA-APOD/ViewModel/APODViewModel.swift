//
//  APODViewModel.swift
//  NASA-APOD
//
//  Created by Neel Bhasin on 05/09/22.
//

import Foundation


protocol APODDataFetchDelegate {
    func fetchSuccessfull()
    func fetchFailed()
}

class APODViewModel {
    var response: APODModel?
    var delegate: APODDataFetchDelegate?
    var updatedUrl: String = ""
    func getImageFor(_ date: String) {
        var url = APIUtils.API_URL + "&date=" + date
        if !Reachability.isConnectedToNetwork() {
            if let key = APODStoreUtils.sharedInstance.getLastFetchKey() {
                url = key
            }
        }
        updatedUrl = url
        BaseNetworkManager.makeWebRequest(urlString: url, onCompletion: {data in
                let decoder = JSONDecoder()
                if let json = try? decoder.decode(APODModel.self, from: data) {
                    self.response = json
                    self.delegate?.fetchSuccessfull()
                }
        }, OnError: {error in
            self.delegate?.fetchFailed()
        })
    }

}
