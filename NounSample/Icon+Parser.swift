//
//  Icon+Parser.swift
//  NounSample
//
//  Created by ERNESTO GARCIA CARRIL on 9/10/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import Foundation

extension Icon
{
    static func iconFromJson( json:NSDictionary ) -> Icon? {
        
        guard   let attribution = json["attribution"] as? String, let previewURL = json["preview_url"] as? String, let iconID = json["id"] as? String else {
            return nil
        }
        guard let url = NSURL(string: previewURL) else {
            return nil;
        }
        let name = "noun_" + iconID + ".png"
        
        return Icon(name:name, attribution: attribution, previewURL: url)
    }
    
    static func iconListFromJsonData( jsonData:NSData) -> [Icon]? {
        
        guard let jsonSerializer = try? NSJSONSerialization.JSONObjectWithData(jsonData, options:NSJSONReadingOptions(rawValue: 0)) as? NSDictionary else {
            return nil;
        }
        guard let iconList = jsonSerializer!["icons"] as? [NSDictionary] else {
            return nil;
        }
        let icons = iconList.map{ Icon.iconFromJson($0) }.flatMap{ $0 }
        return icons
    }
    
    
}