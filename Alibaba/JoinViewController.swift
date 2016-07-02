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
    
    var prevHeadingDate = NSDate()
    let headingInterval: NSTimeInterval = 0.5
    var currentHeading = CLHeading()
    var headingTimer = NSTimer()
    
    var userLocation = CLLocation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAnimation()
        
        LocationManager.shared.locationCallbacks.append {
            [weak self] manager, locations in
            self?.userLocation = manager.location ?? CLLocation()
            
            self?.updateInviteViews()
        }
        
        InvitationManager.shared.get {
            invitations in
            self.invitations = invitations
            self.updateInviteViews()
        }
    }
    
    func updateInviteViews() {
        while inviteViews.count > invitations.count {
            inviteViews.popLast()?.removeFromSuperview()
        }
        
        while inviteViews.count < invitations.count {
            let view = JoinRaderInviteView.instance()
            raderView.addSubview(view)
            inviteViews.append(view)
            view.tapAction = {
                [weak self] in
                self?.performSegueWithIdentifier("map", sender: nil)
                print("helloo")
            }
            
        }
        
    }
    
    func coord2Point(lat: Double, _ lon: Double) -> (CGFloat, CGFloat) {
        let range: Double = 6000 // [meter]
        let meterByDegree: Double = 40075 * 1000 / 360.0
        
        let x_meter = lon * meterByDegree
        let y_meter = lat * meterByDegree
        
        let x = view.frame.size.width / 2 * CGFloat(x_meter / range)
        let y = -view.frame.size.height / 2 * CGFloat(y_meter / range)
        
        return (x, y)
    }
    
    func setupAnimation() {
        LocationManager.shared.headingCallbacks.append {
            [weak self] manager, heading in
            self?.currentHeading = heading
        }
        
        headingTimer = NSTimer.scheduledTimerWithTimeInterval(
            headingInterval,
            target: NSBlockOperation { [weak self] in
                UIView.animateWithDuration(self?.headingInterval ?? 0, animations: {
                    self?.animateRaderView()
                })
            },
            selector: #selector(NSBlockOperation.main),
            userInfo: nil,
            repeats: true)
    }
    
    func animateRaderView() {
        let raderSize = raderView.frame.size
        let center = CGPointMake(raderSize.width / 2, raderSize.height / 2)
        
        for (invitation, view) in zip(invitations, inviteViews) {
            let lat = invitation.lat - Double(userLocation.coordinate.latitude)
            let lon = invitation.lon - Double(userLocation.coordinate.longitude)
            let (x, y) = coord2Point(lat, lon)
            
            view.center.x = center.x + x
            view.center.y = center.y + y
        }
        
        let heading = currentHeading
        raderView.transform = CGAffineTransformMakeRotation(
            CGFloat(-heading.magneticHeading / 180.0 * M_PI)
        )
        
        for view in inviteViews ?? [] {
            view.transform = CGAffineTransformMakeRotation(
                CGFloat(heading.magneticHeading / 180.0 * M_PI)
            )
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
