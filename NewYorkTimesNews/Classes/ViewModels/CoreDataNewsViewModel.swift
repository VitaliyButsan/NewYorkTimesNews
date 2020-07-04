//
//  CoreDataNewsViewModel.swift
//  NewYorkTimesNews
//
//  Created by Vitaliy on 29.05.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import Foundation

protocol NewsCoreDataInteractionProtocol {
    func saveFavNewsToDB(news: NewsCoreDataModel)
    func delNewsByTitle(newsTitle: String)
    func getFavNewsFromDB(callBack: @escaping(Result<Bool, Error>) -> Void)
}

class CoreDataNewsViewModel {
    
    let newsDataManager: CoreDataNewsManagerProtocol
    var news: [NewsCoreDataModel] = []
    
    init(dataManager: CoreDataNewsManagerProtocol = DataManager.shared) {
        self.newsDataManager = dataManager
    }
}

// MARK: - NewsCoreDataInteractionProtocol

extension CoreDataNewsViewModel: NewsCoreDataInteractionProtocol {
    
    func saveFavNewsToDB(news: NewsCoreDataModel) {
        newsDataManager.saveNewsToDB(news: news)
    }
    
    func delNewsByTitle(newsTitle: String) {
        newsDataManager.delNewsFromDbByTitle(newsTitle: newsTitle)
    }
    
    func getFavNewsFromDB(callBack: @escaping (Result<Bool, Error>) -> Void) {
        newsDataManager.readNewsFromDB { result in
            guard let newsFromDB = result else {
                callBack(.failure(NSError()))
                return
            }
            self.news = newsFromDB
            callBack(.success(true))
        }
    }
}
