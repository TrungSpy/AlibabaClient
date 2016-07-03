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
    @IBOutlet weak var distantView: UIImageView!
    @IBOutlet weak var goalImageView: UIImageView!
    
    var timer = NSTimer()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        timer = NSTimer.scheduledTimerWithTimeInterval(
            1/30.0,
            target: self,
            selector: #selector(MeetViewController.update),
            userInfo: nil,
            repeats: true)
        
        goalImageView.image = InvitationManager.currentInvitation.categoryImage()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var counter = 0
    func update() {
        let rate = CGFloat(counter)/600
        updateDistance(rate)
    }
    
    func updateDistance(rate: CGFloat) {
        distantView.center.x = (goalView.center.x - startView.center.x) * rate + startView.center.x
        
        counter += 1
        if counter > 600 {
            timer.invalidate()
            timer = NSTimer()
            performSegueWithIdentifier("finish", sender: nil)
        }
    }
    
    @IBAction func button0Tapped(sender: UIButton) {
        sendMessage(0)
    }
    @IBAction func button1Tapped(sender: UIButton) {
        sendMessage(1)
    }
    @IBAction func button2Tapped(sender: UIButton) {
        sendMessage(2)
    }
    @IBAction func button3Tapped(sender: UIButton) {
        sendMessage(3)
    }
    @IBAction func button4Tapped(sender: UIButton) {
        sendMessage(4)
    }
    @IBAction func button5Tapped(sender: UIButton) {
        sendMessage(5)
    }
    @IBAction func button6Tapped(sender: UIButton) {
        sendMessage(6)
    }
    @IBAction func button7Tapped(sender: UIButton) {
        sendMessage(7)
    }
    @IBAction func button8Tapped(sender: UIButton) {
        sendMessage(8)
    }
    
    func randf() -> CGFloat {
        return CGFloat(arc4random_uniform(UINT32_MAX)) / CGFloat(UINT32_MAX)
    }
    
    func sendMessage(iconType: Int) {
        let point = CGPointMake(
            self.view.bounds.size.width * randf(),
            self.view.bounds.size.height + 60 * randf()
            )
        
        let view = MessageView.instance(iconType, pos: point, direction: .Up)
        self.view.addSubview(view)
        view.fire()
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
