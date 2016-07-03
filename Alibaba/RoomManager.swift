//
//  RoomManager.swift
//  Alibaba
//
//  Created by 村上晋太郎 on 2016/07/03.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RoomManager: NSObject {
    let host = ServerManager.host
    
    static var currentRoom = Room()
    
    func create(invitation: Invitation, completion completionOrNil: ((Room) -> Void)? = nil) {
        Alamofire.request(
            .POST,
            "http://\(host)/room",
            parameters: [
                "invite_id": invitation.id,
            ]).responseJSON {
                response in
                guard let object = response.result.value else {
                    NSLog("failed to get JSON from server...")
                    return
                }
                
                let json = JSON(object)
                
                print(json)
                if let completion = completionOrNil {
                    let room = Room.fromJSON(json)
                    completion(room)
                }
        }
    }

    func search(invitation: Invitation, completion completionOrNil: ((Room) -> Void)? = nil) {
        Alamofire.request(
            .GET,
            "http://\(host)/room/search_by_invite_id",
            parameters: [
                "invite_id": invitation.id,
            ]).responseJSON {
                response in
                guard let object = response.result.value else {
                    NSLog("failed to get JSON from server...")
                    print(response.result.error)
                    return
                }
                
                let json = JSON(object)
                
                print(json)
//                if let completion = completionOrNil {
//                    let room = Room.fromJSON(json)
//                    completion(room)
//                }
        }
    }

    static let shared = RoomManager()
}

struct Room {
    var id: Int = 0
    var invite_id: Int = 0
    var created_at: String = ""
    var updated_at: String = ""
    
    static func fromJSON(json: JSON) -> Room {
        return Room(
            id: json["id"].int ?? 0,
            invite_id: json["invite_id"].int ?? 0,
            created_at: json["created_at"].string ?? "",
            updated_at: json["updated_at"].string ?? "")
    }
}
