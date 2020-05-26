//
//  DataModel.swift
//  NewYorkTimesNews
//
//  Created by Vitaliy on 26.05.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import Foundation
import Alamofire

protocol NewsInteractionProtocol {
    func getNews(newsType: Router, callBack: @escaping (NewsDataWrapper?) -> Void)
}

class DataManager {
    
    static let shared = DataManager()
    
    private init() { }
}

// MARK: - NewsInteracionProtocol

extension DataManager: NewsInteractionProtocol {
    
    func getNews(newsType: Router, callBack: @escaping (NewsDataWrapper?) -> Void) {
        AF.request(newsType).response { response in
            guard let responseData = response.data else { return }
            do {
                let jsonResult = try JSONDecoder().decode(NewsDataWrapper.self, from: responseData)
                callBack(jsonResult)
            } catch {
                print(error)
            }
        }
    }
}
