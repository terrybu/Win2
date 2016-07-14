//
//  WorshipViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/17/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit
import Foundation


class WorshipViewController: ParentViewController, WeeklyProgramDownloaderDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var contentView: UIView!
    @IBOutlet var expandableAboutView: ExpandableAboutView!
    @IBOutlet var worshipVideosClickView: UIView! 
    
    @IBOutlet var songsTableView :     UITableView!
    @IBOutlet var weeklyProgramsTableView :     UITableView!
    var songObjectsArray = [PraiseSong]()
    var praiseSongsListIsEmpty: Bool = false
    var weeklyProgramsArray = [WeeklyProgram]()
    var thisMonthProgramsArray = [WeeklyProgram]()
    var thisMonthProgramsAreEmpty: Bool = false
    var headerTitleStringForPraiseSongsListSection: String?
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    private let kOriginalContentViewHeight: CGFloat = 650
    //Constraints
    @IBOutlet weak var constraintHeightExpandableView: NSLayoutConstraint!
    @IBOutlet weak var constraintContentViewHeight: NSLayoutConstraint!
    var expandedAboutViewHeight:CGFloat = 0 
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        setUpStandardUIForViewControllers()
        setUpExpandableAboutView(kOriginalAboutViewHeight, expandableAboutView: expandableAboutView, heightBuffer: 0, view: view, constraintHeightExpandableView: constraintHeightExpandableView, constraintContentViewHeight: constraintContentViewHeight, originalContentviewHeight: kOriginalContentViewHeight)
        getPraiseSongNamesListAndHeaderFromFacebook()
        weeklyProgramsTableView.hidden = true
        if weeklyProgramsArray.isEmpty {
            indicator.center = CGPointMake(view.center.x, weeklyProgramsTableView.center.y)
            view.addSubview(indicator)
            indicator.startAnimating()
        }
        WeeklyProgramDownloader.sharedInstance.delegate = self
        WeeklyProgramDownloader.sharedInstance.getTenRecentWeeklyProgramsListFromImportIO()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(WorshipViewController.didPressSeeMoreWorshipVideos))
        worshipVideosClickView.userInteractionEnabled = true
        worshipVideosClickView.addGestureRecognizer(tapGesture)
    }
    
    func getPraiseSongNamesListAndHeaderFromFacebook() {
        let feedPostObjects = FacebookFeedQuery.sharedInstance.FBFeedObjectsArray
        for postObject in feedPostObjects {
            praiseSongsListIsEmpty = true
            if postObject.parsedCategory == "PI찬양" {
                if postObject.type == "status" {
                    parseEachLineOfPraiseSongPostBodyMessageToFillSongsArray(postObject.message)
                    headerTitleStringForPraiseSongsListSection = postObject.parsedTitle
                    praiseSongsListIsEmpty = false
                    break
                }
            }
        }
        songsTableView.reloadData()
    }
    
    /**
    This method parses out the message body of a facebook post with category "PI찬양" so that it detects song names and their respective youtube URLs
    
    - parameter postBody: Body message of the post
    */
    private func parseEachLineOfPraiseSongPostBodyMessageToFillSongsArray(postBody: String) {
        var i = 0
        var newSongName = ""
        while i < postBody.characters.count {
            if postBody[i] == "\n" {
                if postBody[i+1] == "\n" {
                    //found a double linebreak
                    let newSongObject = PraiseSong(songTitle: newSongName)
                    var j = i + 2
                    newSongName = ""
                    while postBody[j] != "\n" {
                        newSongName += postBody[j]
                        j += 1
                    }
                    newSongObject.songTitle = newSongName
                    //this is where we can start the logic after we end the first "songtitle" scraping? because j+1 is now the youtube URL
                    var k = j + 1
                    var newYouTubeURL = ""
                    while k < postBody.characters.count && postBody[k] != "\n" {
                        newYouTubeURL += postBody[k]
                        k += 1
                    }
                    newSongObject.songYouTubeURL = newYouTubeURL
                    songObjectsArray.append(newSongObject)
                }
            }
            i += 1
        }
        print(songObjectsArray)
    }
    
    
    //MARK: WeeklyProgramDownloader Delegate methods
    func didFinishDownloadinglistOfTenWeeklyProgramsFromImportIO(downloadedProgramsArray: [WeeklyProgram]?) {
        if let downloadedProgramsArray = downloadedProgramsArray {
            self.weeklyProgramsArray = downloadedProgramsArray
            weeklyProgramsTableView.reloadData()
            indicator.stopAnimating()
            weeklyProgramsTableView.hidden = false
        }
    }
    
    //MARK: UITableViewDataSource Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == weeklyProgramsTableView) {
            let todaysMonth = DateManager.sharedInstance.getTodaysMonth()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM.dd.yyyy"
            for program in weeklyProgramsArray {
                if let dateProgramString = program.dateString {
                    let dateProgramNSDate = dateFormatter.dateFromString(dateProgramString)
                    if let dateProgramNSDate = dateProgramNSDate {
                        print(dateProgramNSDate)
                        let thisProgramDateComponents = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: dateProgramNSDate)
                        if thisProgramDateComponents.month == todaysMonth {
                            print(thisProgramDateComponents)
                            thisMonthProgramsArray.append(program)
                        }
                    }
                }
            }
            if !thisMonthProgramsArray.isEmpty {
                self.thisMonthProgramsAreEmpty = false
                return thisMonthProgramsArray.count
            } else {
                self.thisMonthProgramsAreEmpty = true
                return 2
            }
        } else if (tableView == songsTableView) {
            if praiseSongsListIsEmpty {
                return 2
            } else {
                return songObjectsArray.count
            }
        }
        return 0
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        cell = UITableViewCell()
        if (tableView == weeklyProgramsTableView) {
            if thisMonthProgramsAreEmpty {
                cell.textLabel?.font = UIFont.systemFontOfSize(13.0)
                if indexPath.row == 0 {
                    cell.textLabel!.text = "이번 달의 주보는 아직 업로드되지 않았습니다."
                } else {
                    cell.textLabel!.text = "지난 달의 주보는 '더보기'를 참고해주세요"
                }
            } else {
                let program = thisMonthProgramsArray[indexPath.row]
                cell.textLabel!.text = program.title
                cell.accessoryView = UIImageView(image: UIImage(named: "btn_download"))
            }
        } else {
            if praiseSongsListIsEmpty {
                cell.textLabel?.font = UIFont.systemFontOfSize(14.0)
                if indexPath.row == 0 {
                    cell.textLabel!.text = "최근에 찬양송 리스트가 업데이트되지 않았거나"
                } else {
                    cell.textLabel!.text = "인터넷 연결이 실패하였습니다."
                }
            } else {
                let songObject = songObjectsArray[indexPath.row]
                cell.textLabel!.text = songObject.songTitle!
            }
        }
        return cell
    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        headerView.backgroundColor = UIColor.whiteColor()
        var label: UILabel
        if (tableView == weeklyProgramsTableView) {
            label = UILabel(frame: CGRectMake(12, 5, tableView.frame.size.width * 0.75, 18))
            label.text = getTodaysMonthStringForWeeklyProgramsTableView()
            
            //"See more arrow button" to the right of section header
            let button = UIButton(type: UIButtonType.Custom)
            button.frame = CGRectMake(tableView.frame.size.width - 70, 5, 50, 20)
            button.setTitle("더보기", forState: UIControlState.Normal)
            button.titleLabel!.font = UIFont.boldSystemFontOfSize(16)
            button.setTitleColor(UIColor.In2DeepPurple(), forState: UIControlState.Normal)
            button.addTarget(self, action: "seeMoreArrowWasPressedForWeeklyProgramsTableView", forControlEvents: UIControlEvents.TouchUpInside)
            headerView.addSubview(button)
            //This is the same function as "더보기" just to the right of the text.
            let moreArrowButton = UIButton(type: UIButtonType.Custom)
            moreArrowButton.frame = CGRectMake(tableView.frame.size.width-30, 5, 30, 20)
            moreArrowButton.setImage(UIImage(named: "btn_more_B"), forState: .Normal)
            moreArrowButton.addTarget(self, action: "seeMoreArrowWasPressedForWeeklyProgramsTableView", forControlEvents: UIControlEvents.TouchUpInside)
            headerView.addSubview(moreArrowButton)
        } else {
            label = UILabel(frame: CGRectMake(12, 5, 300, 18))
            if let headerTitle = headerTitleStringForPraiseSongsListSection {
                label.text = headerTitle
            } else {
                //something went wrong so Praise Songs List not appearing at all
                //Two reasons: internet failure or Facebook query json data failed to retrieve Praise Songs Data in its recent 20 objects 
                label.text = "찬양송 리스트가 작동하지 않고 있습니다."
                headerView.backgroundColor = UIColor.grayColor()
                label.textColor = UIColor.whiteColor()
            }
        }
        label.font = UIFont.boldSystemFontOfSize(17)
        headerView.addSubview(label)
        
        return headerView
    }
    
    
    
    //Display today's month as title string fit for tableview top
    func getTodaysMonthStringForWeeklyProgramsTableView() -> String {
        let todaysMonthInt = DateManager.sharedInstance.getTodaysMonth()
        let todaysYearInt = DateManager.sharedInstance.getTodaysYear()
        let dateFormatter = NSDateFormatter()
        let monthNames = dateFormatter.standaloneMonthSymbols
        let monthName = monthNames[todaysMonthInt-1]
        return "\(monthName) \(todaysYearInt) 주보 보기"
    }
    
    func seeMoreArrowWasPressedForWeeklyProgramsTableView() {
        print("seeMoreArrowWasPressed")
        performSegueWithIdentifier("AllWeeklyProgramsTableViewControllerSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AllWeeklyProgramsTableViewControllerSegue" {
            let programsVC = segue.destinationViewController as! AllWeeklyProgramsTableViewController
            programsVC.allWeeklyProgramsArray = self.weeklyProgramsArray
        }
        self.navigationItem.backBarButtonItem?.title = ""
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == weeklyProgramsTableView {
            if thisMonthProgramsAreEmpty {
                return
            } else {
                let weeklyProgram = thisMonthProgramsArray[indexPath.row]
                WeeklyProgramDisplayManager.sharedInstance.displayWeeklyProgramLogic(weeklyProgram, view: self.view, navController: self.navigationController!, viewController: self)
            }
        }
        else if tableView == songsTableView {
            let songObject = songObjectsArray[indexPath.row]
            if let songURLString = songObject.songYouTubeURL {
                let trimSpacesFromURLString = songURLString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                let url = NSURL(string: trimSpacesFromURLString)
                if let url = url {
                    presentSFSafariVCIfAvailable(url)
                }
            }
        }
    }

    //MARK: IBActions
    @IBAction func didPressSeeMoreWorshipVideos() {
        presentSFSafariVCIfAvailable(NSURL(string: kYoutubeIn2WorshipVideosURL)!)
    }
    
    @IBAction func didPressApplyButtonForWorshipTeam() {
        presentSFSafariVCIfAvailable(NSURL(string: kApplyWorshipTeamGoogleDocURL)!)
    }
    
}
