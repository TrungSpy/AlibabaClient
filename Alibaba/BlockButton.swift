//
//  BlockButton.swift
//  Alibaba
//
//  Created by 村上晋太郎 on 2016/07/03.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import UIKit

class BlockButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAction()
    }
    
    var pushed: (() -> Void) = {}
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAction()
    }
    
    func setupAction() {
        addTarget(self, action: #selector(BlockButton.__pushed), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func __pushed() {
        pushed()
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
