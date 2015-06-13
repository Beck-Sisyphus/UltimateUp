//
//  createGameController.swift
//  UltimateUp
//
//  Created by Beck Pang on 5/14/15.
//  Copyright (c) 2015 University of Washington, Seattle. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift

class createGameController: UIViewController {
    // Setting for segue
    var setting: Bool = false {
        didSet {
            title = "\(setting)"
        }
    }

    let serverURL = "52.4.253.222/mobi"
    let socket = SocketIOClient(socketURL: "52.4.253.222/mobi")
    
    @IBAction func socket(sender: UIButton) {
        print("use socket", appendNewline: false)
        
        socket.on("connect") {data, ack in
            print("socket connected")
        }
        
        socket.emitWithAck("hello world", "Beck") (timeout: 10) { data in
            print("hello world")
        }
        
        socket.connect()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
    }
}
