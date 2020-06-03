//
//  FavoritesTableViewCell.swift
//  NewYorkTimesNews
//
//  Created by Vitaliy on 02.06.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {

    static let cellID = "FavoritesCell"
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func updateCell(news: NewsCoreDataModel) {
        iconView.image = UIImage(data: news.iconData)
        titleLabel.text = news.title
    }
}
