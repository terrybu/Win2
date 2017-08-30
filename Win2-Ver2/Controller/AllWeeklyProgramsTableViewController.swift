//
//  AllWeeklyProgramsTableViewController
//  In2-PI-Swift
//
//  Created by Terry Bu on 12/26/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

import UIKit

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
                return 2
            }
            return allWeeklyProgramsArray.count
        }
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let allWeeklyProgramsArray = allWeeklyProgramsArray else {
            let cell = UITableViewCell()
            if indexPath.row == 0 {
                cell.textLabel!.text = "서버 에러나 인터넷 문제로 인해 주보 다운로드가"
            } else {
                cell.textLabel!.text = "작동하지 않고 있습니다."
            }
            return cell
        }
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "AllWeeklyProgramsTableViewCellIdentifier")
        let program = allWeeklyProgramsArray[indexPath.row]
        cell.textLabel?.text = program.title
        cell.accessoryView = UIImageView(image: UIImage(named: "btn_download"))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weeklyProgram = allWeeklyProgramsArray![indexPath.row]
        WeeklyProgramDisplayManager.sharedInstance.displayWeeklyProgramLogic(weeklyProgram, view: view, navController: self.navigationController!, viewController: self)
    }
    
    func homeButtonPressed() {
        let leftDrawer = revealViewController().rearViewController as! LeftNavDrawerController
        let homeNavCtrl = leftDrawer.homeVCNavCtrl
        revealViewController().pushFrontViewController(homeNavCtrl!, animated: true)
    }
    
    
}
