//
//  LocationManager.swift
//  WanderList
//
//  Created by HaoBoji on 3/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//
//  Manage location updates
//

import UIKit

import Foundation
import CoreLocation
import MapKit

public class LocationManager: NSObject, CLLocationManagerDelegate {

    private let manager: CLLocationManager

    // static instance
    public static let shared = LocationManager()

    // Customize location manager
    private override init() {
        self.manager = CLLocationManager()
        super.init()
        self.manager.activityType = CLActivityType.Other
        self.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.manager.delegate = self
    }

    // Start monitoring
    public func start() {
        self.manager.requestAlwaysAuthorization()
        self.manager.startMonitoringSignificantLocationChanges()
        self.manager.startUpdatingLocation()
    }

    // Get recent location
    public func getLastLocation() -> CLLocation? {
        return manager.location
    }

    // Recieve updates from system manager
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (locations.count == 0) {
            return
        }
        NotificationManager.shared.didUpdateLocation(locations.last!)
    }

    // Adapted from https://www.thorntech.com/2016/01/how-to-search-for-location-using-apples-mapkit/
    func parseAddress(selectedItem: CLPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        let addressLine = String(
            format: "%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? ""
        )
        return addressLine
    }
}
