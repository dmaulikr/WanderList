//
//  RadiusPickController.swift
//  WanderList
//
//  Created by HaoBoji on 3/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit

protocol RadiusPickDelegate {
    func didPickRadius(controller: RadiusPickController)
}

class RadiusPickController: UITableViewController {

    var delegate: RadiusPickDelegate?
    var currentRadiusIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Config.radiusText.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("radiusCell", forIndexPath: indexPath)
        // Configure the cell...
        cell.textLabel?.text = Config.radiusText[indexPath.row]
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        currentRadiusIndex = indexPath.row
        delegate?.didPickRadius(self)
    }
}
