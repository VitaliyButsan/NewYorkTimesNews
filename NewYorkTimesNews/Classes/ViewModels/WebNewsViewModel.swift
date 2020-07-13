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
        var results: [NewsCoreDataModel] = []
        
        for webNewsModel in webNewsModels {
            var iconLink = ""
            var iconData = Data()
            let publishedDate = String(webNewsModel.publishedDate.components(separatedBy: "-").reversed().joined(separator: "-"))
            
            if let urlString = webNewsModel.media.first?.metaData.last?.iconURL, let url = URL(string: urlString) {
                iconLink = urlString
                do {
                    let data = try Data(contentsOf: url)
                    iconData = data
                } catch {
                    print(error)
                }
            }
            
            let newCoreDataNewsModel = NewsCoreDataModel(title: webNewsModel.title,
                                                         iconData: iconData,
                                                         iconLink: iconLink,
                                                         newsLink: webNewsModel.url,
                                                         publishedDate: publishedDate,
                                                         isFavorite: false)
            results.append(newCoreDataNewsModel)
        }
        return results
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
