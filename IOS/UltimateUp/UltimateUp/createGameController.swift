//
//  createGameController.swift
//  UltimateUp
//
//  Created by Beck Pang on 5/14/15.
//  Copyright (c) 2015 University of Washington, Seattle. All rights reserved.
//

import UIKit
import FBSDKLoginKit
// import Socket_IO_Client_Swift

class createGameController: UIViewController {
    // Setting for segue
    var setting: Bool = false {
        didSet {
            title = "\(setting)"
        }
    }

//    let socket = SocketIOClient(socketURL: "52.4.253.222:mobi")
    
    @IBAction func socket(sender: UIButton) {
        print("use socket", appendNewline: true)
        
//        socket.on("connect") {data, ack in
//            print("socket connected")
//            print(data)
//            print(ack)
//        }
//        socket.emitWithAck("connect") (timeout: 3) { data in
//            print("hello \(data)")
//        }
//        
//        socket.emit("hello", "Beck")
        
//        let loginDic = [
//            "fb_token"  :  FBSDKAccessToken.currentAccessToken().tokenString,
//            "fb_id"     :  FBSDKAccessToken.currentAccessToken().userID,
//            "user_id"   :  "beck"
//            ]
        
//        socket.emitWithAck("fb_login", loginDic) (timeout: 4) { data in
//            print(data)
//        }
//        
//        socket.emitWithAck("fb_login",
//            "fb_token", FBSDKAccessToken.currentAccessToken().tokenString,
//            "fb_id",    FBSDKAccessToken.currentAccessToken().userID,
//            "user_id",  "beck") (timeout: 4) { print($0) }
        
        // I realize that there is no need to do the JSON by myself
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
//        socket.onAny {print("Got event: \($0.event), with items: \($0.items)")}
//        socket.connect()
    }
}
