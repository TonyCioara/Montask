//
//  LoginViewController.swift
//  Montask
//
//  Created by Sunny Ouyang on 10/30/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import UIKit
import KeychainSwift

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    let keychain = KeychainSwift()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        
        // In here we will perform a GET request to our server. If it returns a user object successfully, we will segue onto the next view, if not, we will pop an alert saying that login was unsuccesful
        let username = self.usernameTextField.text
        let password = self.passwordTextField.text
        
        
        let basicToken = BasicAuth.generateBasicAuthHeader(username: username!, password: password!)
        getLoginUser(username: username!, basicToken: basicToken)

        
    }
    

}

extension LoginViewController {
    func getLoginUser(username: String, basicToken: String) {
        self.keychain.set("\(basicToken)", forKey: "basicToken")
        self.keychain.set("\(username)", forKey: "username")
        Network.instance.fetch(route: Route.getUser, token: basicToken) { (data) in
            
            let jsonUser = try? JSONDecoder().decode(User.self, from: data)
            
            if let user = jsonUser {
                print("Log in successful!")
                let username = user.username
                let monsters: [Monster] = user.monsters
                let points = user.points
                let level = user.level
                let loggedUser = User.sharedInstanceWith(username: username, monsters: monsters, points: points, level: level)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toMain", sender: self)
                }
                
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Invalid Login", message: "Username or password incorrect", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                return
            }
            
        }
    }
}
