//
//  NoticeAdminViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 2/7/16.
//  Copyright © 2016 Terry Bu. All rights reserved.
//

import UIKit

class NoticeAdminViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView! 
    var savedNoticesArray: [Notice]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "공지사항"
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(NoticeAdminViewController.addNotice))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.center = CGPoint(x: view.center.x, y: 100)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        FirebaseManager.sharedManager.getNoticeObjectsFromFirebase({
            (success) -> Void in
            if (success) {
                self.savedNoticesArray = FirebaseManager.sharedManager.noticesArray
                self.tableView.reloadData()
            }
            activityIndicator.stopAnimating()
        })
    }
    
    func addNotice() {
        print("add notice button pressed")
        let noticeCreationVC = NoticeCreationViewController()
        self.navigationController?.pushViewController(noticeCreationVC, animated: true)
    }
    
    //MARK: TableViewDataSource Protocol Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        if let savedNoticesArray = savedNoticesArray {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let savedNoticesArray = savedNoticesArray {
            return savedNoticesArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: nil)
        let notice = savedNoticesArray![indexPath.row]
        cell.textLabel!.text = notice.title
        cell.detailTextLabel!.text = notice.date
        if notice.active == true {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    //MARK: TableViewDelegate Protocol Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let cell = tableView.cellForRow(at: indexPath) {
            for notice in savedNoticesArray! {
                if notice.active {
                    notice.active = false
                    FirebaseManager.sharedManager.updateNoticeObjectActiveFlag(notice, completion: nil)
                }
            }
            let thisNotice = savedNoticesArray![indexPath.row]
            thisNotice.active = true
            FirebaseManager.sharedManager.updateNoticeObjectActiveFlag(thisNotice, completion: { (success) -> Void in
                tableView.reloadData()
                UIAlertController.presentAlert(self, alertTitle: thisNotice.title, alertMessage: "\(thisNotice.body) \(thisNotice.link)", confirmTitle: "OK")
            })
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let notice = savedNoticesArray![indexPath.row]
            FirebaseManager.sharedManager.deleteNotice(notice, completion: nil)
            self.savedNoticesArray?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
