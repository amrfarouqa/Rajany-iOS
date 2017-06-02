//
//  IdeasTab.swift
//  Rajany
//
//  Created by Amr Farouq on 11/11/16.
//  Copyright © 2016 Amr Farouq. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
class IdeasTab: UIViewController {

    @IBOutlet weak var NavBar: UINavigationBar!

    @IBAction func showKitchen(_ sender: AnyObject) {
        let KitchenCVC = self.storyboard!.instantiateViewController(withIdentifier: "KitchenCVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = KitchenCVC
        appDelegate.window!.makeKeyAndVisible()
    }
    
    @IBAction func showBedroom(_ sender: AnyObject) {
        let BedroomCVC = self.storyboard!.instantiateViewController(withIdentifier: "BedCVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = BedroomCVC
        appDelegate.window!.makeKeyAndVisible()
    }
    
    @IBAction func showLiving(_ sender: AnyObject) {
        let LivingCVC = self.storyboard!.instantiateViewController(withIdentifier: "LivingCVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = LivingCVC
        appDelegate.window!.makeKeyAndVisible()
    }
    
    @IBAction func showInterior(_ sender: AnyObject) {
        let InteriorCVC = self.storyboard!.instantiateViewController(withIdentifier: "InteriorCVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = InteriorCVC
        appDelegate.window!.makeKeyAndVisible()
    }
    
    @IBAction func showOutdoor(_ sender: AnyObject) {
        let OutdoorCVC = self.storyboard!.instantiateViewController(withIdentifier: "OutdoorCVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = OutdoorCVC
        appDelegate.window!.makeKeyAndVisible()
    }
    
    @IBAction func showKids(_ sender: AnyObject) {
        let BabyCVC = self.storyboard!.instantiateViewController(withIdentifier: "BabyCVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = BabyCVC
        appDelegate.window!.makeKeyAndVisible()
    }
    
    @IBAction func showDining(_ sender: AnyObject) {
        let DiningCVC = self.storyboard!.instantiateViewController(withIdentifier: "DiningCVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = DiningCVC
        appDelegate.window!.makeKeyAndVisible()
    }
    
    @IBAction func showFireplace(_ sender: AnyObject) {
        let FireplaceCVC = self.storyboard!.instantiateViewController(withIdentifier: "FireplaceCVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = FireplaceCVC
        appDelegate.window!.makeKeyAndVisible()
    }
    
    @IBAction func showEntry(_ sender: AnyObject) {
        let EntryCVC = self.storyboard!.instantiateViewController(withIdentifier: "EntryCVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = EntryCVC
        appDelegate.window!.makeKeyAndVisible()
    }
    
    @IBAction func showBath(_ sender: AnyObject) {
        let BathCVC = self.storyboard!.instantiateViewController(withIdentifier: "BathCVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = BathCVC
        appDelegate.window!.makeKeyAndVisible()
    }
    
    @IBAction func showPool(_ sender: AnyObject) {
        let PoolCVC = self.storyboard!.instantiateViewController(withIdentifier: "PoolCVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = PoolCVC
        appDelegate.window!.makeKeyAndVisible()
    }
 
    @IBAction func showStaircase(_ sender: AnyObject) {
        let StaircaseCVC = self.storyboard!.instantiateViewController(withIdentifier: "StaircaseCVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = StaircaseCVC
        appDelegate.window!.makeKeyAndVisible()
    }
    
    @IBAction func showFurniture(_ sender: AnyObject) {
        let FurnitureCVC = self.storyboard!.instantiateViewController(withIdentifier: "FurnitureCVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = FurnitureCVC
        appDelegate.window!.makeKeyAndVisible()
    }
    
    @IBAction func showGym(_ sender: AnyObject) {
        let GymCVC = self.storyboard!.instantiateViewController(withIdentifier: "GymCVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = GymCVC
        appDelegate.window!.makeKeyAndVisible()
    }
    
    @IBAction func showHall(_ sender: AnyObject) {
        let HallCVC = self.storyboard!.instantiateViewController(withIdentifier: "HallCVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = HallCVC
        appDelegate.window!.makeKeyAndVisible()
    }
   
    @IBAction func showWall(_ sender: AnyObject) {
        let WallCVC = self.storyboard!.instantiateViewController(withIdentifier: "WallCVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = WallCVC
        appDelegate.window!.makeKeyAndVisible()
    }
    
    @IBAction func showLaundry(_ sender: AnyObject) {
        let LaundryCVC = self.storyboard!.instantiateViewController(withIdentifier: "LaundryCVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = LaundryCVC
        appDelegate.window!.makeKeyAndVisible()
    }
    
    @IBAction func showOffice(_ sender: AnyObject) {
        let OfficeCVC = self.storyboard!.instantiateViewController(withIdentifier: "OfficeCVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = OfficeCVC
        appDelegate.window!.makeKeyAndVisible()
    }
    
    @IBAction func showStorage(_ sender: AnyObject) {
        let StorageCVC = self.storyboard!.instantiateViewController(withIdentifier: "StorageCVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = StorageCVC
        appDelegate.window!.makeKeyAndVisible()
    }
    
    @IBAction func showLighting(_ sender: AnyObject) {
        let LightingCVC = self.storyboard!.instantiateViewController(withIdentifier: "LightingCVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = LightingCVC
        appDelegate.window!.makeKeyAndVisible()
    }
    
    @IBAction func showVInatge(_ sender: AnyObject) {
        let VintageCVC = self.storyboard!.instantiateViewController(withIdentifier: "VintageCVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = VintageCVC
        appDelegate.window!.makeKeyAndVisible()
    }
    
    @IBAction func showRestaurant(_ sender: AnyObject) {
        let RestaurantCVC = self.storyboard!.instantiateViewController(withIdentifier: "RestaurantCVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = RestaurantCVC
        appDelegate.window!.makeKeyAndVisible()
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
                super.viewDidLoad()
        setupNavBar()

        // Do any additional setup after loading the view.
        
    }
    func handleMore(){
        
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
    func showProfile() {
        let ProfileCVC = self.storyboard!.instantiateViewController(withIdentifier: "ProfileVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = ProfileCVC
        appDelegate.window!.makeKeyAndVisible()
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
        NavBar.setItems([navItem], animated: false)
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
