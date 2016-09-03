//
//  LocationManager.swift
//  WanderList
//
//  Created by HaoBoji on 3/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit

import Foundation
import CoreLocation

public class LocationManager: NSObject, CLLocationManagerDelegate {

    private let manager: CLLocationManager

    // static instance
    public static let shared = LocationManager()

    private override init() {
        self.manager = CLLocationManager()
        super.init()
        self.manager.activityType = CLActivityType.AutomotiveNavigation
        self.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.manager.delegate = self
    }

    public func start() {
        self.manager.requestAlwaysAuthorization()
        self.manager.startMonitoringSignificantLocationChanges()
    }

    public func getLastLocation() -> CLLocation? {
        return manager.location
    }

    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // print(manager.location!.timestamp)
    }
}
