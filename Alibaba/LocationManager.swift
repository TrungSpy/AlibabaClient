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
    
    var callbacks: [([CLLocation] -> Void)] = []
    
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
        
        manager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for callback in callbacks {
            callback(locations)
        }
    }
    
    // 位置情報取得に失敗した時に呼び出されるデリゲート.
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("locationManager error")
    }
}
