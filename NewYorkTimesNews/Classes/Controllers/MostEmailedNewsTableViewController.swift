//
//  MostEmailedNewsTVC.swift
//  NewYorkTimesNews
//
//  Created by Vitaliy on 29.05.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import UIKit

class MostEmailedNewsTableViewController: UITableViewController {
    
    private let newsViewModel = WebNewsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getNews()
    }
    
    private func getNews() {
        newsViewModel.getNewsFromWeb(newsType: .getMostEmailedNews) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsViewModel.news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MostEmailedNewsTableViewCell.cellID, for: indexPath) as! MostEmailedNewsTableViewCell
        let news = newsViewModel.news[indexPath.row]
        cell.updateCell(news: news)
        return cell
    }

}
