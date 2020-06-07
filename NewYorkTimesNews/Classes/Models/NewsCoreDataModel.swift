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
    let iconData: Data
    let iconLink: String?
    let newsLink: String
    let publishedDate: String
    var isFavorite: Bool
    
    mutating func makeFavorite(_ isFavorite: Bool) {
        self.isFavorite = isFavorite
    }
    
    public static func ==(lhs: NewsCoreDataModel, rhs: NewsCoreDataModel) -> Bool {
        return
            lhs.title == rhs.title &&
            lhs.iconLink == rhs.iconLink &&
            lhs.newsLink == rhs.newsLink &&
            lhs.publishedDate == rhs.publishedDate
    }

    static var placeholder: Self {
        NewsCoreDataModel(title: "",
                          iconData: Data(),
                          iconLink: nil,
                          newsLink: "",
                          publishedDate: "",
                          isFavorite: false)
    }
}
