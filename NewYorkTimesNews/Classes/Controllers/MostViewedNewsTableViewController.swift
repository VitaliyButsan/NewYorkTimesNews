//
//  MostViewedNewsTVC.swift
//  NewYorkTimesNews
//
//  Created by Vitaliy on 29.05.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import UIKit
import SafariServices

class MostViewedNewsTableViewController: UITableViewController {
    
    private let newsViewModel = WebNewsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 250
        getNews()
    }
    
    private func getNews() {
        newsViewModel.getNewsFromWeb(newsType: .getMostViewedNews) { result in
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

extension MostViewedNewsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsViewModel.news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MostViewedNewsTableViewCell.cellID, for: indexPath) as! MostViewedNewsTableViewCell
        cell.delegate = self
        let news = newsViewModel.news[indexPath.row]
        cell.updateCell(news: news)
        return cell
    }
}

// MARK - Table view delegate

extension MostViewedNewsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsLink = newsViewModel.news[indexPath.row].newsLink
        showLinkWithSafari(link: newsLink)
    }
    
    private func showLinkWithSafari(link: String) {
        let safariVC = SFSafariViewController(url: URL(string: link)!)
        self.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }
}

// MARK: - SFSafariViewControllerDelegate

extension MostViewedNewsTableViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - IsFavoriteTappable protocole

extension MostViewedNewsTableViewController: IsFavoriteTappable {
    
    func makeFavorite(cell: UITableViewCell) {
        if let mostEmailedCell = cell as? MostViewedNewsTableViewCell {
            if let indexPath = tableView.indexPath(for: mostEmailedCell) {
                newsViewModel.news[indexPath.row].makeFavorite(mostEmailedCell.isFavoriteButton.isSelected)
            }
        }
    }
}

