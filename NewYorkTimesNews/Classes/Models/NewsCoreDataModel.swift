//
//  NewsCoreDataModel.swift
//  NewYorkTimesNews
//
//  Created by Vitaliy on 28.05.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import Foundation

struct NewsCoreDataModel {
    let title: String
    var iconData: Data
    let iconLink: String?
    let newsLink: String
    let publishedDate: String
    var isFavorite: Bool
    
    static var placeholder: Self {
        NewsCoreDataModel(title: "",
                          iconData: Data(),
                          iconLink: nil,
                          newsLink: "",
                          publishedDate: "",
                          isFavorite: false)
    }
    
    mutating func makeFavorite(_ isFavorite: Bool) {
        self.isFavorite = isFavorite
    }
    
    mutating func setIconData(data: Data) {
        self.iconData = data
    }
}
