//
//  InvitationManager.swift
//  Alibaba
//
//  Created by 村上晋太郎 on 2016/07/02.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import UIKit

class InvitationManager: NSObject {
    
    
    private var json:NSDictionary!
    
    func getJson() {
        
        let URL: NSURL = NSURL(string: "http://express.heartrails.com/api/json?method=getStations&name=%E6%96%B0%E5%AE%BF")!
        let jsonData :NSData = NSData(contentsOfURL: URL)!
        
        do {
            json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers) as! NSDictionary
        } catch  {
            // エラー処理
        }
        
        let response:NSDictionary = json.objectForKey("response") as! NSDictionary
        let station:NSArray = response.objectForKey("station") as! NSArray
        
        
        for i in 0 ..< station.count {
            print(station[i].objectForKey("prefecture") as! NSString)
        }
    }


    static let shared = InvitationManager()
}
