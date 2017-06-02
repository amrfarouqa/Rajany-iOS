//
//  Copyright (c) 2015 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit
import Firebase

@objc(TabBarController)
class TabBarController: UITabBarController {
    @IBAction func btnBackStories(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.present(vc, animated: true, completion: nil)
    }

  override func didMove(toParentViewController parent: UIViewController?) {
    if parent == nil {
      let firebaseAuth = FIRAuth.auth()
      do {
        try firebaseAuth?.signOut()
      } catch let signOutError as NSError {
        print ("Error signing out: %@", signOutError)
      }

    }
  }
    override func viewDidLoad() {
        let firebaseAuth = FIRAuth.auth()
        if firebaseAuth?.currentUser != nil {
            print("user is logged in")
        }else{
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
        }
    }
    
}
