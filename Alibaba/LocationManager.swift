//
//  LocationManager.swift
//  Alibaba
//
//  Created by 村上晋太郎 on 2016/07/02.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    var locationCallbacks: [((manager: CLLocationManager, locations: [CLLocation]) -> Void)] = []
    var headingCallbacks: [((manager: CLLocationManager, heading: CLHeading) -> Void)] = []
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    // MARK: - Delegate
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
//        case .NotDetermined:
//            return
//        case .Restricted:
//            return
        case .Denied:
            return
        case .AuthorizedAlways:
            break
        case .AuthorizedWhenInUse:
            break
        default:
            break
        }
        
        manager.startUpdatingHeading()
        manager.startUpdatingHeading()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for callback in locationCallbacks {
            callback(manager: manager, locations: locations)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        for callback in headingCallbacks {
            callback(manager: manager, heading: newHeading)
        }
    }
    
    // 位置情報取得に失敗した時に呼び出されるデリゲート.
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("locationManager error")
    }
    
    // ------
    
    static let shared = LocationManager()
}
