//
//  IconPasteboardWriter.swift
//  NounSample
//
//  Created by ERNESTO GARCIA CARRIL on 11/10/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import Cocoa

class IconWriter {
    private let name:String
    private let image:NSImage?
    
    let url:NSURL
    
    init(iconName:String, iconImage:NSImage? )
    {
        self.name  = iconName
        self.image = iconImage
        url = NSURL.fileURLWithPath(NSTemporaryDirectory()).URLByAppendingPathComponent(name)
    }
    
    func delete() -> Bool  {
        do {
            try NSFileManager.defaultManager().removeItemAtURL(url)
        }
        catch
        {
            return false
        }
        return true
    }
    
    func writeImageData() -> Bool  {
        guard  let representation = image?.representations.first as? NSBitmapImageRep else  {
            return false
        }
        
        guard let data = representation.representationUsingType(.NSPNGFileType, properties: [:]) else {
            return false
        }
        return data .writeToURL(url, atomically: true)
    }
}
