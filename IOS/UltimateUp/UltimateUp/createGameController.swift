//
//  createGameController.swift
//  UltimateUp
//
//  Created by Beck Pang on 5/14/15.
//  Copyright (c) 2015 University of Washington, Seattle. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Socket_IO_Client_Swift

class createGameController: UIViewController {
    // Setting for segue
    var setting: Bool = false {
        didSet {
            title = "\(setting)"
        }
    }

    let socket = SocketIOClient(socketURL: "52.4.253.222/mobi")
    
//    struct loginJSON {
//        var user_id: String!
//        var fb_id: String!
//        var fb_token: String!
//        func simpleDescription() -> String {
//            return "The \(user_id) has a FB ID of \(fb_id) and FB token of \(fb_token)"
//        }
//    }
    
    @IBAction func socket(sender: UIButton) {
        print("use socket", appendNewline: false)
        
        socket.on("connect") {data, ack in
            print("socket connected")
            print(data)
            print(ack)
        }
        
        socket.emitWithAck("hello world", "Beck") (timeout: 10) { data in
            print("hello world")
        }
        
        socket.onAny {print("Got event: \($0.event), with items: \($0.items)")}
        
//        let loginOne: loginJSON = loginJSON(
//            user_id: "beck",
//            fb_id:  FBSDKAccessToken.currentAccessToken().userID,
//            fb_token: FBSDKAccessToken.currentAccessToken().tokenString)
//        
//        socket.emitWithAck("fb_login", loginOne) (timeout: 10) { data in
//            print(data)
//        }
        
        socket.connect()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
    }
}
