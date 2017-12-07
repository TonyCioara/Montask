//
//  PersonalViewController.swift
//  Montask
//
//  Created by Sunny Ouyang on 11/18/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import UIKit
import KeychainSwift
import Kingfisher

class PersonalViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HeaderviewDelegate {
    
    
    
    @IBOutlet weak var personalCollectionView: UICollectionView!
    
    var user: User!
    var friendsView = false
    var monsters: [Monster] = []
    let keychain = KeychainSwift()
    var topThree: [Monster] = []
    var monsterToPass: Monster!


    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        if self.friendsView == false {
            getUser() {
//                let monsterDict = self.setUpImagesDict(monsters: self.monsters)
                DispatchQueue.main.async {
                    self.topThree = self.getTopThreeMonsters(monsters: self.user.monsters)
                    self.setCollectionViewLayout()
                    self.personalCollectionView.reloadData()
                }
            }
        }
         else {
            self.monsters = user.monsters
             self.topThree = self.getTopThreeMonsters(monsters: self.user.monsters)
//            let monsters = self.setUpImagesDict(monsters: self.monsters)
            DispatchQueue.main.async {
                self.setCollectionViewLayout()
                self.personalCollectionView.reloadData()
            }
        }
    }


    func sendMonster(monster: Monster) {
        self.monsterToPass = monster
        self.performSegue(withIdentifier: "toTopMonsters", sender: self)
    }
    
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.monsters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.personalCollectionView.dequeueReusableCell(withReuseIdentifier: "personalCell", for: indexPath) as! PersonalCollectionViewCell
        let monsterImageURL = self.monsters[indexPath.row].imageUrl
//        cell.monsterImage.kf.setImage(with: monsterImageURL!)
        
        cell.monsterImage.image = UIImage(named: monsterImageURL)
        

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = self.personalCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "personalHeaderCell", for: indexPath) as! PersonalCollectionViewHeader
        headerView.usernameLabel.text = self.user?.username
        headerView.topThreeMonsters = self.topThree
        headerView.delegate = self as HeaderviewDelegate
        if self.monsters.count > 0 {
           
            let topMonsterURL = URL(string: self.topThree[2].imageUrl)
            headerView.topMonsterImage.kf.setImage(with: topMonsterURL!)
            setViewBorder(view: headerView.topUIView, cornerRadius: 74)

        }
        if self.monsters.count > 1 {

            let secondMonsterURL = URL(string: self.topThree[1].imageUrl)
            headerView.secondMonsterImage.kf.setImage(with: secondMonsterURL!)
            setViewBorder(view: headerView.secondUIView, cornerRadius: 63)
        }
        if self.monsters.count > 2 {

             let thirdMonsterURL = URL(string: self.topThree[0].imageUrl)
            headerView.thirdMonsterImage.kf.setImage(with: thirdMonsterURL!)
            setViewBorder(view: headerView.thirdUIView, cornerRadius: 63)
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toMonsterDetail", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 75)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toMonsterDetail" {
                let monsterDetailVC = segue.destination as! MonsterDetailViewController
                let indexPaths = self.personalCollectionView.indexPathsForSelectedItems
                let indexPath = indexPaths![0]
                let selectedMonster = self.monsters[indexPath.row]
                monsterDetailVC.monster = selectedMonster
            } else if identifier == "toTopMonsters" {
                let monsterDetailVC = segue.destination as! MonsterDetailViewController
                monsterDetailVC.monster = self.monsterToPass
            }
        }
    }
    

}

extension PersonalViewController {
    
    func getUser(completion: @escaping ()->()) {
        let basicToken = self.keychain.get("basicToken")
        Network.instance.fetch(route: Route.getUser, token: basicToken!) { (data) in
            let jsonUser = try? JSONDecoder().decode(User.self, from: data)
        
            if let user = jsonUser {
                self.user = user
                self.monsters = user.monsters
                completion()
            }
            
        }
    }
    
    func getTopThreeMonsters(monsters: [Monster]) -> [Monster] {
        guard monsters.count >= 3 else {return []}
        let sortedMonsters = monsters.sorted(by: { $0.power > $1.power})
        var topThree: [Monster] = []
        for x in 0..<3 {
            topThree.append(sortedMonsters[x])
        }
        return topThree
    }
    
    
    func getImages(dict: [String: String], imageArray: inout [UIImage]) {
        
        for monster in self.monsters {
            //should get the imageURL based off of the monsters name
            let imageURL = dict[monster.name]
            let monsterImage = getImage(url: imageURL!)
            imageArray.append(monsterImage)
        }
        
    }
    
    func setUpImagesDict(monsters: [Monster]) -> [String: String] {
        var monsterDict = [String: String]()
        
        for monster in monsters {
            if monsterDict[monster.name] == nil {
                monsterDict[monster.name] = monster.imageUrl
            }
        }
        return monsterDict
    }
    
    func getImage(url: String) -> UIImage {
        let url = URL(string: url)
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data: data!)
        return image!
    }
    
    func setCollectionViewLayout() {
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 10, right: 15)
//        layout.itemSize = CGSize(width: screenWidth/4, height: screenWidth/4)
        layout.minimumLineSpacing = 10
        layout.headerReferenceSize = CGSize(width: screenWidth, height: 350)
//        self.personalCollectionView.collectionViewLayout = layout
    }
    
    func setViewBorder(view: UIView, cornerRadius: CGFloat) {
        view.layer.borderWidth = 5
        view.layer.cornerRadius = cornerRadius
        view.layer.borderColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0).cgColor
        view.clipsToBounds = true
    }
    
   
}
