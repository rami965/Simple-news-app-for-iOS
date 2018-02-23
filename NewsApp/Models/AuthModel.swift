//
//  AuthModel.swift
//  NewsApp
//
//  Created by MACC on 2/3/18.
//  Copyright © 2018 Rami. All rights reserved.
//

import Foundation
import ObjectMapper

class AuthResponse: NSObject, Mappable {
    
    var success: Bool?
    var token: Int64?
    var ttl: Int32?
    var msg: String?
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        success     <- map["success"]
        token       <- map["token"]
        ttl         <- map["ttl"]
        msg         <- map["msg"]
    }
    
}
///////////////////////////////////////////////////////
