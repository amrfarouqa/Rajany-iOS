//
//  LoginVC.swift
//  Rajany
//
//  Created by Amr Farouq on 10/29/16.
//  Copyright © 2016 Amr Farouq. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class LoginVC: UIViewController, GIDSignInUIDelegate, UITextFieldDelegate {
    var handle: FIRAuthStateDidChangeListenerHandle?
    var ref: FIRDatabaseReference!
    
    
    @IBAction func fbLogin(_ sender: AnyObject) {
        
        if Reachability.isConnectedToNetwork() == true
        {
            let loginManager = FBSDKLoginManager()
            loginManager.logIn(withReadPermissions: ["email"], from: self, handler: { (result, error) in
                if let error = error {
                    self.showMessagePrompt(message : error.localizedDescription)
                } else if result!.isCancelled {
                    print("FBLogin cancelled")
                } else {
                    // [START headless_facebook_auth]
                    let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                    // [END headless_facebook_auth]
                    self.firebaseLogin(credential)
                }
            })
        }
        else
        {
            let alert = UIAlertController(title: "Ooops!", message:"Please Connect To The Internet!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
            
            self.present(alert, animated: true){};
        }
        
    }
    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var PswrdFIeld: UITextField!
    
    @IBAction func gLogin(_ sender: AnyObject) {
        if Reachability.isConnectedToNetwork() == true
        {
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().signIn()
        }
        else
        {
            let alert = UIAlertController(title: "Ooops!", message:"Please Connect To The Internet!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
            
            self.present(alert, animated: true){};
        }

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EmailField.delegate = self
        PswrdFIeld.delegate = self
        // Do any additional setup after loading the view.
        ref = FIRDatabase.database().reference();
    }
    
    @IBAction func btnSignIn(_ sender: AnyObject) {
        
        if Reachability.isConnectedToNetwork() == true
        {
            if let email = self.EmailField.text, let password = self.PswrdFIeld.text {
                FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                    if let error = error {
                        self.showMessagePrompt(message : error.localizedDescription)
                    }else{
                        let email = email
                        let prefs:UserDefaults = UserDefaults.standard
                        prefs.set(email, forKey: "EMAIL")
                        prefs.set(true, forKey: "ISLOGGEDIN")
                        prefs.set(true, forKey: "Status")
                        prefs.synchronize()
                        let user = FIRAuth.auth()?.currentUser
                        let interval = NSDate()
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd/M/yyyy, H:mm"
                        let date = formatter.string(from: interval as Date)
                        if let user = user {
                            let uid = user.uid
                            let email = user.email
                            self.ref.child("users/\(uid)/email").setValue(String(email!))
                            self.ref.child("users/\(uid)/dateSignedIn").setValue(String(date))
                            self.ref.child("users/\(uid)/photoURL").setValue(String("http://amrfarouqa.website/rajdy/main/img/icons/avatar.png"))
                            self.ref.child("users/\(uid)/uid").setValue(String(user.uid))
                            self.ref.child("users/\(uid)/username").setValue("RajanyUser")
                            
                        }
                        let HomeVC = self.storyboard!.instantiateViewController(withIdentifier: "MainTabBarVC")
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window!.rootViewController = HomeVC
                        appDelegate.window!.makeKeyAndVisible()
                    }
                }
            } else {
                self.showMessagePrompt(message: "email/password can't be empty")
            }
        }
        else
        {
            let alert = UIAlertController(title: "Ooops!", message:"Please Connect To The Internet!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
            
            self.present(alert, animated: true){};
        }

        
    }
    
    
    func firebaseLogin(_ credential: FIRAuthCredential) {
        if Reachability.isConnectedToNetwork() == true
        {
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                // [START_EXCLUDE]
                
                // [END_EXCLUDE]
                if let error = error {
                    // [START_EXCLUDE]
                    self.showMessagePrompt(message: error.localizedDescription)
                    // [END_EXCLUDE]
                    return
                }else{
                    let email = user?.email
                    let photoURL = user?.photoURL
                    let name = user?.displayName
                    
                    let prefs:UserDefaults = UserDefaults.standard
                    prefs.set(email, forKey: "EMAIL")
                    prefs.set(photoURL, forKey: "photoURL")
                    prefs.set(name, forKey: "name")
                    prefs.set(true, forKey: "ISLOGGEDIN")
                    prefs.set(true, forKey: "Status")
                    prefs.synchronize()
                    let user = FIRAuth.auth()?.currentUser
                    let interval = NSDate()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/M/yyyy, H:mm"
                    let date = formatter.string(from: interval as Date)
                    if let user = user {
                        let uid = user.uid
                        let email = user.email
                        let photoURL = user.photoURL
                        let name = user.displayName
                        self.ref.child("users/\(uid)/email").setValue(String(describing: email!))
                        self.ref.child("users/\(uid)/dateSignedIn").setValue(String(describing: date))
                        self.ref.child("users/\(uid)/photoURL").setValue(String(describing: photoURL!))
                        self.ref.child("users/\(uid)/uid").setValue(String(describing: user.uid))
                        self.ref.child("users/\(uid)/username").setValue(String(describing: name!))
                    }
                    
                    
                    let HomeVC = self.storyboard!.instantiateViewController(withIdentifier: "MainTabBarVC")
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window!.rootViewController = HomeVC
                    appDelegate.window!.makeKeyAndVisible()
                }
            }

        }
        else
        {
            let alert = UIAlertController(title: "Ooops!", message:"Please Connect To The Internet!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
            
            self.present(alert, animated: true){};
        }

        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func showMessagePrompt(message :String){
        let alert = UIAlertController(title: "Rajany", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
        
        present(alert, animated: true){};
    }
}
