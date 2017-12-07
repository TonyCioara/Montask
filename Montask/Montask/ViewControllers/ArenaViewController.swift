//
//  ArenaViewController.swift
//  Montask
//
//  Created by Sunny Ouyang on 12/6/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import UIKit
import KeychainSwift

class ArenaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ArenaCellDelegate {
    
    
    
    
    @IBOutlet weak var arenaTableView: UITableView!
    var currentUser: User!
    var allUsers: [User] = []
    var tableDataUsers: [User] = []
    let keyChain = KeychainSwift()
    var basicAuthToken: String!
    var botMonsterToSend: Monster?
    var playerMonsterToSend: Monster?
    
    override func viewDidLoad() {
        let firstQueue = DispatchQueue(label: "queue1", qos: .userInitiated)
        super.viewDidLoad()
        self.basicAuthToken = keyChain.get("basicToken")
        
       
        getCurrentUser {
            self.getArenaUsers(){
                self.getNextArenaUsers(index: 0)
            }
        }
        
       
    }
    
    func sendIndex(index: IndexPath) {
        print("set global user's strongest monster to send to battle scene")
        let botUser = self.tableDataUsers[index.row]
        self.botMonsterToSend = getTopMonster(monsters: botUser.monsters)
        let playerUser = User.sharedInstance
        self.playerMonsterToSend = getTopMonster(monsters: playerUser.monsters)
        self.performSegue(withIdentifier: "toGameVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toGameVC" {
                let gameVC = segue.destination as! GameViewController
                gameVC.monster1 = playerMonsterToSend
                gameVC.monster2 = botMonsterToSend
            }
        }
    }

    @IBAction func nextButtonTapped(_ sender: Any) {
        let tableDataLastIndex = self.tableDataUsers.count - 1
        let allArenaUserIndex = matchIndex(index: tableDataLastIndex)
        getNextArenaUsers(index: allArenaUserIndex)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableDataUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.arenaTableView.dequeueReusableCell(withIdentifier: "arenaCell") as! ArenaTableViewCell
        cell.indexPath = indexPath
        cell.delegate = self
        cell.usernameLabel.text = self.tableDataUsers[indexPath.row].email
        let monster1URL = URL(string: self.tableDataUsers[indexPath.row].monsters[0].imageUrl)
        let monster2URL = URL(string: self.tableDataUsers[indexPath.row].monsters[1].imageUrl)
        let monster3URL = URL(string: self.tableDataUsers[indexPath.row].monsters[2].imageUrl)
        cell.monsterImage1.kf.setImage(with: monster1URL)
        cell.monsterImage2.kf.setImage(with: monster2URL)
        cell.monsterImage3.kf.setImage(with: monster3URL)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

}


extension ArenaViewController {
    
    //get strongest monster for current User
    func getTopMonster(monsters: [Monster]) -> Monster {
        
        let sortedMonsters = monsters.sorted(by: { $0.power > $1.power})
        var topMonster: Monster = sortedMonsters[0]
        
        return topMonster
    }
    
    //matchIndex
    func matchIndex(index: Int) -> Int {
        let selectedUser = self.tableDataUsers[index]
        for x in self.allUsers {
            if x.username == selectedUser.username {
                let index = self.allUsers.index(where: { (item) -> Bool in
                    item.username == x.username
                })
                return index!
            }
        }
        fatalError("match not working")
    }
    
    //LastArenaUsers
    func getLastArenaUsers(index: Int) {
        var arenaUsers: [User] = []
        for x in (0..<15).reversed() {
            let selectedUser = self.allUsers[x+index]
            arenaUsers.append(selectedUser)
        }
        self.tableDataUsers = arenaUsers
    }
    
    //NextArenaUsers
    func getNextArenaUsers(index: Int) {
        var arenaUsers: [User] = []
        for x in 0..<15 {
            let selectedUser = self.allUsers[x+index]
            arenaUsers.append(selectedUser)
            if selectedUser.username == self.allUsers[self.allUsers.count - 1].username {
                break
            }
        }
        self.tableDataUsers = arenaUsers
        DispatchQueue.main.async {
            self.arenaTableView.reloadData()
        }
        
    }
    
    //I use the current user to get the level to match with the matching arena users
    func getCurrentUser(completion: @escaping ()->()) {
        Network.instance.fetch(route: Route.getUser, token: self.basicAuthToken) { (data) in
            let jsonUser = try? JSONDecoder().decode(User.self, from: data)
            
            if let user = jsonUser {
                self.currentUser = user
                
                completion()
            }
            
        }
    }
    
    func getArenaUsers(completion: @escaping ()->()) {
        let userLevel = self.currentUser.level
        
        Network.instance.fetch(route: Route.getFightingUsers(level: userLevel), token: self.basicAuthToken) { (data) in
            let jsonUsers = try? JSONDecoder().decode([User].self, from: data)
            
            if let users = jsonUsers {
                self.allUsers = users
                completion()
            }
        }
    }
}
