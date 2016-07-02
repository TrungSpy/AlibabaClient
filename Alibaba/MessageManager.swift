//
//  CommentManager.swift
//  Alibaba
//
//  Created by 村上晋太郎 on 2016/07/03.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MessageManager: NSObject {
    
    let host = ServerManager.host
    
    static var currentRoom = Room()
    
    func create(room: Room, iconType: Int, completion completionOrNil: ((Message) -> Void)? = nil) {
        Alamofire.request(
            .POST,
            "http://\(host)/message",
            parameters: [
                "room_id": room.id,
                "icon_type": iconType
            ]).responseJSON {
                response in
                guard let object = response.result.value else {
                    NSLog("failed to get JSON from server...")
                    print(response.result.error)
                    return
                }
                
                let json = JSON(object)
                
                print(json)
                if let completion = completionOrNil {
                    let message = Message.fromJSON(json)
                    completion(message)
                }
        }
    }

    static let shared = MessageManager()
}

struct Message {
    
    static func fromJSON(json: JSON) -> Message {
        return Message()
    }
}
