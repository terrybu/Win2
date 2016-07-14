//
//  FacebookPhotoQuery.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/30/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//
import FBSDKLoginKit
import SwiftyJSON

let kGraphPathPIMagazineAlbumsString = "1384548091800506/albums"
let kParamsOnlyAccessToken = [
    "access_token": kAppAccessToken
]

protocol FacebookPhotoQueryDelegate {
    func didFinishGettingFacebookPhotos(fbPhotoObjectsArray: [FBPhoto])
}

class FacebookPhotoQuery: FacebookQuery {
    
    static let sharedInstance = FacebookPhotoQuery()
    var delegate: FacebookPhotoQueryDelegate?
    var FBPhotoObjectsArray = [FBPhoto]()
    func getPhotosFromMostRecentThreeAlbums(completion: ((error: NSError!) -> Void)?) {

        super.getFBDataJSON(kGraphPathPIMagazineAlbumsString, params: kParamsOnlyAccessToken,
            onSuccess: { (jsonData) -> Void in
                let albumsList = jsonData["data"]
                print(albumsList)
                var firstAlbumID = albumsList[0]["id"].stringValue
                var secAlbumID = albumsList[1]["id"].stringValue
                var thirdAlbumID = albumsList[2]["id"].stringValue
                //Checking for "PI 한 줄 나눔" album because it's full of useless photos
                
                let 한줄나눔앨범아이디 = "1552510951670885"
                if firstAlbumID == 한줄나눔앨범아이디 {
                    firstAlbumID = albumsList[3]["id"].stringValue
                } else if secAlbumID == 한줄나눔앨범아이디 {
                    secAlbumID = albumsList[3]["id"].stringValue
                } else if thirdAlbumID == 한줄나눔앨범아이디 {
                    thirdAlbumID = albumsList[3]["id"].stringValue
                }
                
                let params = [
                    "access_token": kAppAccessToken,
                    "fields" : "photos.limit(20){picture}",
                ]
                self.getDataFromFBAlbum(firstAlbumID, params: params, completion: { () -> Void in
                    self.getDataFromFBAlbum(secAlbumID, params: params, completion: { () -> Void in
                        self.getDataFromFBAlbum(thirdAlbumID, params: params, completion: { () -> Void in
                            self.delegate?.didFinishGettingFacebookPhotos(self.FBPhotoObjectsArray)
                        })
                    })
                })
            },
            onError: { (error) -> Void in
                if let completion = completion {
                    completion(error: error)
                }
        })
    }
    
    private func getDataFromFBAlbum(albumID: String, params: [String : String], completion: (() -> Void)?) {
        FBSDKGraphRequest(graphPath: albumID, parameters: params).startWithCompletionHandler { (connection, albumPhotos, error) -> Void in
            //            println(albumPhotos)
            let albumPhotosJSON = JSON(albumPhotos)
            let photos = albumPhotosJSON["photos"]
            let photosArray = photos["data"].arrayValue
            //            println(photosArray.description)
            for object:JSON in photosArray {
                let newPicObject = FBPhoto(id: object["id"].stringValue, albumPicURLString: object["picture"].stringValue)
                self.FBPhotoObjectsArray.append(newPicObject)
            }
            if let completion = completion {
                completion()
            }
        }
    }
    
    func getNormalSizePhotoURLStringFrom(id: String, completion: ((normImgUrlString: String) -> Void)?) -> Void{
        let graphPathString = "\(id)/picture?type=normal&redirect=false"
        super.getFBDataJSON(graphPathString, params: kParamsOnlyAccessToken,
            onSuccess: { (jsonData) -> Void in
              let object = jsonData["data"]
              let url = object["url"]
              if let completion = completion {
                completion(normImgUrlString: url.stringValue)
              }
        },
            onError: { (error: NSError!) -> Void in
                print(error.description)
        })
    }
    
    func getNormalSizePhotoURLStringForCommunicationsFrom(id: String, completion: ((normImgUrlString: String) -> Void)?) -> Void{
        let params = [
            "access_token": kAppAccessToken,
            "fields" : "full_picture"
        ]
        let graphPathString = "\(id)"
        super.getFBDataJSON(graphPathString, params: params,
            onSuccess: { (jsonData) -> Void in
                let url = jsonData["full_picture"]
                if let completion = completion {
                    completion(normImgUrlString: url.stringValue)
                }
            },
            onError: { (error: NSError!) -> Void in
                print(error.description)
        })
    }
    
    
}