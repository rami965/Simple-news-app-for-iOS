//
//  NewsModel.swift
//  NewsApp
//
//  Created by MACC on 2/4/18.
//  Copyright © 2018 Rami. All rights reserved.
//

import Foundation
import ObjectMapper

class NewsResponse: NSObject, Mappable {
    var success: Bool?
    var msg: String?
    var data: [NewsObject]?
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        success     <- map["success"]
        msg         <- map["msg"]
        data        <- map["data"]
    }
    
}
///////////////////////////////////////////////////////
class NewsObject: NSObject, Mappable {
    var nid: String?
    var node_type: String?
    var title: String?
    var author_id: String?
    var author_img: String?
    var fullurl: String?
    var details: String?
    var comment_count: String?
    var created_date: String?
    var view_count: String?
    var main_img: String?
    var section_name: String?
    var section_id: String?
    var tags: [TagObject]?
    var countries: [CountryObject]?
    var is_followed: Bool?
    var page_name: String?
    var page_id: String?
    var page_details: String?
    var page_type: String?
    var page_logo: String?
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        nid             <- map["nid"]
        node_type       <- map["node_type"]
        title           <- map["title"]
        author_id       <- map["author_id"]
        author_img      <- map["author_img"]
        fullurl         <- map["fullurl"]
        details         <- map["details"]
        comment_count   <- map["comment_count"]
        created_date    <- map["created_date"]
        view_count      <- map["view_count"]
        main_img        <- map["main_img"]
        section_name    <- map["section_name"]
        section_id      <- map["section_id"]
        tags            <- map["tags"]
        countries       <- map["countries"]
        is_followed     <- map["is_followed"]
        page_name       <- map["page_name"]
        page_id         <- map["page_id"]
        page_details    <- map["page_details"]
        page_type       <- map["page_type"]
        page_logo       <- map["page_logo"]
    }
    
}
///////////////////////////////////////////////////////
class TagObject: NSObject, Mappable {
    var tag_name: String?
    var tag_id: String?
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        tag_name        <- map["tag_name"]
        tag_id          <- map["tag_id"]
    }
    
}
///////////////////////////////////////////////////////
class CountryObject: NSObject, Mappable {
    var country_name: String?
    var country_id: String?
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        country_name        <- map["country_name"]
        country_id          <- map["country_id"]
    }
    
}
