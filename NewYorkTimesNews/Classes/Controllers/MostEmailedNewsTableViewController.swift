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
    private let coreDataNewsViewModel = CoreDataNewsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 250
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
}

// MARK: - Table view data source

extension MostEmailedNewsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsViewModel.news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MostEmailedNewsTableViewCell.cellID, for: indexPath) as! MostEmailedNewsTableViewCell
        cell.delegate = self
        let news = newsViewModel.news[indexPath.row]
        cell.updateCell(news: news)
        return cell
    }
}

// MARK - Table view delegate

extension MostEmailedNewsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coreDataNewsViewModel.getFavNewsFromDB { result in
            switch result {
            case .success(_):
                if self.coreDataNewsViewModel.news.count == 0 {
                    print("db is Empty!")
                }
                self.coreDataNewsViewModel.news.forEach { print($0) }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - IsFavoriteTappable protocole

extension MostEmailedNewsTableViewController: IsFavoriteTappable {
    
    func makeFavorite(cell: UITableViewCell) {
        if let mostEmailedCell = cell as? MostEmailedNewsTableViewCell {
            if let indexPath = tableView.indexPath(for: mostEmailedCell) {
                newsViewModel.news[indexPath.row].makeFavorite(mostEmailedCell.isFavoriteButton.isSelected)
            }
        }
    }
}
