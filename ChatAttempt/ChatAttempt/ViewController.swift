//
//  ViewController.swift
//  ChatAttempt
//
//  Created by Tanay Singhal on 12/31/16.
//  Copyright © 2016 Tanay Singhal. All rights reserved.
//

import UIKit
import SocketIO


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    struct Message {
        var username: String
        var message: String
    }
    
    var username = ""
    var messages = [Message]()
    
    // Socket io
    var socket: SocketIOClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // username = "user_" + randomString(length: 5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        // Table
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        socket = SocketIOClient(socketURL: URL(string: "http://localhost:3000")!, config: [.log(false), .forcePolling(true)])
        
        // Later
        //socket.emit("connect")
        
        addHandlers()
        socket!.connect()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Socket io handlers
    func addHandlers() {
        
        
        // When somebody connects
        socket?.on("connected") { data, ack in
            
            // Get username
            let username = (data[0] as? String)!
            
            // Send system message
            let message = Message(username: "System", message: "\(username) connected")
            self.messages.append(message)
            self.tableView.reloadData()
        }
        
        // When somebody disconnects
        socket?.on("disconnected") { data, ack in
            
            // Get username
            let username = (data[0] as? String)!
            
            // Send system message
            let message = Message(username: "System", message: "\(username) connected")
            self.messages.append(message)
            self.tableView.reloadData()
        }
        
        socket?.on("chat message") { data, ack in
            
            let username = (data[0] as? String)!
            let messageText = (data[1] as? String)!
            
            // Then add it to array
            let message = Message(username: username, message: messageText)
            self.messages.append(message)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func onSend(_ sender: Any) {
        let inputText = inputField.text ?? ""
        
        if inputText != "" {
            
            // Emit message to server
            socket?.emit("chat message", inputText)
            
            // Clear text
            inputField.text = ""
        }
    }
    
    
    // MARK: - Helper functions
    func randomString(length: Int) -> String {
        
        let letters : NSString = "0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    
    // MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "message") as! MessageCell
        cell.usernameLabel.text = messages[indexPath.row].username
        cell.messageLabel.text = messages[indexPath.row].message
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Do nothing
    }
    
    

}

