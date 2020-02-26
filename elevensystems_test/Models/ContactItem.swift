//
//  ContactItem.swift
//  elevensystems_test
//
//  Created by Calin Cristian on 26/02/2020.
//  Copyright © 2020 Calin Cristian Ciubotariu. All rights reserved.
//

import Foundation

struct ContactItem: Codable {
    var contactID: String?
    var firstName: String?
    var lastName: String?
    var phoneNumber: String?
    var streetAddress1: String?
    var streetAddress2: String?
    var state: String?
    var city: String?
    var zipCode: String?
}

//extension ContactItem {
//    
//    init(dict: [String:AnyObject]) {
//        self.contactID = dict["contactID"] as? String
//        self.firstName = dict["firstName"] as? String
//        self.lastName = dict["lastName"] as? String
//        self.streetAddress1 = dict["streetAddress1"] as? String
//        self.streetAddress2 = dict["streetAddress2"] as? String
//        
//        self.state = dict["state"] as? String
//        self.city = dict["city"] as? String
//        
//        self.zipCode = dict["zipCode"] as? String
//    }
//}
