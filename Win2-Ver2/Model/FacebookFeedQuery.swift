//
//  FacebookFeedQuery.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 9/2/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//
import FBSDKLoginKit
import SwiftyJSON

private let kGraphPathPIMagazineFeedString = "1384548091800506/feed"

protocol FacebookFeedQueryDelegate {
    func didFinishGettingFacebookFeedData(fbFeedObjectsArray: [FBFeedPost])
}

class FacebookFeedQuery: FacebookQuery {
    
    static let sharedInstance = FacebookFeedQuery()
    var delegate: FacebookFeedQueryDelegate?
    var FBFeedObjectsArray = [FBFeedPost]()
    
    func getFeedFromPIMagazine(errorCompletionBlock: ((error: NSError!) -> Void)? ) {
        let params = [
            "access_token": kAppAccessToken,
            "fields": "type, message, created_time"
        ]
        super.getFBDataJSON(kGraphPathPIMagazineFeedString,
            params: params,
            onSuccess: { (feedJSON) -> Void in
                let feedObjectArray = feedJSON["data"].arrayValue
//                print(feedObjectArray)
                for object:JSON in feedObjectArray {
                    let newFeedObject = FBFeedPost(
                        id: object["id"].stringValue,
                        message: object["message"].stringValue,
                        created_time: object["created_time"].stringValue,
                        type: object["type"].stringValue
                    )
                    self.parseTitleCategoryDateForFeedArticle(newFeedObject)
                    self.FBFeedObjectsArray.append(newFeedObject)
                }
            self.delegate?.didFinishGettingFacebookFeedData(self.FBFeedObjectsArray)
        }, onError: { (error) -> Void in
            if let errorCompletion = errorCompletionBlock {
                errorCompletion(error: error)
            }
        })
    }
    
    private func parseTitleCategoryDateForFeedArticle(newFeedArticleObject: FBFeedPost) {
        var categoryStr = ""
        var firstTitleStr = ""
        let msg = newFeedArticleObject.message
        if (!msg.isEmpty) {
            if (msg[0] == "[") {
                for (var i=1; i < msg.characters.count; i++) {
                    categoryStr += msg[i]
                    let j = i + 1
                    if (msg[j] == "]" || categoryStr.characters.count >= 100) {
                        if msg[j..<msg.characters.count].characters.count > 0 {
                            let titleStringSegment = msg[j..<msg.characters.count-1]
                            firstTitleStr = parseFirstLineTitleString(titleStringSegment)
                        }
                        break
                    }
                }
            } else {
                categoryStr = "Misc."
                for (var i=0; i < msg.characters.count; i++) {
                    firstTitleStr += msg[i]
                    if firstTitleStr.characters.count > 100 {
                        break
                    }
                }
            }
        } else {
            categoryStr = "Misc."
            firstTitleStr = "No Title"
        }
        newFeedArticleObject.parsedCategory = categoryStr
        newFeedArticleObject.parsedTitle = firstTitleStr
        newFeedArticleObject.parsedDate = CustomDateFormatter.sharedInstance.convertFBCreatedTimeDateToOurFormattedString(newFeedArticleObject)
    }
    
    /**
    This method basically looks at the Facebook post body where [Category] FirstLineTitle
    Sometimes, PI communications team posts it in different formats so it's hard addressing the edge cases. Must collaborate with them properly to maintain the format.
    
    - parameter facebookPostMessageBodyWithoutCategoryBracket:
    
    - returns: Returns a short string that represents the Title fo that Facebook article view
    */
    private func parseFirstLineTitleString(facebookPostMessageBodyWithoutCategoryBracket: String) -> String {
        //Given a string that starts with an empty space and then a sententece followed by \n or just \n Title \n ... return thet title.
        // " blahblahblah \n" --> should return blahblahblah
        // " \n blahblahblah \n" should also return blahblahblah
        var result = ""
        let startingStr = facebookPostMessageBodyWithoutCategoryBracket[1..<facebookPostMessageBodyWithoutCategoryBracket.characters.count]
        if (startingStr[0] == "\n" || startingStr[1] == "\n") {
            //if it finds \n immediately (which means author inserted a new line between category and title, we jump that index, and start from the following character
            //this covers case where "[title] \n fjpsadfjdpsfapjf \n "
            var i = 1
            if (startingStr[1] == "\n") {
                i = 2
            }
            while (startingStr[i] != "\n") {
                result += startingStr[i]
                i++
                //this loop was crashing the app when param string was
                //[PI공지]
                // 땡스기빙 당일인 이번주 목요일(11/26)에는 미드타운 40가 파리파게트와 아스토리아의 홀리스타가 없음을 알려드립니다.
                //***Somehow that was causing /n/n at the first part of the string and then no more /n throughout the rest of the string 
                if i >= startingStr.characters.count {
                    break
                }
            }
            //to address the case of "[title] \n   \n adsfsd" (where writer used two lines after title)
            let trimmedString = result.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            //in that above case, it will be completely full of whitespaces because it jumped the first \n and then stopped before that second \n ... so in that case, trimmed string will return "" 
            if trimmedString == "" {
                i += 1
                result = ""
                while (startingStr[i] != "\n" && i < 75) {
                    result += startingStr[i]
                    i++
                }
            }
        }
        else {
            //otherwise, we go right for the first line
            //this covers case where "[title] asjdfsafp \n"
            var i = 0;
            let count = startingStr.characters.count
            while i <= count - 1 && startingStr[i] != "\n" {
                result += startingStr[i]
                i++
            }
        }
        return result
    }
    
    func retrieveFacebookPostDirectURLString(feedObject: FBFeedPost) -> String{
        let postURLParam = feedObject.id.componentsSeparatedByString("_").last
        let postURL = "\(kFacebookPageURL)\(postURLParam!)"
        return postURL
    }
    
    func displayFacebookPostObjectInWebView(feedObject: FBFeedPost, view: UIView, navigationController: UINavigationController?) {
        let postURLString = FacebookFeedQuery.sharedInstance.retrieveFacebookPostDirectURLString(feedObject)
        let wkWebView = UIWebView(frame: view.frame)
        wkWebView.loadRequest(NSURLRequest(URL: NSURL(string: postURLString)!))
        let emptyVC = UIViewController()
        emptyVC.view = wkWebView
        navigationController?.pushViewController(emptyVC, animated: true)
    }
    
}