//
//  MostEmailedTableViewCell.swift
//  NewYorkTimesNews
//
//  Created by Vitaliy on 29.05.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import UIKit
import SDWebImage

protocol IsFavoriteMakeble {
    func makeFavorite(cell: UITableViewCell)
}

class MostEmailedNewsTableViewCell: UITableViewCell {
    
    static let cellID = "MostEmailedNewsCell"
    
    @IBOutlet weak var titleNewsLabel: UILabel!
    @IBOutlet weak var iconNewsImageView: UIImageView!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var isFavoriteButton: UIButton!
    
    private let coreDataNewsModel = CoreDataNewsViewModel()
    private var iconLink: String?
    private var newsLink = ""
    var delegate: IsFavoriteMakeble?
    
    func updateCell(news: NewsCoreDataModel) {
        iconLink = news.iconLink
        newsLink = news.newsLink
        titleNewsLabel.text = news.title
        isFavoriteButton.isSelected = news.isFavorite
        publishedDateLabel.text = news.publishedDate
        iconNewsImageView.sd_setImage(with: URL(string: news.iconLink ?? ""), placeholderImage: UIImage(named: "news_icon_placeholder"))
    }
    
    @IBAction func makeFavoriteButton(_ sender: UIButton) {
        
        if isFavoriteButton.isSelected {
            isFavoriteButton.isSelected = false
            coreDataNewsModel.delNewsByTitle(newsTitle: titleNewsLabel.text!)
        } else {
            isFavoriteButton.isSelected = true
            let currentNews = getCurrentNews()
            coreDataNewsModel.saveFavNewsToDB(news: currentNews)
        }
        
        delegate?.makeFavorite(cell: self)
    }
    
    private func getCurrentNews() -> NewsCoreDataModel {
        guard let title = titleNewsLabel.text  else { return NewsCoreDataModel.placeholder }
        guard let iconData = iconNewsImageView.image?.pngData() else { return NewsCoreDataModel.placeholder }
        guard let iconLink = iconLink else { return NewsCoreDataModel.placeholder }
        guard let publishedData = publishedDateLabel.text else { return NewsCoreDataModel.placeholder }
        
        let currentNews = NewsCoreDataModel(title: title,
                                            iconData: iconData,
                                            iconLink: iconLink,
                                            newsLink: newsLink,
                                            publishedDate: publishedData,
                                            isFavorite: isFavoriteButton.isSelected)
        return currentNews
    }
}
