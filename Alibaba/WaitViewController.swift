//
//  WaitViewController.swift
//  Alibaba
//
//  Created by 村上晋太郎 on 2016/07/02.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import UIKit

class WaitViewController: UIViewController {
    
    var timer = NSTimer()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        timer = NSTimer.scheduledTimerWithTimeInterval(
            1,
            target: self,
            selector: #selector(WaitViewController.update),
            userInfo: nil,
            repeats: true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        timer.invalidate()
        timer = NSTimer()
    }
    
    func update() {
        RoomManager.shared.search(InvitationManager.currentInvitation) {
            room in
            print(room)
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
