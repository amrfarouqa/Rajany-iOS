//
//  ColorPickerVC.swift
//  Rajany
//
//  Created by Amr Farouq on 12/26/16.
//  Copyright © 2016 Amr Farouq. All rights reserved.
//

import UIKit
import Firebase
class ColorPickerVC: UIViewController {
     var ref: FIRDatabaseReference!
    @IBAction func SaveColorBtn(_ sender: AnyObject) {
        let bgColor:UIColor = ColorVIewerImg.backgroundColor!
        let hexcolor = bgColor.toHexString
            if let user = FIRAuth.auth()?.currentUser {
                let interval = NSDate()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/M/yyyy, H:mm"
                let date = formatter.string(from: interval as Date)
                let uid = user.uid
                let email = user.email
                let username = user.displayName
                
                if username != nil {
                    let color = ["color": hexcolor,
                                "date": String(describing: date),
                                "email": String(describing: email!)]
                    
                    ref.child("colorpicks").child(uid).childByAutoId().setValue(color)
                    let alert = UIAlertController(title: "Success!", message:"Added To Color Picks!", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
                    
                    self.present(alert, animated: true){};
                }else{
                    let color = ["color": hexcolor,
                                 "date": String(describing: date),
                                 "email": String(describing: email!)]
                    
                    ref.child("colorpicks").child(uid).childByAutoId().setValue(color)
                    let alert = UIAlertController(title: "Success!", message:"Added To Color Picks!", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
                    
                    self.present(alert, animated: true){};
                }
            }
        
    }
    
    
    



    @IBOutlet weak var ColorVIewerImg: UIImageView!
    @IBOutlet weak var NavBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
         ref =  FIRDatabase.database().reference()
        let colorSlider = ColorSlider()
        colorSlider.frame = CGRect(x: 130, y: 100, width: 60, height: 300)
        colorSlider.previewEnabled = true
        
        view.addSubview(colorSlider)
        setupNavBar()
        
        colorSlider.addTarget(self, action: #selector(ColorPickerVC.changedColor(_:)), for: .valueChanged)
        
        
        // Do any additional setup after loading the view.
    }
    func changedColor(_ slider: ColorSlider) {
        let color = slider.color
        ColorVIewerImg.backgroundColor = color
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavBar(){
        let back = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        
        let logo = UIBarButtonItem(image: UIImage(named: "logosmall")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))
        
        
        let navItem = UINavigationItem(title: "")
        navItem.leftBarButtonItems = [back]
        navItem.rightBarButtonItem = logo
        NavBar.setItems([navItem], animated: false)
    }
    func handleMore(){
        
    }
    func handleBack(){
        let HomeVC = self.storyboard!.instantiateViewController(withIdentifier: "MainTabBarVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = HomeVC
        appDelegate.window!.makeKeyAndVisible()
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

extension UIColor {
    var toHexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "#%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
}
