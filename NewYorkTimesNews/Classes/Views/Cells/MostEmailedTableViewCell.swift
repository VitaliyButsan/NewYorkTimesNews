//
//  MostEmailedTableViewCell.swift
//  NewYorkTimesNews
//
//  Created by Vitaliy on 29.05.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import UIKit
import SDWebImage

protocol IsFavoriteTappable {
    func makeFavorite(cell: UITableViewCell)
}

class MostEmailedNewsTableViewCell: UITableViewCell {
    
    static let cellID = "MostEmailedNewsCell"
    var delegate: IsFavoriteTappable?
    
    @IBOutlet weak var titleNewsLabel: UILabel!
    @IBOutlet weak var iconNewsImageView: UIImageView!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var isFavoriteButton: UIButton!
    
    private let coreDataManager = CoreDataManager()
    private var currentNews = NewsCoreDataModel.placeholder

    func updateCell(news: NewsCoreDataModel) {
        titleNewsLabel.text = news.title
        isFavoriteButton.isSelected = news.isFavorite
        iconNewsImageView.sd_setImage(with: URL(string: news.iconLink ?? ""), placeholderImage: UIImage(named: "news_icon_placeholder"))
        publishedDateLabel.text = news.publishedDate
        
        currentNews = news
        guard let iconData = iconNewsImageView.image?.pngData() else { return }
        currentNews.iconData = iconData
    }
    
    
    @IBAction func makeFavoriteButton(_ sender: UIButton) {
        
        if isFavoriteButton.isSelected {
            isFavoriteButton.isSelected = false
            coreDataManager.delNewsByTitle(title: titleNewsLabel.text!)
        } else {
            isFavoriteButton.isSelected = true
            coreDataManager.writeNews(news: currentNews)
        }
        
        delegate?.makeFavorite(cell: self)
    }
}
