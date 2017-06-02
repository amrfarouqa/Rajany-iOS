//
//  HomeVC.swift
//  Rajany
//
//  Created by Amr Farouq on 11/9/16.
//  Copyright © 2016 Amr Farouq. All rights reserved.
//

import UIKit
import FBSDKLoginKit
class HomeVC: UITabBarController {

    /*@IBOutlet weak var usernameLbl: UILabel!
    @IBAction func btnLogout(_ sender: AnyObject) {
        UserDefaults.standard.set(false, forKey: "ISLOGGEDIN")
        let manager = FBSDKLoginManager()
        manager.logOut()
    }*/
    override func viewDidLoad() {
        super.viewDidLoad()
        /*let prefs:UserDefaults = UserDefaults.standard
        self.usernameLbl.text = prefs.value(forKey: "USERNAME") as? String
        // Do any additional setup after loading the view.*/
        
        if Reachability.isConnectedToNetwork() == true
        {
            let H = HomeFeedController(collectionViewLayout: UICollectionViewFlowLayout())
            H.refresh()
            let C = ColorsController(collectionViewLayout: UICollectionViewFlowLayout())
            C.refresh()
        }
        else
        {
            let alert = UIAlertController(title: "Ooops!", message:"Please Connect To The Internet!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
            
            self.present(alert, animated: true){};
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
