//
//  ColorSelectController.swift
//  WanderList
//
//  Created by HaoBoji on 3/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//
//  Pick a color
//

import UIKit

protocol ColorPickDelegate {
    func didPickColor(controller: ColorPickController)
}

class ColorPickController: UITableViewController {

    var delegate: ColorPickDelegate?
    var currentColorIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pick a Color"
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Config.colors.count
    }

    // Cell view
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("colorCell", forIndexPath: indexPath)
        // Configure the cell...
        cell.imageView?.image = cell.imageView?.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell.imageView?.tintColor = Config.colors[indexPath.row]
        cell.textLabel?.text = Config.colorsText[indexPath.row]
        if (indexPath.row == currentColorIndex!) {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        return cell
    }

    // also display line under image
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
    }

    // did select row
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        currentColorIndex = indexPath.row
        delegate?.didPickColor(self)
    }
}
