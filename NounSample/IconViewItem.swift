//
//  IconViewItem.swift
//  NounSample
//
//  Created by ERNESTO GARCIA CARRIL on 9/10/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import Cocoa

class IconViewItem: NSCollectionViewItem {
    
    @IBOutlet weak var placeHolderImageView:NSImageView!
    
    struct Constants {
        static let DefaultAnimationDuration = 0.3
        static let PlaceHolderScaleToValue:CGFloat = 0.3
        static let PlaceHolderOpacityToValue:CGFloat = 0.0
        static let ImageScaleFromValue:CGFloat = 0.2
        static let ImageOpacitFromValue:CGFloat = 0.2
    }
    
    var placeHolderAnimation:CAAnimationGroup = {
        // Animate the placeholder out and the imageView in.
        let minScale  = CATransform3DMakeScale(Constants.PlaceHolderScaleToValue, Constants.PlaceHolderScaleToValue, Constants.PlaceHolderScaleToValue)

        // PlaceHolder: Scale down and fade out
        let plOpacityAnimation = CABasicAnimation(keyPath: "opacity")
        plOpacityAnimation.fromValue = 1.0
        plOpacityAnimation.toValue =  Constants.PlaceHolderOpacityToValue
        
        let plScaleAnimation =  CABasicAnimation(keyPath: "transform")
        plScaleAnimation.fromValue = NSValue(CATransform3D:CATransform3DIdentity)
        plScaleAnimation.toValue = NSValue(CATransform3D:minScale)
        
        let plGroup = CAAnimationGroup()
        plGroup.duration = Constants.DefaultAnimationDuration
        plGroup.animations = [ plOpacityAnimation, plScaleAnimation ]
        plGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return plGroup
    }()
    
    var imageAnimation:CAAnimationGroup  = {
        // Image: Scale up and fade in..
        let minScale  = CATransform3DMakeScale(Constants.ImageScaleFromValue, Constants.ImageScaleFromValue, Constants.ImageScaleFromValue)

        let imageOpacityAnimation = CABasicAnimation(keyPath: "opacity")
        imageOpacityAnimation.fromValue = Constants.ImageOpacitFromValue
        imageOpacityAnimation.toValue = 1.0
        
        let imageScaleAnimation = CABasicAnimation( keyPath: "transform")
        imageScaleAnimation.fromValue = NSValue( CATransform3D: minScale )
        imageScaleAnimation.toValue = NSValue( CATransform3D: CATransform3DIdentity )
        imageScaleAnimation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        
        let imageGroup = CAAnimationGroup()
        imageGroup.duration = Constants.DefaultAnimationDuration
        imageGroup.animations = [imageScaleAnimation, imageOpacityAnimation]
        return imageGroup
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        view.wantsLayer = true
        view.layerContentsRedrawPolicy = .OnSetNeedsDisplay
        
    }
    
    func changeImage( image:NSImage?, animated:Bool ) {
        
        imageView?.image = image
        placeHolderImageView.alphaValue = ( image != nil ) ? 0.0 : 1.0

        if( animated && image != nil ) {
            
            
            // Set layer center / anchor so that the image scales around the center
            let plCenter = NSMakePoint(NSMidX(placeHolderImageView.bounds), NSMidY(placeHolderImageView.bounds))
            placeHolderImageView?.layer?.position = plCenter
            placeHolderImageView.layer?.anchorPoint = NSMakePoint(0.5, 0.5)
            
            let imageCenter = NSMakePoint(NSMidX(imageView!.bounds), NSMidY(imageView!.bounds))
            imageView?.layer?.position = imageCenter
            imageView?.layer?.anchorPoint = NSMakePoint(0.5, 0.5)
            
            // Animate the transition
            placeHolderImageView.layer?.addAnimation(placeHolderAnimation, forKey: nil)
            imageView?.layer?.addAnimation(imageAnimation, forKey: nil)
            
        }
        
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        placeHolderImageView.alphaValue = 1.0
        
    }
    
}
