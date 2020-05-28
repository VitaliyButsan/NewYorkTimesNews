//
//  NewsViewModel.swift
//  NewYorkTimesNews
//
//  Created by Vitaliy on 26.05.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import Foundation

protocol NewsInteractionProtocol {
    func getNews(callBack: @escaping(Result<Bool, Error>) -> Void)
}

class NewsViewModel {
    
    let newsDataManager: NewsDataManagerProtocol
    var news: [NewsInfo] = []
    
    init(dataManager: NewsDataManagerProtocol = DataManager.shared) {
        self.newsDataManager = dataManager
    }
}

// MARK: - NewsInteractionProtocol

extension NewsViewModel: NewsInteractionProtocol {
    
    func getNews(callBack: @escaping(Result<Bool, Error>) -> Void) {
        newsDataManager.fetchNews(newsType: .getMostEmailedNews) { result in
            switch result {
            case .success(let dataWrapper):
                self.news = dataWrapper.results
                callBack(.success(true))
            case .failure(let error):
                callBack(.failure(error))
            }
        }
    }
}
