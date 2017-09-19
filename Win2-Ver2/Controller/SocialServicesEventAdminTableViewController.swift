//
//  SocialServicesEventAdminTableViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 2/7/16.
//  Copyright © 2016 Terry Bu. All rights reserved.
//

import UIKit

class SocialServicesEventAdminTableViewController: UITableViewController {
    
    var eventsArray: [SocialServiceEvent]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "긍휼부 스케줄"
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(SocialServicesEventAdminTableViewController.addSocialServiceEvent))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.center = CGPoint(x: view.center.x, y: 100)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        FirebaseManager.sharedManager.getServiceEventObjectsFromFirebase({
            (success) -> Void in
            if (success) {
                self.eventsArray = FirebaseManager.sharedManager.eventsArray
                self.tableView.reloadData()
            }
            activityIndicator.stopAnimating()
        })
    }
    
    func addSocialServiceEvent() {
        print("new vc to add social service")
        let socialServiceEventCreationVC = SocialServicesEventCreationViewController()
        self.navigationController?.pushViewController(socialServiceEventCreationVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let eventsArray = eventsArray {
            return eventsArray.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "reuse")

        let event = eventsArray![indexPath.row]
        cell.textLabel!.text = event.title
        cell.detailTextLabel!.text = event.date

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = eventsArray![indexPath.row]
        UIAlertController.presentAlert(self, alertTitle: event.title, alertMessage: "날짜: \(event.date) \n\n Team: \(event.teamName) \n \(event.description)", confirmTitle: "OK")
    }


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let event = eventsArray![indexPath.row]
            FirebaseManager.sharedManager.deleteEvent(event, completion: nil)
            self.eventsArray?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        }
    }

    
}
