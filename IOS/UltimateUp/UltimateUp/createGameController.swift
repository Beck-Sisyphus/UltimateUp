//
//  createGameController.swift
//  UltimateUp
//
//  Created by Beck Pang on 5/14/15.
//  Copyright (c) 2015 University of Washington, Seattle. All rights reserved.
//

import UIKit
import FBSDKLoginKit
//import Socket_IO_Client_Swift

// Not used anymore

class createGameController: UIViewController {

//    let socket = SocketIOClient(socketURL: "52.4.253.222:mobi")
    
    @IBAction func socket(sender: UIButton) {
        print("use socket", terminator: "\n")
        
//        socket.on("connect") {data, ack in
//            print("socket connected", terminator:"\n")
//            print(data, terminator:"\n")
//            print(ack, terminator:"\n")
//        }
//        socket.emitWithAck("connect") (timeoutAfter: 3) { data in
//            print("hello \(data)", terminator:"\n")
//        }
//
//        socket.emit("hello", "Beck")
//
//        let loginDic = [
//           "fb_token"  :  FBSDKAccessToken.currentAccessToken().tokenString,
//           "fb_id"     :  FBSDKAccessToken.currentAccessToken().userID,
//           "user_id"   :  "beck"
//           ]
//
//        socket.emitWithAck("fb_login", loginDic) (timeoutAfter: 4) { data in
//           print(data, terminator:"\n")
//        }
//
//        socket.emitWithAck("fb_login",
//           "fb_token", FBSDKAccessToken.currentAccessToken().tokenString,
//           "fb_id",    FBSDKAccessToken.currentAccessToken().userID,
//           "user_id",  "beck") (timeoutAfter: 4) { print($0) }
        
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

