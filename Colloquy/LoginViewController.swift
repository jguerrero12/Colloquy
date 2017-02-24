//
//  ViewController.swift
//  Colloquy
//
//  Created by Jose Guerrero on 2/22/17.
//  Copyright © 2017 Jose Guerrero. All rights reserved.
//

import UIKit
import Parse 

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        emailTxtField.delegate = self
        passwordTxtField.delegate = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        
        let email = emailTxtField.text
        
        let regex = try! NSRegularExpression(pattern: "([a-z]{2,})@([a-z]+)\\.com", options: [])
        let match = regex.matches(in: email!, options: [], range: NSRange(location: 0, length: emailTxtField?.text?.characters.count ?? 0))
        
        if  match.count != 0 {
            
            let username = emailTxtField.text
            let password = passwordTxtField.text
            
            if password != nil {
                
                let user = PFUser()
                
                
                
                user.username = username
                user.password = password
                user.email = username
                
                user.signUpInBackground(block: { (success: Bool, error: Error?) in
                    if success {
                        let alert = UIAlertController(title: "Yay!😊", message: "You succesfully signed up to Colloquy!", preferredStyle: .alert)
                        // create an OK action
                        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                            self.performSegue(withIdentifier: "showChatSegue", sender: nil)
                        }
                        // add the OK action to the alert controller
                        alert.addAction(OKAction)
                        self.present(alert, animated: true) {
                            
                        }
                    }
                    else{
                        
                        
                        let alert = UIAlertController(title: "Opps!", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                        // create an OK action
                        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                            
                        }
                        // add the OK action to the alert controller
                        alert.addAction(OKAction)
                        self.present(alert, animated: true) {
                            
                        }
                    }
                })
            }
            else {
                let alert = UIAlertController(title: "Invalid", message: "Please enter a non-empty password", preferredStyle: .alert)
                // create an OK action
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.passwordTxtField.isHighlighted = true
                }
                // add the OK action to the alert controller
                alert.addAction(OKAction)
                present(alert, animated: true) {
                    
                }
            }
        }
        else{
            let alert = UIAlertController(title: "Invalid", message: "Please enter a vaild email address", preferredStyle: .alert)
            // create an OK action
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.emailTxtField.text = ""
                self.passwordTxtField.isHighlighted = true
            }
            // add the OK action to the alert controller
            alert.addAction(OKAction)
            present(alert, animated: true) {
                
            }
        }
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let userName = emailTxtField.text
        let password = passwordTxtField.text
        
        PFUser.logInWithUsername(inBackground: userName!, password: password!) { (success: PFUser?, error: Error?) in
            if success != nil {
                self.performSegue(withIdentifier: "showChatSegue", sender: nil)
            }
            else {
                let alert = UIAlertController(title: "Opps!", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                // create an OK action
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                }
                // add the OK action to the alert controller
                alert.addAction(OKAction)
                self.present(alert, animated: true) {
                    
                }
            }
        }
        
    }
    
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let chatView = segue.destination as! ChatViewController
        
    }
    */

}

