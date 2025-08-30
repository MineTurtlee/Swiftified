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

class LocationKeepAlive: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func checkPermission() -> String {
        lazy var status: String = ""
        switch manager.authorizationStatus {
        case .notDetermined:
            status = "didntAsk"
        case .restricted:
            status = "restricted"
        case .denied:
            status = "denied"
        case .authorizedWhenInUse:
            status = "onlyInUse"
        case .authorizedAlways:
            status = "alwaysAuthorized"
        @unknown default:
            status = "qrha"
        }
        
        logger.info("\(status)")
        return status
    }
    
    func requestPermission() {
        // Ask for "Always" permission
        manager.requestAlwaysAuthorization()
    }
    
    func start() {
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        
        // This keeps firing updates → app stays alive
        manager.startUpdatingLocation()
    }
    
    func stop() {
        manager.stopUpdatingLocation()
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location updated: \(locations.last?.coordinate ?? CLLocationCoordinate2D())")
        // You don’t actually need the location → just keeping alive
    }
}
