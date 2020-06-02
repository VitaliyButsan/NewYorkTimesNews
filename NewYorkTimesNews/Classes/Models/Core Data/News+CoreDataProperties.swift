//
//  News+CoreDataProperties.swift
//  NewYorkTimesNews
//
//  Created by Vitaliy on 02.06.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//
//

import Foundation
import CoreData


extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var iconData: Data
    @NSManaged public var isFavorite: Bool
    @NSManaged public var newsLink: String
    @NSManaged public var title: String
    @NSManaged public var iconURL: String?
    @NSManaged public var publishedDate: String

}
