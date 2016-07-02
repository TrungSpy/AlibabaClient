//
//  JoinRaderInviteView.swift
//  Alibaba
//
//  Created by 村上晋太郎 on 2016/07/02.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import UIKit

class JoinRaderInviteView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func instance() -> JoinRaderInviteView {
        return UINib(nibName: "JoinRaderInviteView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! JoinRaderInviteView
    }
}
