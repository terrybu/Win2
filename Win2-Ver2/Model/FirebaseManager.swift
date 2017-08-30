//
//  FirebaseManager.swift
//  
//
//  Created by Terry Bu on 2/7/16.
//
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

class FirebaseManager {
    
    static let sharedManager = FirebaseManager()
    var rootRef = Database.database().reference()
    var noticesArray: [Notice]?
    var activeNotice: Notice?
    var eventsArray: [SocialServiceEvent]?

    func loginUser(_ email: String, password: String, completion: @escaping ((_ success: Bool) -> Void)) {
        Auth.auth().signInAnonymously() { (user, error) in
                if error != nil {
                    // There was an error logging in to this account
                    print(error)
                    completion(false)
                } else {
                    // Authentication just completed successfully :)
                    // The logged in user's unique identifier
                    print ("Signed in with uid:", user!.uid)
                    completion(true)
                }
        }
    }
    
    func createUser(_ email: String, password: String, firstName: String, lastName: String, birthdayString: String?, completion: @escaping ((_ success:Bool, _ error: NSError?) -> Void)) {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    // There was an error creating the account
                    print(error)
                    completion(false, error as! NSError)
                } else {
                    let uid = user?.uid
                    print("Successfully created user account with uid: \(uid)")
                    completion(true, nil)
                    // Create a new user dictionary accessing the user's info
                    // provided by the authData parameter
                    var newUser = [
                        "firstName": firstName,
                        "lastName": lastName,
                    ]
                    if let birthdayString = birthdayString {
                        newUser["birthday"] = birthdayString
                    }
                    // Create a child path with a key set to the uid underneath the "users" node
                    // This creates a URL path like the following:
                    //  - https://<YOUR-FIREBASE-APP>.firebaseio.com/Users/<uid>
                    self.rootRef.child("Users").child(user!.uid).setValue(newUser)
                    //Because Firebase signup does not AUTHENTICAT the user, must fire login again
                    self.loginUser(email, password: password, completion: { (success) -> Void in
                        //completion block
                    })
                }

            })
    }

    //MARK: writing to firebase
    
    func createNewNoticeOnFirebase(_ notice: Notice, completion: @escaping (_ success: Bool)->Void) {
        let noticesRef = rootRef.child("Notices")
        let noticeDict = [
            "title": notice.title,
            "body": notice.body,
            "link": notice.link,
            "date": notice.date,
            "active": 0
        ] as [String : Any]
        let newNoticeIDRef = noticesRef.childByAutoId()
        newNoticeIDRef.setValue(noticeDict) { (error, firebase) -> Void in
            if error != nil {
                print(error)
                completion(false)
            } else {
                print("new notice created")
                completion(true)
            }
        }
    }
    func createNewSocialServiceEventOnFirebase(_ serviceEvent: SocialServiceEvent, completion: @escaping (_ success: Bool)->Void) {
        let eventsRef = rootRef.child(byAppendingPath: "SocialServiceEvents")
        let eventDict = [
            "title": serviceEvent.title,
            "teamName": serviceEvent.teamName,
            "description": serviceEvent.description,
            "date": serviceEvent.date,
        ]
        let newEventIDRef = eventsRef.childByAutoId()
        newEventIDRef.setValue(eventDict) { (error, firebase) -> Void in
            if error != nil {
                print(error)
                completion(false)
            } else {
                print("new social service event created")
                completion(true)
            }
        }
    }
    
    
    //MARK: Getting data from Firebase
    func getNoticeObjectsFromFirebase(_ completion: @escaping (_ success: Bool)->Void) {
        // Get a reference to our posts
        let ref = rootRef.child(byAppendingPath: "Notices")
        // Attach a closure to read the data at our posts reference
        ref.observe(.value, with: { snapshot in
            print(snapshot.value)
            if let snapshotDict = snapshot.value as? NSDictionary {
                self.noticesArray = []
                for noticeObjectKey in snapshotDict.allKeys {
                    //looping through all hashes
                    print(noticeObjectKey)
                    if let noticeDictionary = snapshotDict.object(forKey: noticeObjectKey) as? NSDictionary {
                        // get dictionary for individual record for specific hash
                        let title = noticeDictionary.object(forKey: "title") as! String
                        let body = noticeDictionary.object(forKey: "body") as! String
                        let link = noticeDictionary.object(forKey: "link") as! String
                        let date = noticeDictionary.object(forKey: "date") as! String
                        let active = noticeDictionary.object(forKey: "active") as! NSNumber
                        let notice = Notice(title: title, body: body, link: link, date: date)
                        notice.active = active.boolValue
                        notice.firebaseID = noticeObjectKey as? String
                        self.noticesArray!.append(notice)
                        if notice.active {
                            print(notice)
                            print("found active notice")
                            self.activeNotice = notice
                        }
                    }
                }
                completion(true)
            }
            }, withCancel: { error in
                print(error)
                completion(false)
        })
    }
    
    func getServiceEventObjectsFromFirebase(_ completion: @escaping (_ success: Bool)->Void) {
        // Get a reference to our posts
        let ref = rootRef.child(byAppendingPath: "SocialServiceEvents")
        // Attach a closure to read the data at our posts reference
        ref.observe(.value, with: { snapshot in
            if let snapshotDict = snapshot.value as? NSDictionary {
                self.eventsArray = []
                for eventObjectKey in snapshotDict.allKeys {
                    //looping through all hashes
                    if let eventDict = snapshotDict.object(forKey: eventObjectKey) as? NSDictionary {
                        // get dictionary for individual record for specific hash
                        let title = eventDict.object(forKey: "title") as! String
                        let team = eventDict.object(forKey: "teamName") as! String
                        let descr = eventDict.object(forKey: "description") as! String
                        let date = eventDict.object(forKey: "date") as! String
                        let event = SocialServiceEvent(title: title, teamName: team, description: descr, date: date)
                        event.firebaseID = eventObjectKey as? String
                        self.eventsArray?.append(event)
                    }
                }
                completion(true)
            }
            }, withCancel: { error in
                completion(false)
        })
    }

    
    //MARK: Updating
    func updateNoticeObjectActiveFlag(_ notice: Notice, completion: ((_ success: Bool) -> Void)?) {
        let noticeRef = rootRef.child(byAppendingPath: "Notices").child(byAppendingPath: notice.firebaseID!)
        noticeRef.updateChildValues(["active" : notice.active], withCompletionBlock: { error, firebaseRef in
            if error == nil {
                print("updating child values completed \(firebaseRef.key)")
                if let completion = completion {
                  completion(true)
                }
            } else {
                print(error)
                if let completion = completion {
                    completion(false)
                }
            }
        })
    }
    
    //MARK: Deleting
    func deleteNotice(_ notice: Notice, completion: ((_ success: Bool) -> Void)?) {
        let noticeRef = rootRef.child(byAppendingPath: "Notices").child(byAppendingPath: notice.firebaseID!)
        noticeRef.removeValue { error, firebaseRef in
            if error == nil {
                if let completion = completion {
                    completion(true)
                }
            } else {
                print(error)
                if let completion = completion {
                    completion(false)
                }
            }
        }
    }
    
    func deleteEvent(_ event: SocialServiceEvent, completion: ((_ success: Bool) -> Void)?) {
        let noticeRef = rootRef.child(byAppendingPath: "SocialServiceEvents").child(byAppendingPath: event.firebaseID!)
        noticeRef.removeValue { error, firebaseRef in
            if error == nil {
                if let completion = completion {
                    completion(true)
                }
            } else {
                print(error)
                if let completion = completion {
                    completion(false)
                }
            }
        }
    }

}

