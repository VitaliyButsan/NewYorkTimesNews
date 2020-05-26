//
//  File.swift
//  NewYorkTimesNews
//
//  Created by Vitaliy on 26.05.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    case getMostEmailedNews
    case getMostSharedNews
    case getMostViewedNews
    
    static let apiKey = "RHxMRWZeNPURR652gXPTljPED9YWUiGy"
    
    var baseURL: URL {
        return URL(string: "https://api.nytimes.com/svc/mostpopular/v2")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .getMostEmailedNews, .getMostSharedNews, .getMostViewedNews:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getMostEmailedNews:
            return "/emailed/30.json"
        case .getMostSharedNews:
            return "/shared/30.json"
        case .getMostViewedNews:
            return "/viewed/30.json"
        }
    }
    
    var params: [String:String] {
        ["api-key" : Router.apiKey]
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest = try URLEncodedFormParameterEncoder().encode(params, into: urlRequest)
        return urlRequest
    }
}
