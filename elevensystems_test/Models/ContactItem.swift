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
    
    var fullName: String {
        var endResult = ""
        if let firstName = firstName {
            endResult += firstName
        }
        
        if let lastName = lastName {
            endResult += " \(lastName)"
        }
        
        return endResult
    }
}

extension ContactItem {

    init(data: Contact) {
        
        self.contactID = data.contactID
        
        self.firstName = data.firstName
        self.lastName = data.lastName
        self.phoneNumber = data.phoneNumber
        
        self.streetAddress1 = data.streetAddress1
        self.streetAddress2 = data.streetAddress2

        self.state = data.state
        self.city = data.city

        self.zipCode = data.zipCode
    }
}
