//
//  ReminderCategoryAddEditController.swift
//  WanderList
//
//  Created by HaoBoji on 2/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//
//  Display, add, edit category
//

import UIKit
import MapKit
import CoreData

protocol CategoryListDelegate {
    func refresh()
}

class CategoryController: UITableViewController, ColorPickDelegate, RadiusPickDelegate, LocationPickDelegate {

    @IBOutlet var titleInput: UITextField!
    @IBOutlet var arrivingSwitch: UISwitch!
    @IBOutlet var leavingSwitch: UISwitch!
    @IBOutlet var colorCell: UITableViewCell!
    @IBOutlet var radiusCell: UITableViewCell!
    @IBOutlet var locationCell: UITableViewCell!

    // For current category
    var category: Category?

    // For category settings
    var currentColorIndex: Int = 0
    var currentRadiusIndex: Int = 0
    var currentPickedLocation: MKPointAnnotation?
    // For communication with category table view
    var delegate: CategoryListDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Check new or edit
        if (category == nil) {
            self.title = "New"
        } else {
            self.title = "Edit"
            currentColorIndex = category!.color!.integerValue
            currentRadiusIndex = category!.notificationRadius!.integerValue
            arrivingSwitch.on = (category!.notificationArriving! == 1)
            leavingSwitch.on = (category!.notificationLeaving! == 1)
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = category!.latitude!.doubleValue
            annotation.coordinate.longitude = category!.longitude!.doubleValue
            annotation.subtitle = category!.address
            currentPickedLocation = annotation
            locationCell.detailTextLabel?.text = currentPickedLocation?.subtitle
            titleInput.text = category?.title
        }
        // init color
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
        currentRadiusIndex = controller.currentRadiusIndex!
        radiusCell.detailTextLabel?.text = Config.radiusText[controller.currentRadiusIndex!]
        self.navigationController?.popViewControllerAnimated(true)
    }

    // save picked location
    func didPickLocation(controller: MapPickController) {
        currentPickedLocation = controller.currentPickedLocation
        locationCell.detailTextLabel?.text = currentPickedLocation!.subtitle
        self.navigationController?.popViewControllerAnimated(true)
    }

    // save category and close modal
    @IBAction func save(sender: UIBarButtonItem) {
        // Empty title
        if (titleInput.text == nil || titleInput.text == "") {
            let alert = UIAlertController(title: "Oops", message: "Category title is required", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        // No location while switch on
        if (currentPickedLocation == nil) {
            let alert = UIAlertController(title: "Oops", message: "Location is required", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        // Create a category if needed
        if (category == nil) {
            category = (NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: DataManager.shared.moc!) as? Category)!
        }
        category!.title = titleInput.text
        category!.color = currentColorIndex
        category!.notificationArriving = arrivingSwitch.on
        category!.notificationLeaving = leavingSwitch.on
        category!.address = currentPickedLocation?.subtitle
        category!.latitude = currentPickedLocation?.coordinate.latitude
        category!.longitude = currentPickedLocation?.coordinate.longitude
        category!.notificationRadius = currentRadiusIndex
        DataManager.shared.saveContext()
        delegate?.refresh()
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
            return 4
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Dismiss keyboard
        view.endEditing(true)
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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
}
