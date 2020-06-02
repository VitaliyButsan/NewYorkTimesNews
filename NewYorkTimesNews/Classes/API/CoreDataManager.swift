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
                    let newNews = NewsCoreDataModel(title: obj.title,
                                                    iconData: obj.iconData,
                                                    iconLink: obj.iconURL,
                                                    newsLink: obj.newsLink,
                                                    publishedDate: obj.publishedDate,
                                                    isFavorite: obj.isFavorite)
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
    func writeNews(news: NewsCoreDataModel) {
        delegate.persistentContainer.performBackgroundTask { context in
            guard let newsEntity = NSEntityDescription.entity(forEntityName: "News", in: context) else { return }
            let newsManagedObject = NSManagedObject(entity: newsEntity, insertInto: context) as! News
            newsManagedObject.title = news.title
            newsManagedObject.iconURL = news.iconLink
            newsManagedObject.iconData = news.iconData
            newsManagedObject.newsLink = news.newsLink
            newsManagedObject.isFavorite = news.isFavorite
            newsManagedObject.publishedDate = news.publishedDate
            self.save(context: context)
        }
    }
    
    // delete news by title
    func delNewsByTitle(title: String) {
        delegate.persistentContainer.performBackgroundTask { context in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "News")
            request.predicate = NSPredicate(format: "title = %@", title)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            
            do {
                try context.execute(batchDeleteRequest)
                print("\(title) entity was deleted")
            } catch {
                print(error)
            }
            
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
