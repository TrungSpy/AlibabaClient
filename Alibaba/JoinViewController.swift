//
//  JoinViewController.swift
//  Alibaba
//
//  Created by 村上晋太郎 on 2016/07/02.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import UIKit

class JoinViewController: UIViewController {
    
    @IBOutlet weak var raderView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        LocationManager.shared.headingCallbacks.append {
            [weak self] manager, heading in
            print(heading)
            self?.raderView.transform = CGAffineTransformMakeRotation(
                CGFloat(-heading.magneticHeading / 180.0 * M_PI)
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
