//
//  MostEmailedNewsTVC.swift
//  NewYorkTimesNews
//
//  Created by Vitaliy on 29.05.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import UIKit
import SafariServices

class MostEmailedNewsTableViewController: UITableViewController {
    
    private let newsViewModel = WebNewsViewModel()
    private let coreDataNewsViewModel = CoreDataNewsViewModel()
    private let badgeTag = 777
    
    @IBOutlet weak var favoritesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 250
        setupCoreDataSavingObserver()
        getFavNewsForBadge()
        getWebNews()
    }
    
    private func setupCoreDataSavingObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receiveFavNews(_:)),
                                               name: NSNotification.Name.NSManagedObjectContextDidSave,
                                               object: nil)
    }
    
    @objc func receiveFavNews(_ notification: NSNotification) {
        getFavNewsForBadge()
    }
    
    private func getFavNewsForBadge() {
        coreDataNewsViewModel.getFavNewsFromDB { result in
            switch result {
            case .success(_):
                let newsCount = self.coreDataNewsViewModel.news.count
                DispatchQueue.main.async {
                    newsCount == 0 ? self.removeBadge() : self.showBadge(withCount: newsCount)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func showBadge(withCount count: Int) {
        self.removeBadge()
        let badgeSize: CGFloat = 20
        let badge = badgeLabel(withCount: count)
        favoritesButton.addSubview(badge)

        NSLayoutConstraint.activate([
            badge.leftAnchor.constraint(equalTo: favoritesButton.leftAnchor, constant: 20),
            badge.topAnchor.constraint(equalTo: favoritesButton.topAnchor, constant: -5),
            badge.widthAnchor.constraint(equalToConstant: badgeSize),
            badge.heightAnchor.constraint(equalToConstant: badgeSize)
        ])
    }
    
    private func removeBadge() {
        if let badge = favoritesButton.viewWithTag(badgeTag) {
            badge.removeFromSuperview()
        }
    }
    
    private func badgeLabel(withCount count: Int, badgeSize: CGFloat = 20) -> UILabel {
        let badgeCount = UILabel(frame: CGRect(x: 0, y: 0, width: badgeSize, height: badgeSize))
        badgeCount.translatesAutoresizingMaskIntoConstraints = false
        badgeCount.tag = badgeTag
        badgeCount.layer.cornerRadius = badgeCount.bounds.size.height / 2
        badgeCount.textAlignment = .center
        badgeCount.layer.masksToBounds = true
        badgeCount.textColor = .white
        badgeCount.font = badgeCount.font.withSize(12)
        badgeCount.backgroundColor = .systemRed
        badgeCount.text = String(count)
        return badgeCount
    }
    
    private func getWebNews() {
        newsViewModel.getNewsFromWeb(newsType: Router.getMostEmailedNews) { result in
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

extension MostEmailedNewsTableViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
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
