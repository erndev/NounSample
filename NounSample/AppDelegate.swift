//
//  AppDelegate.swift
//  NounSample
//
//  Created by ERNESTO GARCIA CARRIL on 9/10/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    var mainViewController:MainViewController?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        //TOTO: Place here your app's OAuth key and secret
        let key = ""
        let secret =  ""
        
        guard key.characters.count > 0 && secret.characters.count > 0 else
        {
            
            let alertView = NSAlert()
            alertView.messageText = NSLocalizedString("OAuth key and secret not found", comment: "")
            alertView.informativeText = NSLocalizedString("You need to add your app's Key and Secret in AppDelegate.swift to use OAuth Authentication", comment: "")
            alertView.beginSheetModalForWindow(window, completionHandler: { (response) -> Void in
                NSApp.terminate(self)
            })
            return;
        }
        
        window.contentViewController = MainViewController(key: key, secret: secret )
    }

}

