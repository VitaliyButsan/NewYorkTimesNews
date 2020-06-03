//
//  FavoritesTableViewController.swift
//  NewYorkTimesNews
//
//  Created by Vitaliy on 02.06.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    
    let newsViewModel = CoreDataNewsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        getFavNews()
    }
    
    private func getFavNews() {
        newsViewModel.getFavNewsFromDB { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsViewModel.news.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.cellID, for: indexPath) as! FavoritesTableViewCell
        let favNews = newsViewModel.news[indexPath.row]
        cell.updateCell(news: favNews)
        
        return cell
    }
}
