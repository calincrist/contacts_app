//
//  ContactsDataManager.swift
//  elevensystems_test
//
//  Created by Calin Cristian on 26/02/2020.
//  Copyright © 2020 Calin Cristian Ciubotariu. All rights reserved.
//

import Foundation

class ContactsViewModel: NSObject {
    
    let manager = CoreDataHelper()
    
    private var contactItems: [ContactItem] = []
    
    func fetchAll() {
        if contactItems.count > 0 {
            contactItems.removeAll()
        }
        for contact in manager.fetchAllContacts() {
            contactItems.append(contact)
        }
    }
    
    func fetchContact(by contactID: String) -> ContactItem? {
        return manager.fetchContact(by: contactID)
    }
    
    func numberOfContacts() -> Int {
        return contactItems.count
    }
    
    func contactItem(at index: IndexPath) -> ContactItem {
        return contactItems[index.item]
    }
}
