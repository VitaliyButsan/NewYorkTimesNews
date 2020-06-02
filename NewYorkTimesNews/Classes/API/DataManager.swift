//
//  DataModel.swift
//  NewYorkTimesNews
//
//  Created by Vitaliy on 26.05.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import Foundation
import Alamofire

protocol WebNewsDataManagerProtocol {
    func fetchWebNews(newsType: Router, callBack: @escaping (Result<NewsDataWrapper, Error>) -> Void)
}

protocol CoreDataNewsManagerProtocol {
    func saveNewsToDB(news: NewsCoreDataModel)
    func readNewsFromDB(callBack: @escaping([NewsCoreDataModel]?) -> Void)
}

class DataManager {
    
    static let shared = DataManager()
    private let coreDataManager = CoreDataManager()
    
    private init() { }
}

// MARK: - NewsInteracionProtocol

extension DataManager: WebNewsDataManagerProtocol {
    
    func fetchWebNews(newsType: Router, callBack: @escaping (Result<NewsDataWrapper, Error>) -> Void) {
        AF.request(newsType).response { response in
            guard let responseData = response.data else {
                if let error = response.error {
                    callBack(.failure(error))
                }
                return
            }
            let result = Result {
                try JSONDecoder().decode(NewsDataWrapper.self, from: responseData)
            }
            callBack(result)
        }
    }
}

// MARK: - CoreDataManagerProtocol

extension DataManager: CoreDataNewsManagerProtocol {
    
    func saveNewsToDB(news: NewsCoreDataModel) {
        coreDataManager.writeNews(news: news)
    }
    
    func readNewsFromDB(callBack: @escaping([NewsCoreDataModel]?) -> Void) {
        coreDataManager.readNews { result in
            guard let news = result else {
                callBack(nil)
                return
            }
            callBack(news)
        }
    }
}

