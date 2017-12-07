//
//  NewMonsterViewController.swift
//  Montask
//
//  Created by Sunny Ouyang on 11/22/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import UIKit
import Kingfisher
import KeychainSwift

class NewMonsterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, newMonsterDelegate{
   

    @IBOutlet weak var newMonsterCollectionView: UICollectionView!
    
    var eggs: [Egg] = [Egg(price: 5, monsters: monsterModels, tier: "Novice", url: "https://img00.deviantart.net/e893/i/2017/051/a/5/pokemon_egg__10k__by_maniraptavia-daztjs9.png"), Egg(price: 20, monsters: monsterModels, tier: "Intermediate", url: "https://i.pinimg.com/736x/4c/16/91/4c169179c8d534d97a37829e66e869aa.jpg")]
    
    let keychain = KeychainSwift()
    var hatchedMonster: Monster?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.newMonsterCollectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.eggs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.newMonsterCollectionView.dequeueReusableCell(withReuseIdentifier: "newMonsterCell", for: indexPath) as! NewMonsterCollectionViewCell
        cell.monsterTierLabel.text = self.eggs[indexPath.row].tier
        cell.eggPriceLabel.text = "price: \(self.eggs[indexPath.row].price)"
        cell.monsterEggImage.kf.setImage(with: URL(string: self.eggs[indexPath.row].imageURL))
        cell.points = self.eggs[indexPath.row].price
        cell.delegate = self as newMonsterDelegate
        cell.indexPath = indexPath
        cell.hatchButton.isUserInteractionEnabled = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
  

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        return CGSize(width: screenSize.width, height: screenSize.height)
    }
    
    
    func sendIndexPath(indexPath: IndexPath) {
        
        guard User.sharedInstance.points >= self.eggs[indexPath.row].price else {
            let alert = UIAlertController(title: "Hatch unavailable", message: "Not enough points", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        User.sharedInstance.points -= self.eggs[indexPath.row].price
        patchUser(points: User.sharedInstance.points)
        
        let possibleMonsters = self.eggs[indexPath.row].monsters
        let randomNumber =  Int(arc4random_uniform(UInt32(possibleMonsters.count)))
        let selectedMonster = possibleMonsters[randomNumber]
        
        
        
        self.hatchedMonster = createNewMonster(monsterModel: selectedMonster)

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "newMonsterReveal" {
                let MonsterDetailVC = segue.destination as! MonsterDetailViewController
                MonsterDetailVC.monster = self.hatchedMonster!
            }
        }
    }
    
  
}


extension NewMonsterViewController {
    
    func createNewMonster(monsterModel: MonsterModel) -> Monster {
        let userEmail = self.keychain.get("username")
        let powerRoll = Int.random(range: Range(-30...30))
        let healthRoll = Int.random(range: Range(-200...200))
        let specialPowerRoll = Int.random(range: Range(-100...100))
        let power = monsterModel.power + powerRoll
        let health = monsterModel.health + healthRoll
        let specialPower = monsterModel.specialPower + specialPowerRoll
        let newMonster = Monster(name: monsterModel.name, power: power, specialName: "Betablast", specialPower: specialPower, health: health, userEmail: userEmail!, imageUrl: monsterModel.imageURL)
        let token = self.keychain.get("basicToken")
        
        _ = Network.instance.fetch(route: Route.postMonster(userEmail: userEmail!, name: newMonster.name, power: newMonster.power, specialName: "Betablast", specialPower: newMonster.specialPower, health: newMonster.health, imageURL: newMonster.imageUrl), token: token!) { (data) in
            
            print("Monster Created")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "newMonsterReveal", sender: self)
            }
        }
        
        
        return newMonster
    }
    
    func patchUser(points: Int) {
        let token = keychain.get("basicToken")
        Network.instance.fetch(route: Route.patchUser(points: points, username: User.sharedInstance.email, level: User.sharedInstance.level), token: token!) { (data) in
            print("User was updated!")
        }
    }
    
}
