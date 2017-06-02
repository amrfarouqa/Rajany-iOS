//
//  ProfileVC.swift
//  Rajany
//
//  Created by Amr Farouq on 11/30/16.
//  Copyright © 2016 Amr Farouq. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
class ProfileVC: UIViewController {

    @IBOutlet weak var UserLabel: UILabel!
    @IBOutlet weak var NavBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        let prefs:UserDefaults = UserDefaults.standard
        let UserEmail:String = prefs.string(forKey: "EMAIL")!
        UserLabel.text = UserEmail
        setupNavBar()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    @IBAction func SavedBtn(_ sender: AnyObject) {
        let Saved = self.storyboard!.instantiateViewController(withIdentifier: "Saved")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = Saved
        appDelegate.window!.makeKeyAndVisible()
    }

    @IBAction func MessagesBtn(_ sender: AnyObject) {
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
    
    @IBAction func showSchemes(_ sender: AnyObject) {
        let Saved = self.storyboard!.instantiateViewController(withIdentifier: "SchemesVFeedController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = Saved
        appDelegate.window!.makeKeyAndVisible()
    }
    @IBAction func showPicks(_ sender: AnyObject) {
        let Saved = self.storyboard!.instantiateViewController(withIdentifier: "PicksVFeedController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = Saved
        appDelegate.window!.makeKeyAndVisible()
    }
    
    @IBAction func showHnts(_ sender: AnyObject) {
        let Saved = self.storyboard!.instantiateViewController(withIdentifier: "HintsVFeedController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = Saved
        appDelegate.window!.makeKeyAndVisible()
    }
    
    @IBAction func showAdvice(_ sender: AnyObject) {
        let NavGontroller = self.storyboard!.instantiateViewController(withIdentifier: "ANavController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = NavGontroller
        appDelegate.window!.makeKeyAndVisible()
    }
    
    @IBAction func showStories(_ sender: AnyObject) {
        let NavGontroller = self.storyboard!.instantiateViewController(withIdentifier: "SNavController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = NavGontroller
        appDelegate.window!.makeKeyAndVisible()
    }
    
    
    
    @IBAction func ColorsBtn(_ sender: AnyObject) {
        

    }
    @IBAction func IdeaBookBtn(_ sender: AnyObject) {
        let IdeasCVC = self.storyboard!.instantiateViewController(withIdentifier: "IdeasCVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = IdeasCVC
        appDelegate.window!.makeKeyAndVisible()
    }
    @IBAction func SignOutBtn(_ sender: AnyObject) {
        handleLogout()
    }
    
    func setupNavBar(){
    
        
        let logo = UIBarButtonItem(image: UIImage(named: "logosmall")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))
        
        let back = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        
        let navItem = UINavigationItem(title: "Profile")
        navItem.leftBarButtonItems = [back]
        navItem.rightBarButtonItem = logo
        NavBar.setItems([navItem], animated: false)
    }

    func handleBack(){
        let HomeVC = self.storyboard!.instantiateViewController(withIdentifier: "MainTabBarVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = HomeVC
        appDelegate.window!.makeKeyAndVisible()
    }
    
    func handleLogout() {
        UserDefaults.standard.set(false, forKey: "ISLOGGEDIN")
        let manager = FBSDKLoginManager()
        manager.logOut()
        let LoginVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = LoginVC
        appDelegate.window!.makeKeyAndVisible()
    }
    
    
    func handleMore() {
        print("Handlemore")
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
