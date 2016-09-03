//
//  ReminderCategoryAddEditController.swift
//  WanderList
//
//  Created by HaoBoji on 2/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
class CategoryController: UITableViewController, ColorPickDelegate, RadiusPickDelegate {

    @IBOutlet var titleInput: UITextField!
    @IBOutlet var colorCell: UITableViewCell!
    @IBOutlet var radiusCell: UITableViewCell!

    // For category settings
    var currentColorIndex: Int = 0
    var currentRadiusIndex: Int = 0

    override func viewDidLoad() {
        // init color
        super.viewDidLoad()
        colorCell.imageView?.image = colorCell.imageView?.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        colorCell.imageView?.tintColor = Config.colors[currentColorIndex]
        colorCell.textLabel?.text = Config.colorsText[currentColorIndex]
        // init radius
        radiusCell.detailTextLabel?.text = Config.radiusText[currentRadiusIndex]
    }

    override func viewDidAppear(animated: Bool) {
        // titleInput.becomeFirstResponder()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    func didPickColor(controller: ColorPickController) {
        // Load color config
        currentColorIndex = controller.currentColorIndex!
        colorCell.imageView?.tintColor = Config.colors[currentColorIndex]
        colorCell.textLabel?.text = Config.colorsText[currentColorIndex]
        self.navigationController?.popViewControllerAnimated(true)
    }

    func didPickRadius(controller: RadiusPickController) {
        // Load radius config
        radiusCell.detailTextLabel?.text = Config.radiusText[controller.currentRadiusIndex!]
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func save(sender: UIBarButtonItem) {

        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func insertNewObject(sender: AnyObject) {
//        let context = self.fetchedResultsController.managedObjectContext
//        let entity = self.fetchedResultsController.fetchRequest.entity!
//        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context)
//
//        // If appropriate, configure the new managed object.
//        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
//        newManagedObject.setValue(NSDate(), forKey: "timeStamp")
//
//        // Save the context.
//        do {
//            try context.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            // print("Unresolved error \(error), \(error.userInfo)")
//            abort()
//        }
    }

    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 3
        default:
            return 0
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == nil) {
            return
        }
        switch segue.identifier! {
        case "colorSegue":
            let controller = segue.destinationViewController as! ColorPickController
            controller.currentColorIndex = self.currentColorIndex
            controller.delegate = self
            break
        case "radiusSegue":
            let controller = segue.destinationViewController as! RadiusPickController
            controller.currentRadiusIndex = self.currentRadiusIndex
            controller.delegate = self
            break
        default:
            break
        }
    }

    /*
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

     // Configure the cell...

     return cell
     }
     */

    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */

    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */

    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

     }
     */

    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */

}
