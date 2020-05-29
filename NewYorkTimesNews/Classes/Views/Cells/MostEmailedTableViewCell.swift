//
//  MostEmailedTableViewCell.swift
//  NewYorkTimesNews
//
//  Created by Vitaliy on 29.05.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import UIKit

class MostEmailedNewsTableViewCell: UITableViewCell {
    
    static let cellID = "MostEmailedNewsCell"
    
    func updateCell(news: NewsInfo) {
        self.textLabel?.text = news.title
    }
}
