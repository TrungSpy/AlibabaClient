//
//  InvitationManager.swift
//  Alibaba
//
//  Created by 村上晋太郎 on 2016/07/02.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import UIKit

class InvitationManager: NSObject {
    
    
    private var json = NSArray()
    
    func getJson() {
        
        let URL: NSURL = NSURL(string: "http://10.201.120.98:3000/invites")!
        guard let jsonData :NSData = NSData(contentsOfURL: URL) else {
            
            return
        }
        
        do {
            json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers) as! NSArray
        } catch  {
            // エラー処理
        }
        
        print(json)
        
//        let response:NSDictionary = json.objectForKey("response") as! NSDictionary
//        let station:NSArray = response.objectForKey("station") as! NSArray
//        
//        
//        for i in 0 ..< station.count {
//            print(station[i].objectForKey("prefecture") as! NSString)
//        }
    }


    static let shared = InvitationManager()
}
