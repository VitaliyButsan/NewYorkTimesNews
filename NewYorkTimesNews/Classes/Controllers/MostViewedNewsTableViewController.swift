//
//  MostViewedNewsTVC.swift
//  NewYorkTimesNews
//
//  Created by Vitaliy on 29.05.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import UIKit
import SafariServices

class MostViewedNewsTableViewController: UITableViewController, ViewModelChangeable {
    
    @IBOutlet weak var favoritesButton: UIButton!
    
    var newsViewModel = WebNewsViewModel()
    private let coreDataNewsViewModel = CoreDataNewsViewModel()
    private let badgeTag = 777
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 250
        setupCoreDataSavingObserver()
        getFavNewsForBadge()
        getWebNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupCoreDataSavingObserver() {
        let name = NSNotification.Name.NSManagedObjectContextDidSave
        NotificationCenter.default.addObserver(self, selector: #selector(receiveFavNews(_:)), name: name, object: nil)
    }
    
    @objc func receiveFavNews(_ notification: NSNotification) {
        getFavNewsForBadge()
    }
    
    private func getFavNewsForBadge() {
        coreDataNewsViewModel.getFavNewsFromDB { result in
            switch result {
            case .success(_):
                let favNewsCount = self.coreDataNewsViewModel.news.count
                DispatchQueue.main.async {
                    if favNewsCount > 0 {
                        if let badge = self.favoritesButton.viewWithTag(self.badgeTag) as? UILabel {
                            badge.text = String(favNewsCount)
                        } else {
                            self.showBadge(withCount: favNewsCount)
                        }
                    } else {
                        self.removeBadge()
                    }
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
        let badgeSize: CGFloat = 20
        let badge = badgeLabel(withCount: count, badgeSize: badgeSize)
        favoritesButton.addSubview(badge)

        NSLayoutConstraint.activate([
            badge.leftAnchor.constraint(equalTo: favoritesButton.leftAnchor, constant: badgeSize),
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
    
    private func badgeLabel(withCount count: Int, badgeSize: CGFloat) -> UILabel {
        let badgeCount = UILabel(frame: CGRect(x: 0, y: 0, width: badgeSize, height: badgeSize))
        badgeCount.translatesAutoresizingMaskIntoConstraints = false
        badgeCount.tag = badgeTag
        badgeCount.layer.cornerRadius = badgeCount.bounds.size.height / 2
        badgeCount.textAlignment = .center
        badgeCount.layer.masksToBounds = true
        badgeCount.textColor = .white
        badgeCount.font = badgeCount.font.withSize(12)
        badgeCount.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        badgeCount.text = String(count)
        return badgeCount
    }
    
    private func getWebNews() {
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
    
    @IBAction func favoritesButton(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToFavorites", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let favoritesTVC = segue.destination as? FavoritesTableViewController {
            favoritesTVC.cameFromTVC = self
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
        let news = newsViewModel.news[indexPath.row]
        cell.updateCell(news: news)
        cell.delegate = self
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

