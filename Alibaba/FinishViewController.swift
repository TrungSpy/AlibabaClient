//
//  FinishViewController.swift
//  Alibaba
//
//  Created by 村上晋太郎 on 2016/07/03.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import UIKit

class FinishViewController: UIViewController {
    
    var timer = NSTimer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        timer = NSTimer.scheduledTimerWithTimeInterval(
            1/33.0,
            target: self,
            selector: #selector(FinishViewController.update),
            userInfo: nil,
            repeats: true)
    }
    
    var counter = 0
    func update() {
        
        if counter % 2 == 0 {
            view.backgroundColor = UIColor.alizarinColor()
        } else {
            view.backgroundColor = UIColor.yellowColor()
        }
        
        counter += 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
