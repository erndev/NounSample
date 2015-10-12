//
//  MainViewController.swift
//  NounSample
//
//  Created by ERNESTO GARCIA CARRIL on 9/10/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController , IconGridViewDelegate {

    @IBOutlet weak var topView:NSView!
    @IBOutlet weak var bottomView:NSView!
    @IBOutlet weak var searchField:NSTextField!
    @IBOutlet weak var progressControl:NSProgressIndicator!
    @IBOutlet weak var zoomSlider:NSSlider!
    
    var iconsViewController:IconGridViewController?
    struct Constants {
        static let DefaultGridZoom = 1
    }
    
    let nounApiClient:NounApiClient
    
    init?( key:String, secret:String )
    {
        nounApiClient = NounApiClient(key: key, secret: secret)
        super.init(nibName: "MainViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        topView.wantsLayer = true
        topView.layer?.backgroundColor = NSColor.whiteColor().CGColor
        setupIconGridView()
        
    }
    
    override func viewDidAppear() {
        view.window?.makeFirstResponder(searchField)
    }
    
    func setupIconGridView()
    {
        iconsViewController = IconGridViewController(nibName: "IconGridViewController", bundle: nil)
        iconsViewController?.delegate = self
        iconsViewController?.view.translatesAutoresizingMaskIntoConstraints = false
        iconsViewController?.zoom = Constants.DefaultGridZoom
        addChildViewController(iconsViewController!)
        view.addSubview(iconsViewController!.view)
        
        // Setup autolayout constraints
        let views = [ "mainView":view, "topView":topView , "bottomView":bottomView, "iconsView":iconsViewController!.view ]
        let horzContraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[iconsView]|", options: .DirectionLeadingToTrailing, metrics: nil , views: views)
        let vertContraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[topView][iconsView][bottomView]", options: .DirectionLeadingToTrailing, metrics: nil , views: views)
        
        view.addConstraints(horzContraints)
        view.addConstraints(vertContraints)
        
        zoomSlider.integerValue = Constants.DefaultGridZoom
        
    }

    @IBAction func zoomLevelchanged(sender:NSSlider) {
        iconsViewController?.zoom = zoomSlider.integerValue
    }
    
    @IBAction func searchControlDidEndEditing(sender: NSTextField) {
        searchIconsWithTerm(searchField.stringValue)
    }
    
    func searchIconsWithTerm(term:String) {
        guard term.length() > 0 else {
            return;
        }
        
        iconsViewController?.showIcons([])
        progressControl.hidden = false
        progressControl.startAnimation(nil)
        // No pagination in this sample. next page should be loaded when the view reaches the bottom
        nounApiClient.iconsForSearchTerm(term) { (icons, error) -> () in
            
            // Make sure we are in the main thread when we change the UI
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.iconsViewController?.showIcons( icons )
                self.progressControl.stopAnimation(nil)
                self.progressControl.hidden = true
            })
        }
    }
    
    func imageForIcon(icon: Icon, completionHandler: (image: NSImage?) -> ()) {
        
        nounApiClient.iconImageForURL(icon.previewURL) { (img, error) -> () in
            completionHandler(image:img)
        }
    }
    
}
