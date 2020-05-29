//
//  NewsViewModel.swift
//  NewYorkTimesNews
//
//  Created by Vitaliy on 26.05.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import Foundation

protocol NewsWebInteractionProtocol {
    func getNewsFromWeb(newsType: Router, callBack: @escaping(Result<Bool, Error>) -> Void)
}

class WebNewsViewModel {
    
    let newsDataManager: WebNewsDataManagerProtocol
    var news: [NewsInfo] = []
    
    init(dataManager: WebNewsDataManagerProtocol = DataManager.shared) {
        self.newsDataManager = dataManager
    }
}

// MARK: - NewsInteractionProtocol

extension WebNewsViewModel: NewsWebInteractionProtocol {
    
    func getNewsFromWeb(newsType: Router, callBack: @escaping(Result<Bool, Error>) -> Void) {
        newsDataManager.fetchWebNews(newsType: newsType) { result in
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
