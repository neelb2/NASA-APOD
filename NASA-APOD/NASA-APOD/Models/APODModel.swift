//
//  APODModel.swift
//  NASA-APOD
//
//  Created by Neel Bhasin on 05/09/22.
//

import Foundation

class APODModel: Codable {
    var date: String?
    var explanation: String?
    var hdurl: String?
    var mediaType: String?
    var serviceVersion: String?
    var title: String?
    var url: String?
    var thumbnailUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case date, explanation, hdurl
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title, url
        case thumbnailUrl = "thumbnail_url"
    }

    init(date: String?, explanation: String?, hdurl: String?, mediaType: String?, serviceVersion: String?, title: String?, url: String?, thumbnailUrl: String?) {
        self.date = date
        self.explanation = explanation
        self.hdurl = hdurl
        self.mediaType = mediaType
        self.serviceVersion = serviceVersion
        self.title = title
        self.url = url
        self.thumbnailUrl = thumbnailUrl
    }
}
