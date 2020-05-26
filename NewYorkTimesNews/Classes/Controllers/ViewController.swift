//
//  ViewController.swift
//  NewYorkTimesNews
//
//  Created by Vitaliy on 26.05.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        DataManager.shared.getNews(newsType: .getMostViewedNews) { result in
            result?.results.forEach { print($0.url) }
        }
    }
}

