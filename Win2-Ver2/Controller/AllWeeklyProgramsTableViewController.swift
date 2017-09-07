//
//  AllWeeklyProgramsTableViewController
//  In2-PI-Swift
//
//  Created by Terry Bu on 12/26/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

import UIKit
import WebKit

class AllWeeklyProgramsTableViewController: UITableViewController {

    var allWeeklyProgramsArray: [WeeklyProgram]?
    
    override func viewDidLoad() {
        self.title = "주보 보기"
        let homeButton = UIBarButtonItem(image: UIImage(named: "home"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(AllWeeklyProgramsTableViewController.homeButtonPressed))
        navigationItem.rightBarButtonItem = homeButton
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let allWeeklyProgramsArray = allWeeklyProgramsArray {
            if allWeeklyProgramsArray.count == 0 {
                return 4
            }
            return allWeeklyProgramsArray.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let allWeeklyProgramsArray = allWeeklyProgramsArray else {
            return getErrorCellsForTwoRows(indexPath: indexPath)
        }
        if allWeeklyProgramsArray.isEmpty {
            return getErrorCellsForTwoRows(indexPath: indexPath)
        }
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "AllWeeklyProgramsTableViewCellIdentifier")
        let program = allWeeklyProgramsArray[indexPath.row]
        cell.textLabel?.text = program.title
        cell.accessoryView = UIImageView(image: UIImage(named: "btn_download"))
        return cell
    }
    
    private func getErrorCellsForTwoRows(indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.row == 0 {
            cell.textLabel!.text = "서버 에러나 인터넷 문제로 인해"
        } else if indexPath.row == 1 {
            cell.textLabel!.text = "작동하지 않고 있습니다."
        } else if indexPath.row == 2 {
            cell.textLabel!.text = "2017년 9월 3일 주보"
        } else {
            cell.textLabel!.text = "2017년 8월 27일 주보"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let allWeeklyProgramsArray = allWeeklyProgramsArray {
            if allWeeklyProgramsArray.isEmpty {
                if indexPath.row == 2 {
                    displayPDFInWebView(fileName: "SeptemberJoobo")
                } else if indexPath.row == 3 {
                    displayPDFInWebView(fileName: "AugustJoobo")
                }
            } else {
                let weeklyProgram = allWeeklyProgramsArray[indexPath.row]
                WeeklyProgramDisplayManager.sharedInstance.displayWeeklyProgramLogic(weeklyProgram, view: view, navController: self.navigationController!, viewController: self)
            }
        }
    }
    
    func homeButtonPressed() {
        let leftDrawer = revealViewController().rearViewController as! LeftNavDrawerController
        let homeNavCtrl = leftDrawer.homeVCNavCtrl
        revealViewController().pushFrontViewController(homeNavCtrl!, animated: true)
    }
    
   func displayPDFInWebView(fileName: String) {
        if let pdfURL = Bundle.main.url(forResource: fileName, withExtension: "pdf", subdirectory: nil, localization: nil)  {
            do {
                let data = try Data(contentsOf: pdfURL)
                let webView = WKWebView(frame: view.frame)
                webView.load(data, mimeType: "application/pdf", characterEncodingName:"", baseURL: pdfURL.deletingLastPathComponent())
                let vc = UIViewController()
                vc.view = webView
                self.navigationController?.pushViewController(vc, animated: true)
            }
            catch {
                //
            }
        }
    }
    
}
