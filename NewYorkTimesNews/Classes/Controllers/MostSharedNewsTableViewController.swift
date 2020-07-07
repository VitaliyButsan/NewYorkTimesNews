//
//  MostSharedNewsTVC.swift
//  NewYorkTimesNews
//
//  Created by Vitaliy on 29.05.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import Foundation

class MostSharedNewsTableViewController: BaseTableViewController<MostSharedNewsTableViewCell> {

    override var routerState: Router {
        return .getMostSharedNews
    }
}
