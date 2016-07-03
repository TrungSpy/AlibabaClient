//
//  InviteViewController.swift
//  Alibaba
//
//  Created by 村上晋太郎 on 2016/07/02.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import UIKit

class InviteViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        scrollView.delegate = self
        
        let center = CGPointMake(
            view.frame.size.width/2,
            view.frame.size.height/2)
        
        for i in 0..<Invitation.categories.count {
            var size = view.frame.size
            size.width *= 0.8
            size.height *= 0.8
            let x = center.x + view.frame.size.width * CGFloat(i)
            let y = center.y
            
            let imageView = UIImageView(image: UIImage(named: "logo002"))
            imageView.frame.size = size
            imageView.center = CGPointMake(x, y)
            imageView.contentMode = .ScaleAspectFit
            
            scrollView.addSubview(imageView)
        }
        
        scrollView.contentSize = CGSizeMake(
            scrollView.frame.size.width * CGFloat(Invitation.categories.count),
            scrollView.frame.size.height)
        
    }
    
    func currentCatetory() -> String {
        let index = Int((scrollView.contentOffset.x + 1) / scrollView.bounds.size.width)
        return Invitation.categories[index]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
            scrollView.setContentOffset(
                CGPointMake(scrollView.contentOffset.x, 0)
                , animated: false)
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let location = LocationManager.shared.currentLocation
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        let category = currentCatetory()
        
        print((category, lat, lon))
        
        InvitationManager.shared.create(category, lat: lat, lon: lon) {
            invitation in
            
        }
    }

}
