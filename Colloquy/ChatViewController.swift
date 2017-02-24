//
//  ChatViewController.swift
//  Colloquy
//
//  Created by Jose Guerrero on 2/22/17.
//  Copyright © 2017 Jose Guerrero. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var chatTxtField: UITextField!
    @IBOutlet weak var messagesTableView: UITableView!
    var messages: [String]!
    var users: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        messagesTableView.estimatedRowHeight = 62
        messagesTableView.rowHeight = UITableViewAutomaticDimension
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChatViewController.onTimer), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messages != nil{
            return messages.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messagesTableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        
        cell.messageLabel.text = messages.object(at: indexPath.row) as? String
        
        if users.object(at: indexPath.row) as? String != nil {
            cell.userLabel.text = users.object(at: indexPath.row) as? String
        }
        else{
            cell.userLabel.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        messagesTableView.deselectRow(at: indexPath, animated: true)
        messagesTableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func onTimer() {
        
        //pull the messages from parse server...
        let query = PFQuery(className:"Messages")
        query.includeKey("user")
        query.order(byDescending: "createdAt") // sort messages in descending order of date created.
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                if objects != nil { // if the retrieved objects (messages) var is not empty, make messages equal to them.
                    self.messages = objects! as NSArray!
                    self.messagesTableView.reloadData()
                }
            }
            else{
                // error refreshing the messages
            }
        }
    }
    
    @IBAction func onSend(_ sender: Any) {
        
        if chatTxtField.text != nil {
            let message = PFObject(className:"Message")
            message["text"] = chatTxtField.text!
            message["user"] = PFUser.getCurrentUserInBackground()
            
            message.saveInBackground { (success: Bool, error: Error?) in
                if(success){
                    // update display
                    print("Message saved successfully!")
                }
                else{
                    let alert = UIAlertController(title: "Error", message: "\(error?.localizedDescription)", preferredStyle: .alert)
                    
                    // create an OK action
                    let OKAction = UIAlertAction(title: "OK", style: .default)
                    
                    // add the OK action to the alert controller
                    alert.addAction(OKAction)
                    self.present(alert, animated: true) {
                        
                    }
                    
                }
            }
        }
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
