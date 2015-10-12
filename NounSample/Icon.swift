//
//  Icon.swift
//  NounSample
//
//  Created by ERNESTO GARCIA CARRIL on 9/10/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import AppKit


public struct Icon {
    
    public let attribution:String
    public let previewURL:NSURL
    public let name:String
    public var image:NSImage?
    
    init( name:String, attribution:String, previewURL:NSURL )
    {
        self.name = name
        self.attribution = attribution
        self.previewURL = previewURL
    }
}