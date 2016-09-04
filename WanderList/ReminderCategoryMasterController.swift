//
//  MasterViewController.swift
//  WanderList
//
//  Created by HaoBoji on 29/08/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import CoreData

protocol CategoryListDelegate {
    func refeshTable()
}

class ReminderCategoryMasterController: UITableViewController, CategoryListDelegate {

    var detailViewController: DetailViewController? = nil
    var categories: NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? DetailViewController
        }
        // Table edit button
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        // init table
        categories = DataManager.shared.getCategoryList()
        self.tableView.reloadData()
        self.navigationController!.toolbarHidden = false
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Delegates
    func refeshTable() {
        categories = DataManager.shared.getCategoryList()
        tableView.reloadData()
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == nil) {
            return
        }
        switch segue.identifier! {
        case "addCategory":
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! CategoryController
            controller.delegate = self
            break
        case "editCategory":
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! CategoryController
            controller.delegate = self
            controller.category = sender as? Category
            break
        case "showDetail":
            if let indexPath = self.tableView.indexPathForSelectedRow {
                // let object = self.fetchedResultsController.objectAtIndexPath(indexPath)
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                // controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
            break
        default:
            break
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("categoryCell", forIndexPath: indexPath)
        let category = categories[indexPath.row] as! Category
        cell.textLabel?.text = category.title
        cell.textLabel?.textColor = Config.colors[category.color!.integerValue]
        cell.showsReorderControl = true
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        // Add adite action
        let edit = UITableViewRowAction(style: .Destructive, title: "Edit") { action, index in
            self.performSegueWithIdentifier("editCategory", sender: self.categories[index.row])
        }
        edit.backgroundColor = UIColor.blueColor()
        // Add delete action
        let delete = UITableViewRowAction(style: .Destructive, title: "Delete") { action, index in
            DataManager.shared.moc?.deleteObject(self.categories[indexPath.row] as! NSManagedObject)
            DataManager.shared.saveContext()
            self.categories = DataManager.shared.getCategoryList()
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        delete.backgroundColor = UIColor.redColor()
        return [delete, edit]
    }

    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let categoryToMove = categories[sourceIndexPath.row]
        categories.removeObjectAtIndex(sourceIndexPath.row)
        categories.insertObject(categoryToMove, atIndex: destinationIndexPath.row)
        for i in 0..<categories.count {
            let category = categories[i] as! Category
            category.order = i
        }
        DataManager.shared.saveContext()
    }
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.

 func controllerDidChangeContent(controller: NSFetchedResultsController) {
 // In the simplest, most efficient, case, reload the table view.
 self.tableView.reloadData()
 }
 */

