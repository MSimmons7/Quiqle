//
//  LoginVC.swift
//  Quiqle
//
//  Created by Sikander Zeb on 5/30/18.
//  Copyright © 2018 Sikander Zeb. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD
import UserNotifications

class LoginVC: BaseVC {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    //@IBOutlet weak var confirmPassword: UITextField!
    //@IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseHelper.shared.dbref = Database.database().reference()
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        
        if Utilities.isEmpty(firstName.text!) || Utilities.isEmpty(lastName.text!) {
            Utilities.showAlert(self, message: "Phone enter first and last name", alertTitle: "Name missing")
            return
        }
        
        if !Utilities.isValidEmail(testStr: email.text!) {
            Utilities.showAlert(self, message: "Please enter a valid email address", alertTitle: "Invalid Email")
            return
        }
        
//        if Utilities.isEmpty(username.text!) {
//            Utilities.showAlert(self, message: "Username cannot be empty", alertTitle: "Missing username")
//            return
//        }
        
        if Utilities.isEmpty(password.text!) {
            Utilities.showAlert(self, message: "Please enter a password", alertTitle: "Empty Password")
            return
        }
        
        //        if password.text! != confirmPassword.text! {
        //            Utilities.showAlert(self, message: "Passwords do not match", alertTitle: "Password")
        //            return
        //        }
        
        SVProgressHUD.show()
        Auth.auth().createUser(withEmail: email.text!, password: password.text!, completion: { (authData, error) in
            
            SVProgressHUD.dismiss()
            
            if error != nil {
                print(error ?? "")
                Utilities.showAlert(self, message: (error?.localizedDescription)!, alertTitle: "Error")
                return
            }
            
            //            user?.sendEmailVerification(completion: { (error) in
            //                if error != nil {
            //                    print("error verifying email: \(error ?? nil )")
            //                    Utilities.showAlert(self, message: "A verification email has been sent to provided email address, please verify.", alertTitle: "Success")
            //                }
            //            })
            
            let user = Auth.auth().currentUser
            
            let request = user?.createProfileChangeRequest()
            request?.displayName = " "
            request?.commitChanges(completion: { (error) in
                
                Utilities.saveProfile(Auth.auth().currentUser!, password: self.password.text)
            })
            
            FirebaseHelper.shared.dbref.child("users/\((user?.uid)!)").setValue(["name": " ",
                                                                                 "email":self.email.text!,])
            self.performSegue(withIdentifier: "goToHomeSegue"/*loginSegue*/, sender: self)
            //print(user)
        })
        
    }
    
    @IBAction func recoverTapped(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Recover Password", message: "", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Your email"
            textfield.keyboardType = .emailAddress
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            let textfield = alert.textFields![0]
            
            if !Utilities.isValidEmail(testStr: textfield.text!) {
                Utilities.showAlert(self, message: "Please enter a valid email address", alertTitle: "Invalid Email")
                return
            }
            SVProgressHUD.show()
            Auth.auth().sendPasswordReset(withEmail: textfield.text!) { (error) in
                SVProgressHUD.dismiss()
                if error != nil {
                    
                    Utilities.showAlert(self, message: (error?.localizedDescription)!, alertTitle: "Error")
                    return
                }
                
                Utilities.showAlert(self, message: "Check your email for new password", alertTitle: "Success")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        if !Utilities.isValidEmail(testStr: email.text!) {
            Utilities.showAlert(self, message: "Please enter a valid email address", alertTitle: "Invalid Email")
            return
        }
        
        if Utilities.isEmpty(password.text!) {
            Utilities.showAlert(self, message: "Please enter a password", alertTitle: "Empty Password")
            return
        }
        
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: email.text! , password: password.text!, completion: { (authData, error) in
            SVProgressHUD.dismiss()
            if error != nil {
                print(error ?? "")
                Utilities.showAlert(self, message: (error?.localizedDescription)!, alertTitle: "Error")
                return
            }
            let user = Auth.auth().currentUser
            Utilities.saveProfile(user!, password: self.password.text)
            self.registerNotifications()
            self.performSegue(withIdentifier: "goToHomeSegue", sender: self)
            //print(user)
        })
    }
    
    func registerNotifications() {
        let application = UIApplication.shared
        DispatchQueue.main.async {
            if #available(iOS 10.0, *) {
                // For iOS 10 display notification (sent via APNS)
                UNUserNotificationCenter.current().delegate = application.delegate as! AppDelegate
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
                })
            } else {
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                application.registerUserNotificationSettings(settings)
            }
            return
        }
    }
}

class BaseVC: UIViewController, UITextFieldDelegate {
    override func viewDidLoad() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
