//
//  MostEmailedNewsTableViewController.swift
//  NewYorkTimesNews
//
//  Created by Vitaliy on 06.07.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import UIKit

class MostEmailedNewsTableViewController: BaseTableViewController<MostEmailedNewsTableViewCell> {
    
    override var routerState: Router {
        return .getMostEmailedNews
    }
    
    @IBOutlet weak var faveritesBarButton: UIButton!
}
