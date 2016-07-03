//
//  MessageView.swift
//  Alibaba
//
//  Created by 村上晋太郎 on 2016/07/03.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import UIKit

class MessageView: UIView {
    
    var direction: Direction = .Up
    
    enum Direction {
        case Up, Down
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fire() {
        UIView.animateWithDuration(
            2,
            delay: 0,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: {
                if self.direction == .Up {
                    self.center.y -= 400
                } else {
                    self.center.y += 400
                }
            }, completion: {
                finished in
                self.removeFromSuperview()
            })
        
        UIView.animateWithDuration(
            1,
            delay: 1,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: {
                self.alpha = 0
            }, completion: {
                finished in
            })
    }
    
    class func instance(iconType: Int, pos: CGPoint, direction: Direction) -> MessageView {
        let view = MessageView(frame: CGRectMake(0, 0, 66, 66))
        view.center = pos
        
        let imageView = UIImageView(image: UIImage(named: Message.imageNames[iconType]) ?? UIImage())
        imageView.frame = view.bounds
        view.addSubview(imageView)
        view.direction = direction
        
        return view
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
