//
//  NewFriendViewController.swift
//  Montask
//
//  Created by Sunny Ouyang on 12/5/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import UIKit
import KeychainSwift

class NewFriendViewController: UIViewController {
    
    let keyChain = KeychainSwift()
    var basicAuthToken: String?

    @IBOutlet weak var newFriendTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.basicAuthToken = keyChain.get("basicToken")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        let newRequest = Request(sender: User.sharedInstance.username, receiver: newFriendTextField.text!)
        Network.instance.fetch(route: Route.postFriendRequest(sender: newRequest.sender, receiver: newRequest.receiver), token: self.basicAuthToken!) { (data) in
            print("New Request Added!")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "unwindToFriendsVC", sender: self)
            }
        }
    }
    

}
