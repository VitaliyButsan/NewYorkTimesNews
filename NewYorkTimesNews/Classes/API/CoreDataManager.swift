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
                for newsEntity in result {
                    let newNews = NewsCoreDataModel(title: newsEntity.title,
                                                    iconData: newsEntity.iconData,
                                                    iconLink: newsEntity.iconURL,
                                                    newsLink: newsEntity.newsLink,
                                                    publishedDate: newsEntity.publishedDate,
                                                    isFavorite: newsEntity.isFavorite)
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
        if !isExist(news) {
            self.delegate.persistentContainer.performBackgroundTask { context in
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
    }
    
    // delete
    func delNewsByTitle(title: String) {
        delegate.persistentContainer.performBackgroundTask { context in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "News")
            request.predicate = NSPredicate(format: "title = %@", title)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            
            do {
                try context.execute(batchDeleteRequest)
            } catch {
                print(error)
            }
            
            self.save(context: context)
        }
    }
    
    // is exist
    private func isExist(_ news: NewsCoreDataModel) -> Bool {
        let context = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "News")
        request.predicate = NSPredicate(format: "title = %@", news.title)
        
        do {
            let result = try context.fetch(request) as! [News]
            return result.contains { $0.title == news.title }
        } catch {
            print(error.localizedDescription)
        }
        return false
    }
    
    // save context
    private func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("ERROR: Could not save context. \(error)")
        }
    }
}
