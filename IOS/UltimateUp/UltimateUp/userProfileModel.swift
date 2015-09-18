//
//  userProfileModel.swift
//  UltimateUp
//
//  Created by Beck Pang on 9/16/15.
//  Copyright © 2015 University of Washington, Seattle. All rights reserved.
//

import Foundation

public class userProfile: NSObject
{
    public let id: String!
    public let name: String!
    
    override public var description: String {
        return "\(name) has id of \(id)"
    }
    
    init?(data:NSDictionary?) {
        id = data?.valueForKey("id") as? String
        name = data?.valueForKey("name") as? String
    }
}
