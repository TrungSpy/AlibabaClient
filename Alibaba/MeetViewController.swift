//
//  MeetViewController.swift
//  Alibaba
//
//  Created by 村上晋太郎 on 2016/07/02.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import UIKit

class MeetViewController: UIViewController {
    
    @IBOutlet weak var goalView: UIView!
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var distantView: UIView!
    
    var timer = NSTimer()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        timer = NSTimer.scheduledTimerWithTimeInterval(
            1,
            target: self,
            selector: #selector(MeetViewController.updateDistance),
            userInfo: nil,
            repeats: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var counter = 0
    func updateDistance() {
        let rate = CGFloat(counter)/20
        
        distantView.center.x = (goalView.center.x - startView.center.x) * rate + startView.center.x
        
        
        counter += 1
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
