//
//  ViewController.swift
//  NewYorkTimesNews
//
//  Created by Vitaliy on 26.05.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let newsViewModel = NewsViewModel()
    let coreDataManager = CoreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        newsViewModel.getNews { result in
            switch result {
            case .success(_):
                let newNews = NewsCoreDataModel(title: "hello, world!", icon: Data(), link: "http//??", isFavorite: true)
                self.coreDataManager.write(news: newNews)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func read(_ sender: UIButton) {
        coreDataManager.readNews { orders in
            guard let orders = orders else { return }
            orders.forEach { print($0.title) }
         }
    }
    
}

