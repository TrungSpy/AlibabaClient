//
//  InviteViewController.swift
//  Alibaba
//
//  Created by 村上晋太郎 on 2016/07/02.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import UIKit

class InviteViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let activities = [
        "test",
        "test",
        "test",
        "test",
        "test",
        "test",
        "test",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        scrollView.contentSize = CGSizeMake(
            scrollView.frame.size.width * CGFloat(activities.count),
            scrollView.frame.size.height)
        
        let center = CGPointMake(
            scrollView.frame.size.width/2,
            scrollView.frame.size.height/2)
        
        for i in 0..<activities.count {
            let size = scrollView.frame.size
            let x = center.x + size.width * CGFloat(i)
            let y = center.y
            
            let imageView = UIImageView(image: UIImage(named: "logo002"))
            imageView.frame.size = size
            imageView.center = CGPointMake(x, y)
            imageView.contentMode = .ScaleAspectFit
            
            scrollView.addSubview(imageView)
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
