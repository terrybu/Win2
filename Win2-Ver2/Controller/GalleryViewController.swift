//
//  GalleryViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/29/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit
import SwiftyJSON
import AFNetworking
import JTSImageViewController
import MBProgressHUD

private let cellReuseIdentifier = "GalleryCell"

class GalleryViewController: ParentViewController, FacebookPhotoQueryDelegate, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var topImageView: UIImageView!
    var photoObjectsArray: [FBPhoto]?
    
    override func viewDidLoad() {
        setUpStandardUIForViewControllers()
        FacebookPhotoQuery.sharedInstance.delegate = self
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "Loading..."
        hideViews()
        FacebookPhotoQuery.sharedInstance.getPhotosFromMostRecentThreeAlbums { (error) -> Void in
            
            if (error != nil) {
                print(error.description)
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
        }
        topImageView.layer.shadowColor = UIColor.lightGrayColor().CGColor
        topImageView.layer.shadowOffset = CGSizeMake(2, 2)
        topImageView.layer.shadowOpacity = 1
        topImageView.layer.shadowRadius = 5.0
        let singleTap = UITapGestureRecognizer(target: self, action: Selector("displayJTSFullScreenViewForImageCurrentlyInTopImgView"))
        singleTap.numberOfTapsRequired = 1
        topImageView.userInteractionEnabled = true
        topImageView.addGestureRecognizer(singleTap)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: "processDoubleTap:")
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.numberOfTouchesRequired = 1
        doubleTapGesture.delaysTouchesBegan = true
        view.addGestureRecognizer(doubleTapGesture)
    }
    
    func processDoubleTap(sender: UITapGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.Ended) {
            let point = sender.locationInView(collectionView)
            let indexPath = collectionView.indexPathForItemAtPoint(point)
            if let indexPath = indexPath  {
                print("\(indexPath.row)")
                self.displayJTSFullScreenViewForImageCurrentlyInTopImgView()
            }
        }
    }
    
    private func hideViews() {
        topImageView.hidden = true
        collectionView.hidden = true
    }
    private func unhideViews() {
        topImageView.hidden = false
        collectionView.hidden = false
    }
    
    //MARK: FacebookPhotoQueryDelegate methods
    func didFinishGettingFacebookPhotos(fbPhotoObjectsArray: [FBPhoto]) {
        self.photoObjectsArray = fbPhotoObjectsArray
        let firstObject = photoObjectsArray![0]
        setImgInNormalSizeToTopImageView(firstObject, completion: {
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            self.unhideViews()
        })
        self.collectionView.reloadData()
    }
    
    //MARK: Top Image View related methods
    private func setImgInNormalSizeToTopImageView(fbPhotoObject: FBPhoto, completion: (() -> Void)?) {
        //FacebookManager needs to call a new Graph API request with the object
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        FacebookPhotoQuery.sharedInstance.getNormalSizePhotoURLStringFrom(fbPhotoObject.id
            , completion: { (normImgUrlString) -> Void in
                self.topImageView.setImageWithURL(NSURL(string: normImgUrlString )!)
                if let completion = completion {
                    completion()
                }
        })
    }
    
    func displayJTSFullScreenViewForImageCurrentlyInTopImgView() {
        let imageInfo = JTSImageInfo()
        imageInfo.image = self.topImageView.image
        imageInfo.referenceRect = self.topImageView.frame
        imageInfo.referenceView = self.topImageView.superview
        let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.Image, backgroundStyle: JTSImageViewControllerBackgroundOptions.Scaled)
        imageViewer.showFromViewController(self, transition: JTSImageViewControllerTransition.FromOriginalPosition)
    }
    
    
    //MARK: UICollectionView delegate methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if (self.photoObjectsArray != nil) {
            return 1
        }
        return 0
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let photoObjectsArray = self.photoObjectsArray {
            return photoObjectsArray.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! GalleryCell
        
        //this should prevent flickering from happening
        cell.imageView.image = nil
        
        // Configure the cell
        let photoObject = photoObjectsArray![indexPath.row]
        cell.imageView!.setImageWithURL(NSURL(string: photoObject.albumSizePicURLString )!)
        
        return cell
    }

    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? GalleryCell {
            UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                    cell.contentView.layer.borderColor = UIColor.In2DeepPurple().CGColor
                }, completion: nil)
        }
        
        setImgInNormalSizeToTopImageView(photoObjectsArray![indexPath.row], completion:{
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        })
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? GalleryCell {
            UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                    cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
                }, completion: nil)
        }
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let screenWidth = view.frame.size.width - 20 //20 for padding
            return CGSize(width: screenWidth/3, height: 120.0)
    }

    deinit {
        print("gallery vc deinit checking")
    }
    
}