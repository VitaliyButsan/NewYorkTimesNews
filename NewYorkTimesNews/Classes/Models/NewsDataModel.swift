//
//  NewsModel.swift
//  NewYorkTimesNews
//
//  Created by Vitaliy on 26.05.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import Foundation

struct NewsDataWrapper: Decodable {
    let results: [NewsInfo]
}

struct NewsInfo: Decodable {
    let url: String
    let title: String
    let media: [MediaInfo]
}

struct MediaInfo: Decodable {
    let metaData: [MetaDataInfo]
    
    enum CodingKeys: String, CodingKey {
        case metaData = "media-metadata"
    }
}

struct MetaDataInfo: Decodable {
    let iconURL: String
    
    enum CodingKeys: String, CodingKey {
        case iconURL = "url"
    }
}
