//
//  DataModel.swift
//  NewYorkTimesNews
//
//  Created by Vitaliy on 26.05.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import Foundation
import Alamofire

protocol NewsDataManagerProtocol {
    func fetchNews(newsType: Router, callBack: @escaping (Result<NewsDataWrapper, Error>) -> Void)
}

class DataManager {
    
    static let shared = DataManager()
    
    private init() { }
}

// MARK: - NewsInteracionProtocol

extension DataManager: NewsDataManagerProtocol {
    
    func fetchNews(newsType: Router, callBack: @escaping (Result<NewsDataWrapper, Error>) -> Void) {
        AF.request(newsType).response { response in
            guard let responseData = response.data else {
                callBack(.failure(NSError()))
                return
            }
            let result = Result {
                try JSONDecoder().decode(NewsDataWrapper.self, from: responseData)
            }
            callBack(result)
        }
    }
}
