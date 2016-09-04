//
//  MapPickController.swift
//  WanderList
//
//  Created by HaoBoji on 3/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import MapKit

protocol LocationPickDelegate {
    func didPickLocation(controller: MapPickController)
}

class MapPickController: UIViewController, MKMapViewDelegate, HandleMapSearch {

    @IBOutlet var mapView: MKMapView!
    // Search bar
    var resultSearchController: UISearchController? = nil
    // For location passing
    var delegate: LocationPickDelegate?
    var currentPickedLocation: MKPointAnnotation?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Maps
        self.mapView.delegate = self
        // Set map camera
        var lastLocation = LocationManager.shared.getLastLocation()
        var camera: MKMapCamera
        // Default location - Melbourne
        if (lastLocation == nil) {
            lastLocation = CLLocation(latitude: -37.768356, longitude: 144.9663673)
        }
        // Set camera
        camera = MKMapCamera(lookingAtCenterCoordinate: lastLocation!.coordinate, fromEyeCoordinate: lastLocation!.coordinate, eyeAltitude: 50000)
        mapView.setCamera(camera, animated: false)
        // Search result list under serach bar
        let locationSearchTable = storyboard!.instantiateViewControllerWithIdentifier("LocationSearchTable") as! LocationSearchTableController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        // Setup search bar
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        // Setup search table
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addAnnotation(annotation: MKPointAnnotation) {
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
    }

    func addAnnotationFromSearch(annotation: MKPointAnnotation) {
        addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(annotation.coordinate, span)
        mapView.setRegion(region, animated: true)
    }

    // MARK:- MapViewDelegate methods, Annotation View
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            // return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.canShowCallout = true
        pinView?.rightCalloutAccessoryView = UIButton(type: .ContactAdd)
        return pinView
    }

    // MARK:- MapViewDelegate methods, Annotation View Callout
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (view.annotation is MKPointAnnotation) {
            self.currentPickedLocation = view.annotation as? MKPointAnnotation
            delegate!.didPickLocation(self)
        }
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
