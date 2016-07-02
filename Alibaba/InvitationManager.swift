//
//  InvitationManager.swift
//  Alibaba
//
//  Created by 村上晋太郎 on 2016/07/02.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class InvitationManager: NSObject {
    func get(complition: ((invitations: [Invitation]) -> Void)) {
        Alamofire.request(.GET, "http://10.201.120.98:3000/invites")
            .responseJSON {
                response in
                guard let object = response.result.value else {
                    NSLog("failed to get JSON from server...")
                    return
                }
                let json = JSON(object)
                
                let invitations: [Invitation] = (json.array ?? []).map { elem in
                    return Invitation(
                        id: elem["id"].int!,
                        category: elem["category"].string!,
                        status: elem["status"].string!,
                        lon: elem["lon"].double!,
                        lat: elem["lat"].double!,
                        limit: elem["limit"].int,
                        created_at: elem["created_at"].string!,
                        updated_at: elem["updated_at"].string!
                    )
                }
                
                complition(invitations: invitations)
        }
    }
    
//            "hoge"
//            "category" : "karaoke",
//            "status" : "inviting",
//            "id" : 6,
//            "created_at" : "2016-07-02T08:42:53.283Z",
//            "lon" : 139.6957584,
//            "limit" : null,
//            "lat" : 35.6583386,
//            "updated_at" : "2016-07-02T08:42:53.283Z"
//    }
    
    static let shared = InvitationManager()
}

struct Invitation {
//    enum Categoy {
//        case Beer, Karaoke
//    }
//    
//    enum Status {
//        case Inviting
//    }
//    
    var id: Int
    var category: String
    var status: String
    var lon: Double
    var lat: Double
    var limit: Int?
    var created_at: String
    var updated_at: String
}

