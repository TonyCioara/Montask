//
//  TasksViewController.swift
//  Montask
//
//  Created by Sunny Ouyang on 10/31/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import UIKit
import KeychainSwift

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TaskDelegate, ExpandableHeaderViewDelegate {
    
    
    
    @IBOutlet weak var tasksTableView: UITableView!
    var inProgressSection: Section!
    var sections: [Section] = []
    var completedSection: Section!
    let keychain = KeychainSwift()
    var basicAuthToken: String?
    let dispatchGroup = DispatchGroup()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.basicAuthToken = self.keychain.get("basicToken")
        loadTasks() {

            DispatchQueue.main.async {
                self.tasksTableView.reloadData()
                }


        }
    }
    

    
    
    
    func toggleSection(header: TaskTableViewHeaderFooterView, section: Int) {
        self.sections[section].expanded = !self.sections[section].expanded
        self.tasksTableView.beginUpdates()
        for i in 0 ..< self.sections[section].tasks.count {
            self.tasksTableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        self.tasksTableView.endUpdates()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard self.sections.count > 0 else {return 0}
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.sections.count > 0 else { return 0 }
        return sections[section].tasks.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
  
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = TaskTableViewHeaderFooterView()
        header.textLabel?.font = UIFont(name: "Futura", size: 20)
        guard self.sections.count > 0 else {return header}
        
        if self.sections[section].tasks.count != 0 {
            header.customInit(title: "\(self.sections[section].name) ...", section: section, delegate: self)
        } else {
        header.customInit(title: self.sections[section].name, section: section, delegate: self)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tasksTableView.dequeueReusableCell(withIdentifier: "taskCell") as! TaskTableViewCell
        guard self.sections.count > 0 else {return cell}
        
        cell.taskNameLabel.text = self.sections[indexPath.section].tasks[indexPath.row].name
        cell.descriptionLabel.text = self.sections[indexPath.section].tasks[indexPath.row].description
        if self.sections[indexPath.section].tasks[indexPath.row].completed {
            cell.completedButton.setImage(UIImage(named: "checked"), for: .normal)
            cell.completedButton.isUserInteractionEnabled = false
        } else {
            cell.completedButton.setImage(UIImage(named: "blank"), for: .normal)
        }
        cell.delegate = self as TaskDelegate
        cell.indexPath = indexPath
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toEditTask", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard self.sections.count > 0 else {return 0}
        if sections[indexPath.section].expanded {
            return 90
        } else {
            return 0
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        self.sections = []
    }
    
    //this function gets called when I click the complete button.
    func completeTask(indexPath: IndexPath) {
        patchTask(task: self.sections[indexPath.section].tasks[indexPath.row])
        loadTasks() {
            
            DispatchQueue.main.async {
                self.tasksTableView.reloadData()
            }
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toEditTask" {
                let taskVC = segue.destination as! NewTaskViewController
                let indexPath = self.tasksTableView.indexPathForSelectedRow!
                taskVC.selectedTask = self.sections[indexPath.section].tasks[indexPath.row]
            }
        }
    }

    @IBAction func unwindToTasks(segue:UIStoryboardSegue) { }
    
    
    
}




extension TasksViewController {
    

    
    func loadTasks(completion: @escaping () ->()) {
        self.sections = []
        
        getTasks() {
            self.sections = [self.inProgressSection, self.completedSection]
            completion()
        }
        
        
        
    }
    
    func patchTask(task: Task) {
        Network.instance.fetch(route: Route.patchTask(task: task, completed: true), token: basicAuthToken!) { (data) in
            print("patched Task")
        }
    }
    
    
    func categorizeTasks(tasks: [Task]) -> [String: [Task]] {
        var taskDict: [String: [Task]] = ["completed" : [], "inprogress" : []]
        for task in tasks {
            if task.completed {
                taskDict["completed"]?.append(task)
            } else {
                taskDict["inprogress"]?.append(task)
            }
        }
        
        return taskDict
    }
    
    func getTasks(completion: @escaping ()->()) {
        self.sections = []
        Network.instance.fetch(route: Route.getTasks, token: basicAuthToken!) { (data) in
            print(data)
            let jsonTasks = try? JSONDecoder().decode([Task].self, from: data)
            //In here, we have to categorize our tasks into in progress and completed sections
            
            if let tasks = jsonTasks {
                let tasksDictionary: [String: [Task]] = self.categorizeTasks(tasks: tasks)
                
                self.inProgressSection = Section(name: "In Progress", tasks: tasksDictionary["inprogress"]!, expanded: true)
                self.completedSection = Section(name: "Completed", tasks: tasksDictionary["completed"]!, expanded: true)
                completion()
            }
            
        }
    }
}
