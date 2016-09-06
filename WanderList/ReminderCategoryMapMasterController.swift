//
//  ReminderCategoryMapMasterController.swift
//  WanderList
//
//  Created by HaoBoji on 6/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import MapKit

class ReminderCategoryMapMasterController: UIViewController, MKMapViewDelegate, CategoryListDelegate {

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refresh() {
        mapView.removeAnnotations(mapView.annotations)
        categories = DataManager.shared.getCategoryList()
        for category in categories! {
            let annotation = CategoryAnnotation()
            annotation.category = category as? Category
            mapView.addAnnotation(annotation)
            let circle = CategoryCircle(category: category as! Category)
            mapView.addOverlay(circle)
        }
    }

    func navBack(controller: ReminderCategoryMapMasterController) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    // MARK: Map Delegate

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is CategoryAnnotation) {
            let reuseId = "bridge"
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            if (annotationView == nil) {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                annotationView!.canShowCallout = true
                annotationView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
                annotationView!.userInteractionEnabled = false
            } else {
                annotationView!.annotation = annotation
            }
            let categoryAnnotation = annotation as! CategoryAnnotation
            annotationView?.pinTintColor = categoryAnnotation.color
            annotationView?.rightCalloutAccessoryView?.tintColor = categoryAnnotation.color
            return annotationView
        }
        return nil
    }

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (view.annotation is CategoryAnnotation) {
            let category = (view.annotation as! CategoryAnnotation).category
            performSegueWithIdentifier("showDetail", sender: category)
        }
    }

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == nil) {
            return
        }
        switch segue.identifier! {
        case "addCategory":
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! CategoryController
            controller.delegate = self
            break
        case "showDetail":
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
