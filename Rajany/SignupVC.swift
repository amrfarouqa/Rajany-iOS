//
//  SignupVC.swift
//  Rajany
//
//  Created by Amr Farouq on 10/29/16.
//  Copyright © 2016 Amr Farouq. All rights reserved.
//

import UIKit
import Firebase

class SignupVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var RePassword: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RePassword.delegate = self
        Password.delegate = self
        Email.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func btnSignUp(_ sender: AnyObject) {
        if Reachability.isConnectedToNetwork() == true
        {
            let password:String = Password.text!
            let confirm_password:String = RePassword.text!
            let email:String = Email.text!
            if (password.isEqual("") || confirm_password.isEqual("") || email.isEqual("")){
                
                let alert = UIAlertController(title: "Oops!", message:"Please Enter FullName, Email And Password!", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
                
                self.present(alert, animated: true){};
            } else if ( !password.isEqual(confirm_password) ) {
                
                let alert = UIAlertController(title: "Oops!", message:"Password Doesn't Match!", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
                
                self.present(alert, animated: true){};
            }else{
                FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                    let alert = UIAlertController(title: "Success!", message:"Login Now!", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        
                        let LoginVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC")
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window!.rootViewController = LoginVC
                        appDelegate.window!.makeKeyAndVisible()
                        
                    })
                    
                    self.present(alert, animated: true){};
                    
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func showMessagePrompt(message :String){
        let alert = UIAlertController(title: "Rajany", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
        
        present(alert, animated: true){};
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
