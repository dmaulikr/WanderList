//
//  MapPickController.swift
//  WanderList
//
//  Created by HaoBoji on 3/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import MapKit

class MapPickController: UIViewController, MKMapViewDelegate, HandleMapSearch {

    @IBOutlet var mapView: MKMapView!
    // Search bar
    var resultSearchController: UISearchController? = nil
    // The p
    var selectedPin: MKPlacemark? = nil

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

    func dropPinFromSearch(placemark: MKPlacemark) {
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
                annotation.subtitle = "(city) (state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
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
