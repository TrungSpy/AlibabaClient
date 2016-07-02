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
    var prevHeadingDate = NSDate()
    let headingInterval: NSTimeInterval = 0.5
    var currentHeading = CLHeading()
    var headingTimer = NSTimer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = JoinRaderInviteView.instance()
        raderView.addSubview(view)
        inviteViews.append(view)
        

        LocationManager.shared.headingCallbacks.append {
            [weak self] manager, heading in
            self?.currentHeading = heading
            
        }
        
        headingTimer = NSTimer.scheduledTimerWithTimeInterval(
            headingInterval,
            target: NSBlockOperation { [weak self] in
                guard let heading = self?.currentHeading else { return }
                
                UIView.animateWithDuration(self?.headingInterval ?? 0, animations: {
                    self?.raderView.transform = CGAffineTransformMakeRotation(
                        CGFloat(-heading.magneticHeading / 180.0 * M_PI)
                    )
                    
                    for view in self?.inviteViews ?? [] {
                        view.transform = CGAffineTransformMakeRotation(
                            CGFloat(heading.magneticHeading / 180.0 * M_PI)
                        )
                    }
                })
            },
            selector: #selector(NSBlockOperation.main),
            userInfo: nil,
            repeats: true)
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
