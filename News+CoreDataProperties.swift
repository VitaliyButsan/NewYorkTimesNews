//
//  News+CoreDataProperties.swift
//  NewYorkTimesNews
//
//  Created by Vitaliy on 28.05.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//
//

import Foundation
import CoreData


extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var icon: Data
    @NSManaged public var isFavorite: Bool
    @NSManaged public var link: String
    @NSManaged public var title: String

}
