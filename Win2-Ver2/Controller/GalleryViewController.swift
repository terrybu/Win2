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
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.labelText = "Loading..."
        hideViews()
        FacebookPhotoQuery.sharedInstance.getPhotosFromMostRecentThreeAlbums { (error) -> Void in
            
            if (error != nil) {
                print(error?.description)
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            }
        }
        topImageView.layer.shadowColor = UIColor.lightGray.cgColor
        topImageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        topImageView.layer.shadowOpacity = 1
        topImageView.layer.shadowRadius = 5.0
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(GalleryViewController.displayJTSFullScreenViewForImageCurrentlyInTopImgView))
        singleTap.numberOfTapsRequired = 1
        topImageView.isUserInteractionEnabled = true
        topImageView.addGestureRecognizer(singleTap)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(GalleryViewController.processDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.numberOfTouchesRequired = 1
        doubleTapGesture.delaysTouchesBegan = true
        view.addGestureRecognizer(doubleTapGesture)
    }
    
    func processDoubleTap(_ sender: UITapGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.ended) {
            let point = sender.location(in: collectionView)
            let indexPath = collectionView.indexPathForItem(at: point)
            if let indexPath = indexPath  {
                print("\(indexPath.row)")
                self.displayJTSFullScreenViewForImageCurrentlyInTopImgView()
            }
        }
    }
    
    fileprivate func hideViews() {
        topImageView.isHidden = true
        collectionView.isHidden = true
    }
    fileprivate func unhideViews() {
        topImageView.isHidden = false
        collectionView.isHidden = false
    }
    
    //MARK: FacebookPhotoQueryDelegate methods
    func didFinishGettingFacebookPhotos(_ fbPhotoObjectsArray: [FBPhoto]) {
        self.photoObjectsArray = fbPhotoObjectsArray
        let firstObject = photoObjectsArray![0]
        setImgInNormalSizeToTopImageView(firstObject, completion: {
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            self.unhideViews()
        })
        self.collectionView.reloadData()
    }
    
    //MARK: Top Image View related methods
    fileprivate func setImgInNormalSizeToTopImageView(_ fbPhotoObject: FBPhoto, completion: (() -> Void)?) {
        //FacebookManager needs to call a new Graph API request with the object
        MBProgressHUD.showAdded(to: view, animated: true)
        FacebookPhotoQuery.sharedInstance.getNormalSizePhotoURLStringFrom(fbPhotoObject.id
            , completion: { (normImgUrlString) -> Void in
                self.topImageView.setImageWith(URL(string: normImgUrlString )!)
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
        let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.image, backgroundStyle: JTSImageViewControllerBackgroundOptions.scaled)
        imageViewer?.show(from: self, transition: JTSImageViewControllerTransition.fromOriginalPosition)
    }
    
    
    //MARK: UICollectionView delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if (self.photoObjectsArray != nil) {
            return 1
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let photoObjectsArray = self.photoObjectsArray {
            return photoObjectsArray.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! GalleryCell
        
        //this should prevent flickering from happening
        cell.imageView.image = nil
        
        // Configure the cell
        let photoObject = photoObjectsArray![indexPath.row]
        cell.imageView!.setImageWith(URL(string: photoObject.albumSizePicURLString )!)
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? GalleryCell {
            UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                    cell.contentView.layer.borderColor = UIColor.In2DeepPurple().cgColor
                }, completion: nil)
        }
        
        setImgInNormalSizeToTopImageView(photoObjectsArray![indexPath.row], completion:{
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? GalleryCell {
            UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                    cell.contentView.layer.borderColor = UIColor.black.cgColor
                }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
            let screenWidth = view.frame.size.width - 20 //20 for padding
            return CGSize(width: screenWidth/3, height: 120.0)
    }

    deinit {
        print("gallery vc deinit checking")
    }
    
}
