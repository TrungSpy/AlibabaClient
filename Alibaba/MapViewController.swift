//
//  MapViewController.swift
//  Alibaba
//
//  Created by 村上晋太郎 on 2016/07/02.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import UIKit
import FlatUIKit
import MapKit

class MKPointAnnotationWithType: MKPointAnnotation {
    enum Type {
        case User, Invitation, Goal
    }
    var type: Type
    
    init(type: Type) {
        self.type = type
        super.init()
    }
}

class MapViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var destSearchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    var destLocation = CLLocationCoordinate2D()
    var userLocation = CLLocationCoordinate2D()
    var userLocAnnotation = MKPointAnnotation()
    
    var invitationLocAnnotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        LocationManager.shared.locationCallbacks.append {
            [weak self] manager, locations in
            self?.locationManager(manager, didUpdateLocations: locations)
        }
        
        mapView.delegate = self
        destSearchBar.delegate = self
        
//        InvitationManager.shared.get {
//            invitations in
//            
//            print(invitations)
//            
//            self.mapView.removeAnnotations(self.invitationLocAnnotations)
//            
//            self.invitationLocAnnotations = invitations.map {
//                invitation in
//                let annotation = MKPointAnnotationWithType(type: .Invitation)
//                annotation.coordinate = CLLocationCoordinate2DMake(
//                    CLLocationDegrees(invitation.lat),
//                    CLLocationDegrees(invitation.lon))
//                annotation.title = "invitation"
//                return annotation
//            }
//            
//            self.mapView.addAnnotations(self.invitationLocAnnotations)
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        let invitation = JoinManager.shared.invitation
        
        let location = CLLocation(
            latitude: CLLocationDegrees(invitation.lat),
            longitude: invitation.lon)
        
        let placemark = MKPlacemark(coordinate: location.coordinate, addressDictionary: nil)
        
        self.userLocation = LocationManager.shared.currentLocation.coordinate
        // 目的地の座標を取得
        self.destLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        // 目的地にピンを立てる
        self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
        getRoute()
    }
    
    // MARK: - Delegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        userLocation = CLLocationCoordinate2DMake(manager.location!.coordinate.latitude, manager.location!.coordinate.longitude)
        
        mapView.removeAnnotation(userLocAnnotation)
        
        userLocAnnotation = MKPointAnnotationWithType(type: .User)
        userLocAnnotation.coordinate = userLocation
        userLocAnnotation.title = "location"
        mapView.addAnnotation(userLocAnnotation)
    }
    
    // --------
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // キーボードを隠す
        destSearchBar.resignFirstResponder()
        
        // 目的地の文字列から座標検索
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(destSearchBar.text ?? "", completionHandler: {
            (placemarks: [CLPlacemark]?, error: NSError?)  in
            guard let placemark = placemarks?[0] else { return }
            guard let location  = placemark.location else { return }
            // 目的地の座標を取得
            self.destLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            // 目的地にピンを立てる
            self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
            // 現在地の取得を開始
//            self.locationManager.startUpdatingLocation()
            
            self.getRoute()
        })
    }
    
    func getRoute()
    {
        // 現在地と目的地のMKPlacemarkを生成
        let fromPlacemark = MKPlacemark(coordinate:userLocation, addressDictionary:nil)
        let toPlacemark   = MKPlacemark(coordinate:destLocation, addressDictionary:nil)
        
        // MKPlacemark から MKMapItem を生成
        let fromItem = MKMapItem(placemark:fromPlacemark)
        let toItem   = MKMapItem(placemark:toPlacemark)
        
        // MKMapItem をセットして MKDirectionsRequest を生成
        let request = MKDirectionsRequest()
        
        
        request.source = fromItem
        request.destination = toItem
        request.requestsAlternateRoutes = false // 単独の経路を検索
        request.transportType = MKDirectionsTransportType.Any
        
        let directions = MKDirections(request:request)
        
        directions.calculateDirectionsWithCompletionHandler {
            (responseOrNil: MKDirectionsResponse?, error: NSError?) in
            guard let response = responseOrNil else { return }
            
            response.routes.count
            if (error != nil || response.routes.isEmpty) {
                return
            }
            let route: MKRoute = response.routes[0]
            // 経路を描画
            self.mapView.addOverlay(route.polyline)
            // 現在地と目的地を含む表示範囲を設定する
            self.showUserAndDestinationOnMap()
        }
    }
    
    func showUserAndDestinationOnMap()
    {
        // 現在地と目的地を含む矩形を計算
        let maxLat:Double = fmax(userLocation.latitude,  destLocation.latitude)
        let maxLon:Double = fmax(userLocation.longitude, destLocation.longitude)
        let minLat:Double = fmin(userLocation.latitude,  destLocation.latitude)
        let minLon:Double = fmin(userLocation.longitude, destLocation.longitude)
        
        // 地図表示するときの緯度、経度の幅を計算
        let mapMargin:Double = 1.5;  // 経路が入る幅(1.0)＋余白(0.5)
        let leastCoordSpan:Double = 0.005;    // 拡大表示したときの最大値
        let span_x:Double = fmax(leastCoordSpan, fabs(maxLat - minLat) * mapMargin);
        let span_y:Double = fmax(leastCoordSpan, fabs(maxLon - minLon) * mapMargin);
        let span:MKCoordinateSpan = MKCoordinateSpanMake(span_x, span_y);
        
        // 現在地を目的地の中心を計算
        let center:CLLocationCoordinate2D = CLLocationCoordinate2DMake((maxLat + minLat) / 2, (maxLon + minLon) / 2);
        let region:MKCoordinateRegion = MKCoordinateRegionMake(center, span);
        
        mapView.setRegion(mapView.regionThatFits(region), animated:true);
    }
    
    // 経路を描画するときの色や線の太さを指定
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        if overlay is MKPolyline {
            polylineRenderer.strokeColor = UIColor.alizarinColor()
            polylineRenderer.lineWidth = 5
        }
        return polylineRenderer
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let view = (mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as? MKPinAnnotationView) ??
            MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        view.pinTintColor = UIColor.peterRiverColor()
        return view
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
