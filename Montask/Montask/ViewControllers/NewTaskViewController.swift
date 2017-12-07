//
//  NewTaskViewController.swift
//  Montask
//
//  Created by Sunny Ouyang on 11/6/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import UIKit
import KeychainSwift

class NewTaskViewController: UIViewController {
    @IBOutlet weak var taskNameText: UITextField!
    
    @IBOutlet weak var taskDescriptionText: UITextView!
    
    let keyChain = KeychainSwift()
    var selectedTask: Task?
    var basicAuthToken:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
        self.basicAuthToken = self.keyChain.get("basicToken")
        if self.selectedTask != nil {
            taskNameText.text = selectedTask?.name
            taskDescriptionText.text = selectedTask?.description
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // In here we want to make a POST request to our server and add in a new Task
    @IBAction func addNewTaskTapped(_ sender: Any) {
        //I first need to make a new Task Object, populate it with values from user input, and then make a POST request with the body being information from this task Object.
        if self.selectedTask == nil {
        let userEmail = keyChain.get("username")
        let newTask = Task(userEmail: userEmail!, name: taskNameText.text!, description: taskDescriptionText.text!, taskLength: "1 hour", completionPercentage: 0, timeCreated: "Now", completed: false)
        postRequest(task: newTask)
        } else {
            patchTask(task: self.selectedTask!)
        }
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "unwindToTasks", sender: self)
        }
        
    }
    
  

}

extension NewTaskViewController {
    func configureTextView() {
        let borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        taskDescriptionText.layer.borderColor = borderColor.cgColor
        taskDescriptionText.layer.borderWidth = 1.0
        taskDescriptionText.layer.cornerRadius = 5.0
    }
    
    func postRequest(task: Task) {
        let basicAuthToken: String = keyChain.get("basicToken")!
        Network.instance.fetch(route: Route.postTask(email: task.userEmail, name: taskNameText.text!, description: taskDescriptionText.text!, taskLength: task.taskLength, completionPercentage: task.completionPercentage, timeCreated: task.timeCreated), token: basicAuthToken) { (data) in
            print("Task created")
        }
    }
    
    func patchTask(task: Task) {
        Network.instance.fetch(route: Route.patchTask(task: task, completed: true), token: basicAuthToken!) { (data) in
            print("patched Task")
        }
    }
    
}
