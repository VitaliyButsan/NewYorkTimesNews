//
//  CoreDataMonager.swift
//  NewYorkTimesNews
//
//  Created by Vitaliy on 28.05.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    
    private let delegate = UIApplication.shared.delegate as! AppDelegate
    
    // read
    func readNews(callback: @escaping ([NewsCoreDataModel]?) -> Void) {
        delegate.persistentContainer.performBackgroundTask { context in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "News")
            var news: [NewsCoreDataModel] = []
            
            do {
                let result = try context.fetch(fetchRequest) as! [News]
                for obj in result {
                    let newNews = NewsCoreDataModel(title: obj.title, icon: obj.icon, link: obj.link, isFavorite: obj.isFavorite)
                    news.append(newNews)
                }
                callback(news)
            } catch {
                print(error)
                callback(nil)
            }
        }
    }
    
    // write
    func write(news: NewsCoreDataModel) {
        delegate.persistentContainer.performBackgroundTask { context in
            guard let newsEntity = NSEntityDescription.entity(forEntityName: "News", in: context) else { return }
            let newsManagedObject = NSManagedObject(entity: newsEntity, insertInto: context) as! News
            newsManagedObject.title = news.title
            newsManagedObject.icon = news.icon
            newsManagedObject.isFavorite = news.isFavorite
            newsManagedObject.link = news.link
            self.save(context: context)
        }
    }
    
    // save context
    private func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Could not save context. \(error)")
        }
    }
}
