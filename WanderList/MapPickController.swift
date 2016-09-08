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

class MapPickController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate, HandleMapSearch {

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
        searchBar.searchBarStyle = .Minimal
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        // Setup search table
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self

        // Set long tap to add annotation
        let longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longTapHandler(_:)))
        longTapRecognizer.delegate = self
        mapView.addGestureRecognizer(longTapRecognizer)
    }

    // Long tap to add annotation
    func longTapHandler(gestureReconizer: UITapGestureRecognizer) {
        if (gestureReconizer.state != .Began) {
            return
        }
        let tapPosition = gestureReconizer.locationInView(mapView)
        let tapCoordinate = mapView.convertPoint(tapPosition, toCoordinateFromView: mapView)
        let tapLocation = CLLocation(latitude: tapCoordinate.latitude, longitude: tapCoordinate.longitude)
        // Parse coordinate to address
        CLGeocoder().reverseGeocodeLocation(tapLocation) { (placemarks, error) in
            var address = "Unknow Place"
            if (error == nil && placemarks!.count > 0) {
                address = LocationManager.shared.parseAddress(placemarks![0])
            }
            let annotation = MKPointAnnotation()
            annotation.coordinate = tapCoordinate
            annotation.title = "Dropped Pin"
            annotation.subtitle = address
            self.addAnnotation(annotation)
        }
    }

    // Add annotation to map
    func addAnnotation(annotation: MKPointAnnotation) {
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
    }

    // Add annotation from search result
    func addAnnotationFromSearch(annotation: MKPointAnnotation) {
        addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(annotation.coordinate, span)
        mapView.setRegion(region, animated: true)
    }

    // MARK:- MapViewDelegate methods, Annotation View
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            // return nil so map view draws "green dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.animatesDrop = true
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

}
