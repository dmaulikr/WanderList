//
//  ReminderCategoryMapMasterController.swift
//  WanderList
//
//  Created by HaoBoji on 6/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//
//  Mapview for category list
//

import UIKit
import MapKit

class ReminderCategoryMapMasterController: UIViewController, MKMapViewDelegate, CategoryListDelegate {

    // Left nav button
    @IBOutlet var editMode: UIBarButtonItem!
    @IBAction func editAction(sender: UIBarButtonItem) {
        if (sender.title == "Edit") {
            sender.title = "Done"
            self.title = "Edit Categories"
        } else {
            sender.title = "Edit"
            self.title = "Categories"
        }
    }
    // Detail view controller
    var detailViewController: ReminderCategoryDetailController? = nil
    var categories: NSMutableArray?
    var showInModal = false

    @IBOutlet var mapView: MKMapView! {
        didSet {
            // Init map
            mapView.delegate = self
            mapView.showsUserLocation = true
            // Set map camera
            var lastLocation = LocationManager.shared.getLastLocation()
            // Default location - Melbourne
            if (lastLocation == nil) {
                lastLocation = CLLocation(latitude: -37.768356, longitude: 144.9663673)
            }
            let camera = MKMapCamera(lookingAtCenterCoordinate: lastLocation!.coordinate, fromEyeCoordinate: lastLocation!.coordinate, eyeAltitude: 50000)
            mapView.setCamera(camera, animated: false)
            // Get detail view controller
            if let split = self.splitViewController {
                let controllers = split.viewControllers
                self.detailViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? ReminderCategoryDetailController
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController!.toolbarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false);
        self.title = "Categories"

        // Add tracking button
        let trackingButton = MKUserTrackingBarButtonItem(mapView: mapView)
        trackingButton.customView?.tintColor = self.view.tintColor
        let emptySpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: .None, action: nil)
        let list = UIBarButtonItem(title: "List", style: .Plain, target: self, action: #selector(navBack(_:)))
        list.tintColor = self.view.tintColor
        self.toolbarItems! = [list, emptySpace, trackingButton]
    }

    override func viewWillAppear(animated: Bool) {
        refresh()
    }

    // Refresh annotations
    func refresh() {
        mapView.removeAnnotations(mapView.annotations)
        categories = DataManager.shared.getCategoryList()
        for item in categories! {
            let category = item as! Category
            let annotation = CategoryAnnotation()
            annotation.category = category
            mapView.addAnnotation(annotation)
            if (category.notificationArriving == 1 || category.notificationLeaving == 1) {
                let circle = CategoryCircle(category: category)
                mapView.addOverlay(circle)
            }
        }
    }

    // Back to list view
    func navBack(controller: ReminderCategoryMapMasterController) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    // MARK: Map Delegate

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is CategoryAnnotation) {
            // Configure annotationView
            let reuseId = "CategoryAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            if (annotationView == nil) {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                annotationView!.canShowCallout = true
                annotationView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
                annotationView!.userInteractionEnabled = false
            } else {
                annotationView!.annotation = annotation
            }
            let categoryAnnotation = annotation as! CategoryAnnotation
            // Set color
            annotationView?.pinTintColor = categoryAnnotation.color
            annotationView?.rightCalloutAccessoryView?.tintColor = categoryAnnotation.color
            return annotationView
        }
        return nil
    }

    // did click Callout
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (control == view.rightCalloutAccessoryView) {
            print("button clicked")
        }
        if (view.annotation is CategoryAnnotation) {
            let category = (view.annotation as! CategoryAnnotation).category
            if (editMode.title == "Edit") {
                performSegueWithIdentifier("showDetail", sender: category)
            } else {
                performSegueWithIdentifier("editCategory", sender: category)
            }
        }
    }

    // Draw circle around annotation
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is CategoryCircle) {
            let overlayRenderer: MKCircleRenderer = MKCircleRenderer(overlay: overlay);
            let categoryCircle = overlay as! CategoryCircle
            overlayRenderer.lineWidth = 2.0
            overlayRenderer.fillColor = categoryCircle.color!.colorWithAlphaComponent(0.3)
            overlayRenderer.strokeColor = categoryCircle.color!
            return overlayRenderer
        }
        return MKOverlayRenderer()
    }

    // MARK: - Segues, Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == nil) {
            return
        }
        switch segue.identifier! {
        case "addCategory":
            // Activate new category dialog
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! CategoryController
            controller.delegate = self
            break
        case "editCategory":
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! CategoryController
            controller.delegate = self
            controller.category = sender as? Category
            break
        case "showDetail":
            // Manage detail view
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! ReminderCategoryDetailController
            controller.category = sender as? Category
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            break
        default:
            break
        }
    }

    // Annotation
    class CategoryAnnotation: MKPointAnnotation {
        var color: UIColor?
        var category: Category? {
            didSet {
                color = Config.colors[category!.color!.integerValue]
                coordinate.latitude = category!.latitude!.doubleValue
                coordinate.longitude = category!.longitude!.doubleValue
                title = category!.title
                subtitle = category!.address
            }
        }
    }

    // Annotation radius
    class CategoryCircle: MKCircle {
        var color: UIColor?
        var category: Category?
        convenience init(category: Category) {
            let coordinate2D = CLLocationCoordinate2D(latitude: category.latitude!.doubleValue, longitude: category.longitude!.doubleValue)
            let radius = Double(Config.radius[category.notificationRadius!.integerValue])
            self.init()
            self.init(centerCoordinate: coordinate2D, radius: radius)
            self.category = category
            self.color = Config.colors[category.color!.integerValue]
    } }

}
