//
//  NewsViewModel.swift
//  NewYorkTimesNews
//
//  Created by Vitaliy on 26.05.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import UIKit

protocol NewsWebInteractionProtocol {
    func getNewsFromWeb(newsType: Router, callBack: @escaping(Result<Bool, Error>) -> Void)
}

class WebNewsViewModel {
    
    let newsDataManager: WebNewsDataManagerProtocol
    var news: [NewsCoreDataModel] = []
    
    init(dataManager: WebNewsDataManagerProtocol = DataManager.shared) {
        self.newsDataManager = dataManager
    }
    
    private func convertToNewsCoreDataModel(webNewsModels: [WebNewsInfo]) -> [NewsCoreDataModel] {
        var result: [NewsCoreDataModel] = []
        
        for webNewsModel in webNewsModels {
            var iconLink = ""
            var iconData = Data()
            
            if let urlString = webNewsModel.media.first?.metaData.last?.iconURL, let url = URL(string: urlString) {
                iconLink = urlString
                
                do {
                    let data = try Data(contentsOf: url)
                    iconData = data
                } catch {
                    print(error)
                }
            }
            
            let newCoreDataModel = NewsCoreDataModel(title: webNewsModel.title,
                                                     iconData: iconData,
                                                     iconLink: iconLink,
                                                     newsLink: webNewsModel.url,
                                                     publishedDate: webNewsModel.publishedDate,
                                                     isFavorite: false)
            result.append(newCoreDataModel)
        }
        
        return result
    }
}

// MARK: - NewsInteractionProtocol

extension WebNewsViewModel: NewsWebInteractionProtocol {
    
    func getNewsFromWeb(newsType: Router, callBack: @escaping(Result<Bool, Error>) -> Void) {
        newsDataManager.fetchWebNews(newsType: newsType) { result in
            switch result {
            case .success(let dataWrapper):
                self.news = self.convertToNewsCoreDataModel(webNewsModels: dataWrapper.results)
                callBack(.success(true))
            case .failure(let error):
                callBack(.failure(error))
            }
        }
    }
}
