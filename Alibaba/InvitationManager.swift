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
    let host = ServerManager.host
    
    static var currentInvitation = Invitation.mock()
    
    func search(radius: Double, lat: Double, lon: Double, complition: ((invitations: [Invitation]) -> Void)) {
        Alamofire.request(
            .GET,
            "http://\(host)/invite/search",
            parameters: [
                "radius": radius,
                "lat": lat,
                "lon": lon
            ])
            .responseJSON {
                response in
                guard let object = response.result.value else {
                    NSLog("failed to get JSON from server...")
                    print(response.result.error)
                    return
                }
                let json = JSON(object)
                
                let invitations: [Invitation] = (json.array ?? []).map { elem in
                    return self.invitationWithJSON(elem)
                }
                
                complition(invitations: invitations)
        }
    }
    
    func create(category: String, lat: Double, lon: Double, completion completionOrNil: ((Invitation) -> Void)? = nil) {
        Alamofire.request(
            .POST,
            "http://\(host)/invite",
            parameters: [
                "category": category,
                "lat": lat,
                "lon": lon
            ]).responseJSON {
                response in
                guard let object = response.result.value else {
                    NSLog("failed to get JSON from server...")
                    print(response.result.error)
                    return
                }
                
                let json = JSON(object)
                
                if let completion = completionOrNil {
                    completion(self.invitationWithJSON(json))
                }
        }
    }
    
    func invitationWithJSON(json: JSON) -> Invitation {
        print(json)
        
        return Invitation(
            id: json["id"].int ?? 0,
            category: json["category"].string ?? "",
            status: json["status"].string ?? "",
            lon: json["lon"].double ?? 0,
            lat: json["lat"].double ?? 0,
            limit: json["limit"].int,
            created_at: json["created_at"].string ?? "",
            updated_at: json["updated_at"].string ?? ""
        )
    }
    
    static let shared = InvitationManager()
}

struct Invitation {
    var id: Int
    var category: String
    var status: String
    var lon: Double
    var lat: Double
    var limit: Int?
    var created_at: String
    var updated_at: String
    
    func categoryImage() -> UIImage {
        return Invitation.imageForCategory(category)
    }
    
    static let categories = [
        "beer",
        "sushi",
        "wine",
        "cocktail",
        "karaoke",
        "juice",
        "meat",
        "donut",
        "coffee",
        ]
    
    static let categoryImageNames = [
        "icon001",
        "icon002",
        "icon003",
        "icon004",
        "icon005",
        "icon006",
        "icon007",
        "icon008",
        "icon009"
    ]
    
    static func imageForCategory(category: String) -> UIImage {
        let name: String
        if let index = categories.indexOf(category) {
            name = categoryImageNames[index]
        } else {
            name = categoryImageNames[0]
        }
        return UIImage(named: name) ?? UIImage()
    }

    
    static func mock() -> Invitation {
        return Invitation(id: 0, category: "", status: "", lon: 0, lat: 0, limit: nil, created_at: "", updated_at: "")
    }
}

