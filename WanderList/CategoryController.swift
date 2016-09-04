//
//  ReminderCategoryAddEditController.swift
//  WanderList
//
//  Created by HaoBoji on 2/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class CategoryController: UITableViewController, ColorPickDelegate, RadiusPickDelegate, LocationPickDelegate {

    @IBOutlet var titleInput: UITextField!
    @IBOutlet var notificationIsEnabled: UISwitch!
    @IBOutlet var colorCell: UITableViewCell!
    @IBOutlet var radiusCell: UITableViewCell!
    @IBOutlet var locationCell: UITableViewCell!

    // For category settings
    var currentColorIndex: Int = 0
    var currentRadiusIndex: Int = 0
    var currentPickedLocation: MKPointAnnotation?

    override func viewDidLoad() {
        // init color
        super.viewDidLoad()
        self.title = "New"
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

    // save picked color
    func didPickColor(controller: ColorPickController) {
        // Load color config
        currentColorIndex = controller.currentColorIndex!
        colorCell.imageView?.tintColor = Config.colors[currentColorIndex]
        colorCell.textLabel?.text = Config.colorsText[currentColorIndex]
        self.navigationController?.popViewControllerAnimated(true)
    }

    // save picked radius
    func didPickRadius(controller: RadiusPickController) {
        // Load radius config
        radiusCell.detailTextLabel?.text = Config.radiusText[controller.currentRadiusIndex!]
        self.navigationController?.popViewControllerAnimated(true)
    }

    // save picked location
    func didPickLocation(controller: MapPickController) {
        self.currentPickedLocation = controller.currentPickedLocation
        locationCell.detailTextLabel?.text = currentPickedLocation!.subtitle
        self.navigationController?.popViewControllerAnimated(true)
    }

    // save category and close modal
    @IBAction func save(sender: UIBarButtonItem) {
        // Create a reminder
        let newCategory: Category = (NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: DataManager.shared.moc!) as? Category)!
        newCategory.title = titleInput.text
        newCategory.color = currentColorIndex
        newCategory.order = 99999
        newCategory.notificationIsEnabled = notificationIsEnabled.on
        newCategory.address = currentPickedLocation?.subtitle
        newCategory.latitude = currentPickedLocation?.coordinate.latitude
        newCategory.longitude = currentPickedLocation?.coordinate.longitude
        newCategory.notificationRadius = Config.radius[currentRadiusIndex]
        DataManager.shared.saveContext()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // close modal
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
        case "mapSegue":
            let controller = segue.destinationViewController as! MapPickController
            controller.currentPickedLocation = self.currentPickedLocation
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
