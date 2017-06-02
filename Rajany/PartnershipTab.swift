//
//  PartnershipTab.swift
//  Rajany
//
//  Created by Amr Farouq on 11/11/16.
//  Copyright © 2016 Amr Farouq. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
class PartnershipTab: UIViewController {
    /*@IBAction func btnLogout(_ sender: AnyObject) {
     
        UserDefaults.standard.set(false, forKey: "ISLOGGEDIN")
     
        let manager = FBSDKLoginManager()
        manager.logOut()
        let LoginVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = LoginVC
        appDelegate.window!.makeKeyAndVisible()
    }*/
    @IBOutlet weak var NavBarr: UINavigationBar!
    
    @IBAction func btnWipro(_ sender: AnyObject) {
        let url = URL(string: "http://www.wipro.com/")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @IBAction func btnSalab(_ sender: AnyObject) {
        let url = URL(string: "http://www.ahmedelsallab.com/")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    @IBAction func btnJotun(_ sender: AnyObject) {
        let url = URL(string: "http://www.jotun.com/")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    @IBAction func btnIkea(_ sender: AnyObject) {
        let url = URL(string: "http://www.ikea.com/")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        // Do any additional setup after loading the view.
    }

    func setupNavBar(){
        let profile = UIBarButtonItem(image: UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showProfile))
        
        let messages = UIBarButtonItem(image: UIImage(named: "advice")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMessage))
        
        let logout = UIBarButtonItem(image: UIImage(named: "power")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))
        
        let title = UIBarButtonItem(title: "Rajany", style: .plain, target: self, action: #selector(handleMore))
        
        let logo = UIBarButtonItem(image: UIImage(named: "logosmall")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))
        
        
        let navItem = UINavigationItem(title: "")
        navItem.rightBarButtonItems = [logout, profile, messages]
        navItem.leftBarButtonItems = [logo, title]
        NavBarr.setItems([navItem], animated: false)
    }   
    
    func showProfile() {
        let ProfileCVC = self.storyboard!.instantiateViewController(withIdentifier: "ProfileVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = ProfileCVC
        appDelegate.window!.makeKeyAndVisible()
    }
    
    func handleMessage(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let user = UserChat()
                user.setValuesForKeys(dictionary)
                chatLogController.user = user
            }
            
        }, withCancel: nil)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = UINavigationController(rootViewController: chatLogController)
        appDelegate.window!.makeKeyAndVisible()
        
    }

    
    func handleLogout() {
        let alert = UIAlertController(title: "Logout", message:"Are You Sure You Want To Logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("HomeViewController Logout Canceled")
        }))
        
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            UserDefaults.standard.set(false, forKey: "ISLOGGEDIN")
            let firebaseAuth = FIRAuth.auth()
            do {
                try firebaseAuth?.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            let LoginVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window!.rootViewController = LoginVC
            appDelegate.window!.makeKeyAndVisible()
        })
        self.present(alert, animated: true){};
    }

    
    func handleMore() {
        print("Handlemore")
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
