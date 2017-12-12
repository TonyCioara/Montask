//
//  FriendsViewController.swift
//  Montask
//
//  Created by Sunny Ouyang on 11/11/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import UIKit
import KeychainSwift
import Kingfisher



class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, friendRequestCellDelegate, friendCellDelegate {
    
    
   
  
    var friendUsers: [User] = []
    var friendRequests: [Request] = []
    let keychain = KeychainSwift()
    var basicAuthToken: String!
    let dispatch = DispatchGroup()

    @IBOutlet weak var friendsTableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.basicAuthToken = keychain.get("basicToken")
        getFriends(token: basicAuthToken!) {
            DispatchQueue.main.async {
                self.friendsTableView.reloadData()
            }
        }
        getFriendRequests(token: basicAuthToken!) {
            print("loaded")
        }
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func acceptedRequest(index: IndexPath) {
        //either way, we want to delete the selected request, and remove it from the user's request array.
        self.addFriend(token: self.basicAuthToken, userEmail: self.friendRequests[index.row].sender) {
            self.getFriends(token: self.basicAuthToken, completion: {
                DispatchQueue.main.async {
                    self.friendsTableView.reloadData()
                }
            })
        }
        
    }
    
    func rejectedRequest(index: IndexPath) {
        
        self.deleteFriendRequest(token: self.basicAuthToken, sender: self.friendRequests[index.row].sender) {
            self.friendRequests.remove(at: index.row)
            DispatchQueue.main.async {
                self.friendsTableView.reloadData()
            }
        }
    }
    
    func sendIndex(index: IndexPath) {
        print("set global user to send to battle scene")
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.friendRequests.count
        } else {
            return self.friendUsers.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = self.friendsTableView.dequeueReusableCell(withIdentifier: "friendRequestCell") as! FriendRequestTableViewCell
            cell.friendRequestLabel.text = "\(self.friendRequests[indexPath.row].sender) would like to add you as a friend"
            cell.delegate = self
            cell.index = indexPath
            
            return cell
        } else {
            let cell = self.friendsTableView.dequeueReusableCell(withIdentifier: "friendCell") as! FriendsTableViewCell
            cell.delegate = self
            cell.index = indexPath
            cell.usernameLabel.text = self.friendUsers[indexPath.row].username
            let monsterImageURL1 =  self.friendUsers[indexPath.row].monsters[0].imageUrl
            cell.monster1Image.image = UIImage(named: monsterImageURL1)
            
            
            let monsterImageURL2 =  self.friendUsers[indexPath.row].monsters[1].imageUrl
            cell.monster2Image.image = UIImage(named: monsterImageURL2)
            
            
            let monsterImageURL3 = self.friendUsers[indexPath.row].monsters[2].imageUrl
            cell.monster3Image.image = UIImage(named: monsterImageURL3)
            return cell
        }
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toFriendPersonalVC", sender: self)
    }
    
    @IBAction func unwindToFriendsVC(segue:UIStoryboardSegue) { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toFriendPersonalVC" {
                let indexPath = self.friendsTableView.indexPathForSelectedRow
                let selectedFriend = self.friendUsers[(indexPath?.row)!]
                let friendPersonalVC = segue.destination as! PersonalViewController
                friendPersonalVC.user = selectedFriend
                friendPersonalVC.friendsView = true
            }
        }
    }
    
   
    
}

extension FriendsViewController {
    

    
    func deleteFriendRequest(token: String, sender: String, completion: @escaping () -> ()) {
        Network.instance.fetch(route: Route.patchUserRequests(senderName: sender), token: token) { (data) in
            print("request deleted")
            completion()
        }
    }
    func addFriend(token: String, userEmail: String, completion: @escaping ()->()) {
        Network.instance.fetch(route: Route.addFriend(userEmail: userEmail), token: token) { (data) in
            let jsonRequests = try? JSONDecoder().decode([Request].self, from: data)
            if let requests = jsonRequests {
                self.friendRequests = requests
                completion()
            }
        }
    }
    
    func getFriends(token: String, completion: @escaping () -> ()) {
        Network.instance.fetch(route: Route.getFriends, token: token) { (data) in
            let jsonFriends = try? JSONDecoder().decode([User].self, from: data)
            if let friends = jsonFriends { 
                self.friendUsers = friends
                completion()
            }
        }
    }
    
    func getFriendRequests(token: String, completion: @escaping ()->()) {
        Network.instance.fetch(route: Route.getFriendRequests, token: token) { (data) in
            let jsonRequests = try? JSONDecoder().decode([Request].self, from: data)
            if let requests = jsonRequests {
                self.friendRequests = requests
                DispatchQueue.main.async {
                    self.friendsTableView.reloadData()
                }
                
            }
        }
    }
    
}
