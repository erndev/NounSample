//
//  IconGridViewController.swift
//  NounSample
//
//  Created by ERNESTO GARCIA CARRIL on 9/10/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import Cocoa

protocol IconGridViewDelegate {
    
    func imageForIcon( icon:Icon, completionHandler: (image:NSImage?)->() )
}

class IconGridViewController: NSViewController  {
    
    private struct Constants {
        static let IconItemIdentifier = "iconItemIdentifier"
        static let IconViewItemNibName = "IconViewItem"
        static let BaseItemSize = 28
        static let DefaultZoomLevel = 1
    }
    
    private var icons:[Icon]?
    var delegate:IconGridViewDelegate?
    @IBOutlet weak var collectionView:NSCollectionView!
    
    
    var zoom:Int = Constants.DefaultZoomLevel {
        
        didSet{
            setCollectionViewZoomLevel(zoom)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    func setupCollectionView() {
        
        let nib = NSNib(nibNamed: Constants.IconViewItemNibName, bundle: nil)
        collectionView.registerNib(nib, forItemWithIdentifier: Constants.IconItemIdentifier)
        collectionView.delegate = self
        collectionView.registerForDraggedTypes([NSURLPboardType])
        collectionView.setDraggingSourceOperationMask(.None, forLocal: true)
        collectionView.setDraggingSourceOperationMask(.Copy, forLocal: false)
        zoom = Constants.DefaultZoomLevel
    }
    
    func setCollectionViewZoomLevel( level:Int ) {
        let newItemSize = CGFloat((level+1) * Constants.BaseItemSize)
        if let layout = collectionView.collectionViewLayout as? NSCollectionViewFlowLayout {
            layout.itemSize = NSMakeSize(newItemSize, newItemSize)
        }
    }
    
    func showIcons(icons:[Icon]?) {
        self.icons = icons
        collectionView.reloadData()
    }
    
}


//MARK: - Collection View DataSource Extension
extension IconGridViewController: NSCollectionViewDataSource {
    
    func collectionView(collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons?.count ?? 0
    }
    
    func collectionView(collectionView: NSCollectionView, itemForRepresentedObjectAtIndexPath indexPath: NSIndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItemWithIdentifier(Constants.IconItemIdentifier, forIndexPath: indexPath) as! IconViewItem
        item.view.setNeedsDisplayInRect(item.view.bounds)
        if let icon = icons?[indexPath.item] {
            if let iconImage = icon.image {
                item.changeImage(iconImage, animated: false)
            }
            else {
                //performSelector( Selector("loadImageForIcon"), withObject: icon, afterDelay: 2.0)
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
                
                dispatch_after(delayTime, dispatch_get_main_queue(), { () -> Void in
                    self.loadImageForIcon(icon)
                })
                //loadImageForIcon(icon)
            }
        }
        return item
    }
    
    func loadImageForIcon(icon:Icon) {
        
        delegate?.imageForIcon(icon, completionHandler: { (image) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.reloadImage( image , forIcon: icon)
            })
        })
    }
    
    func reloadImage( image:NSImage?, forIcon icon:Icon )
    {
        guard let indexOfIcon = self.icons?.indexOf({
            (arrayIcon:Icon ) -> Bool in
            return icon.previewURL.isEqual(arrayIcon.previewURL)
        })
            else {
                return;
        }
        self.icons?[indexOfIcon].image = image
        if let item = collectionView.itemAtIndex(indexOfIcon) as? IconViewItem {
            item.changeImage(image, animated: true)
        }
        //collectionView.reloadItemsAtIndexPaths(Set([NSIndexPath(forItem: indexOfIcon, inSection: 0)]))
    }
    
}

//MARK: - Collection View Delegate Extension
extension IconGridViewController: NSCollectionViewDelegate {
    
    func writerForItem(item:Int) -> IconWriter? {
        guard let icon = icons?[item] where icon.image != nil else {
            return nil
        }
        return IconWriter(iconName: icon.name, iconImage: icon.image)
    }
    
    //MARK: CollectionView Drag&Drop Source
    func collectionView(collectionView: NSCollectionView, canDragItemsAtIndexes indexes: NSIndexSet, withEvent event: NSEvent) -> Bool {
        guard icons?[indexes.firstIndex].image != nil else
        {
            return false;
        }
        return true;
    }
    
    func collectionView(collectionView: NSCollectionView, pasteboardWriterForItemAtIndexPath indexPath: NSIndexPath) -> NSPasteboardWriting? {
        guard let writer = writerForItem(indexPath.item) else {
            return nil
        }
        guard  writer.writeImageData() == true else  {
            return nil
        }
        return writer.url
    }
    
    func collectionView(collectionView: NSCollectionView, draggingSession session: NSDraggingSession, willBeginAtPoint screenPoint: NSPoint, forItemsAtIndexPaths indexPaths: Set<NSIndexPath>) {
    }
    func collectionView(collectionView: NSCollectionView, draggingSession session: NSDraggingSession, endedAtPoint screenPoint: NSPoint, dragOperation operation: NSDragOperation) {
    }
}



