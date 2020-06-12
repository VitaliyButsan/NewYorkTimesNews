//
//  MostEmailedNewsTVC.swift
//  NewYorkTimesNews
//
//  Created by Vitaliy on 29.05.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import UIKit
import SafariServices

protocol ViewModelChangeable {
    var newsViewModel: WebNewsViewModel { get set }
}

class MostEmailedNewsTableViewController: UITableViewController, ViewModelChangeable, Progressable {
    
    @IBOutlet weak var favoritesButton: UIButton!
    
    var newsViewModel = WebNewsViewModel()
    private let coreDataNewsViewModel = CoreDataNewsViewModel()
    let badgeTag = 777
    
    let newRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshNews(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = newRefreshControl
        
        showLoading(withMessage: "Loading...")
        setupCoreDataSavingObserver()
        getFavNewsForBadge()
        getWebNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        setupCellsFavoriteIcons()
    }
    
    @objc func refreshNews(_ sender: UIRefreshControl) {
        getWebNews()
        sender.endRefreshing()
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
                self.setupBarButtonBadge()
                self.setupCellsFavoriteIcons()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupCellsFavoriteIcons() {
        for index in 0..<newsViewModel.news.count {
            newsViewModel.news[index].isFavorite = false
        }
        coreDataNewsViewModel.getFavNewsFromDB { result in
            switch result {
            case .success(_):
                self.coreDataNewsViewModel.news.forEach { favNews in
                    if let equalsNewsIndex = self.newsViewModel.news.firstIndex(where: {$0 == favNews}) {
                        self.newsViewModel.news[equalsNewsIndex].makeFavorite(true)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupBarButtonBadge() {
        let favNewsCount = coreDataNewsViewModel.news.count
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
        newsViewModel.getNewsFromWeb(newsType: .getMostEmailedNews) { result in
            switch result {
            case .success(_):
                self.hideLoading()
                self.setupCellsFavoriteIcons()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                self.hideLoaderWithError(withMessage: "Error loading!")
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

extension MostEmailedNewsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsViewModel.news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MostEmailedNewsTableViewCell.cellID, for: indexPath) as! MostEmailedNewsTableViewCell
        let news = newsViewModel.news[indexPath.row]
        cell.updateCell(news: news)
        cell.delegate = self
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

extension MostEmailedNewsTableViewController: IsFavoriteMakeble {
    
    func makeFavorite(cell: UITableViewCell) {
        if let mostEmailedCell = cell as? MostEmailedNewsTableViewCell {
            if let indexPath = tableView.indexPath(for: mostEmailedCell) {
                newsViewModel.news[indexPath.row].makeFavorite(mostEmailedCell.isFavoriteButton.isSelected)
            }
        }
    }
}
