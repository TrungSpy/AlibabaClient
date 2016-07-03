//
//  JoinViewController.swift
//  Alibaba
//
//  Created by 村上晋太郎 on 2016/07/02.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import UIKit
import CoreLocation

class JoinViewController: UIViewController {
    
    @IBOutlet weak var raderView: UIView!
    
    var inviteViews = [JoinRaderInviteView]()
    var invitations = [Invitation]()
    
//    var prevHeadingDate = NSDate()
//    let headingInterval: NSTimeInterval = 0.3
//    var currentHeading: CLHeading?
//    var headingTimer = NSTimer()
    
//    var userLocation = CLLocation()
    
    var updateTimer = NSTimer()
    var invitationUpdateTimer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupAnimation()
        
        invitationUpdateTimer = NSTimer.scheduledTimerWithTimeInterval(
            1.0/30,
            target: self,
            selector: #selector(JoinViewController.update),
            userInfo: nil,
            repeats: true)
        
//        LocationManager.shared.locationCallbacks.append {
//            [weak self] manager, locations in
//            self?.userLocation = manager.location ?? CLLocation()
//            
//            self?.updateInviteViews()
//        }
//        
    }
    
    override func viewWillAppear(animated: Bool) {
        invitationUpdateTimer = NSTimer.scheduledTimerWithTimeInterval(
            1,
            target: self,
            selector: #selector(JoinViewController.updateInvitations),
            userInfo: nil,
            repeats: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        invitationUpdateTimer.invalidate()
        invitationUpdateTimer = NSTimer()
    }
    
    func updateInvitations() {
        let location = LocationManager.shared.currentLocation
        InvitationManager.shared.search(1, lat: location.coordinate.latitude, lon: location.coordinate.longitude ) {
            invitations in
            self.invitations = invitations
            self.invitations = [invitations.last!] // test
//            self.updateInviteViews()
        }
    }
    
    func update() {
        for view in self.inviteViews {
            view.removeFromSuperview()
        }
        self.inviteViews.removeAll()
        
        for invitation in self.invitations {
            let view = JoinRaderInviteView.instance()
            view.imageView.image = invitation.categoryImage()
            self.raderView.addSubview(view)
            self.inviteViews.append(view)
        }
        
        self.animateRaderView()
    }

    func goToMap(invitation: Invitation) {
        JoinManager.currentInvitation = invitation
        RoomManager.shared.create(invitation) {
            room in
            RoomManager.currentRoom = room
            self.performSegueWithIdentifier("map", sender: nil)
        }
    }
    
    func coord2Point(lat: Double, _ lon: Double) -> (CGFloat, CGFloat) {
        let range: Double = 1000 // [meter]
        let meterByDegree: Double = 40075 * 1000 / 360.0
        
        let x_meter = lon * meterByDegree
        let y_meter = lat * meterByDegree
        
        let x = view.frame.size.width / 2 * CGFloat(x_meter / range)
        let y = -view.frame.size.height / 2 * CGFloat(y_meter / range)
        
        return (x, y)
    }
    
//    func setupAnimation() {
//        LocationManager.shared.headingCallbacks.append {
//            [weak self] manager, heading in
//            self?.currentHeading = heading
//        }
        
//        headingTimer = NSTimer.scheduledTimerWithTimeInterval(
//            headingInterval,
//            target: NSBlockOperation { [weak self] in
//                UIView.animateWithDuration(self?.headingInterval ?? 0, animations: {
//                })
//            },
//            selector: #selector(NSBlockOperation.main),
//            userInfo: nil,
//            repeats: true)
//    }
    
    func animateRaderView() {
        let raderSize = raderView.bounds.size
        let center = CGPointMake(raderSize.width / 2, raderSize.height / 2)
        
        let userLocation = LocationManager.shared.currentLocation
        
        for (invitation, view) in zip(invitations, inviteViews) {
            let lat = invitation.lat - Double(userLocation.coordinate.latitude)
            let lon = invitation.lon - Double(userLocation.coordinate.longitude)
            let (x, y) = coord2Point(lat, lon)
            
            view.center.x = center.x + x
            view.center.y = center.y + y
        }
        
        let heading = LocationManager.shared.currentHeading.trueHeading
        raderView.transform = CGAffineTransformMakeRotation(
            CGFloat(-heading / 180.0 * M_PI)
        )
        
        for view in inviteViews ?? [] {
            view.transform = CGAffineTransformMakeRotation(
                CGFloat(heading / 180.0 * M_PI)
            )
        }
    }
    
    // 究極のタップのしやすさのために体を張る
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else { return }
        print("tap")
        let pos = touch.locationInView(raderView)
        
        func dist(a: CGPoint, _ b: CGPoint) -> CGFloat {
            return sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2))
        }
        
        guard let nearest = inviteViews.minElement({
            a, b in
            dist(a.center, pos) < dist(b.center, pos)
        }) else { return }
        
        let th: CGFloat = 50
        
        if dist(nearest.center, pos) < th {
            guard let index = inviteViews.indexOf(nearest) else { return }
            let invitation = invitations[index]
            goToMap(invitation)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
