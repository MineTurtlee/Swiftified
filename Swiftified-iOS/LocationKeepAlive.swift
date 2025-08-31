//
//  LocationKeepAlive.swift
//  Swiftified
//
//  Created by GreenyCells (Mineturtlee) on 30/8/25.
//


import CoreLocation
import Logging
import Foundation

fileprivate var logger = Logger(label: "LocationKeepAlive")

class LocationKeepAlive: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared: LocationKeepAlive = LocationKeepAlive()
    private let manager = CLLocationManager()
    lazy var variabeeee: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    private override init() {
        super.init()
        manager.delegate = self
    }
    
    func checkPermission() -> CLAuthorizationStatus {
        var authorizationStatus: CLAuthorizationStatus {
            if #available(iOS 14.0, *) {
                return manager.authorizationStatus
            } else {
                return CLLocationManager.authorizationStatus()
            }
        }

        return authorizationStatus
    }
    
    func requestPermission() {
        // Ask for "Always" permission
        manager.requestAlwaysAuthorization()
    }
    
    func start() {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        
        // Time to (not!) dox users (LMAO..)
        manager.startUpdatingLocation()
    }
    
    func stop() {
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        logger.info("Location updated @ \(Date())")
        variabeeee = locations.last?.coordinate ?? CLLocationCoordinate2D()
    }
}
