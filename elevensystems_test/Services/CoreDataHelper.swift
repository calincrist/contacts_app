//
//  CoreDataHelper.swift
//  elevensystems_test
//
//  Created by Calin Cristian on 26/02/2020.
//  Copyright © 2020 Calin Cristian Ciubotariu. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHelper: NSObject {
    
    let container:NSPersistentContainer
    
    override init() {
        container = NSPersistentContainer(name: "elevensystems_test")
        container.loadPersistentStores { (storeDesc, error) in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            
            print(storeDesc)
        }
        super.init()
    }
    
    func addContact(_ newContact: ContactItem) {
        
        let contact = Contact(context: container.viewContext)
        contact.contactID = newContact.contactID
        contact.firstName = newContact.firstName
        contact.lastName = newContact.lastName
        contact.phoneNumber = newContact.phoneNumber
        contact.streetAddress1 = newContact.streetAddress1
        contact.streetAddress2 = newContact.streetAddress2
        contact.city = newContact.city
        contact.state = newContact.state
        contact.zipCode = newContact.zipCode
        
        print("Adding contact...", newContact.phoneNumber)
        
        save()
    }
    
    func fetchContact(by contactID: String) -> ContactItem? {
        
        let managedContext = container.viewContext
        let request: NSFetchRequest<Contact> = Contact.fetchRequest()
        let predicate = NSPredicate(format: "contactID = %s", contactID)
        request.predicate = predicate
        
        var fetchedContacts: [ContactItem] = []
        
        do {
            let fetchResult = try managedContext.fetch(request)
            for contactData in fetchResult {
                fetchedContacts.append(ContactItem(data: contactData))
            }
        } catch {
            print("Failed to fetch contacts: (error)")
        }
        
        return fetchedContacts[0]
    }
    
    func fetchAllContacts() -> [ContactItem] {
        
        print("Fetching all contacts...");
        
        let managedContext = container.viewContext
        let request: NSFetchRequest<Contact> = Contact.fetchRequest()
        var fetchedContacts: [ContactItem] = []
        
        do {
            let fetchResult = try managedContext.fetch(request)
            for contactData in fetchResult {
                fetchedContacts.append(ContactItem(data: contactData))
            }
        } catch {
            print("Failed to fetch contacts: (error)")
        }
        
        return fetchedContacts
    }
    
    fileprivate func save() {
        do {
            if container.viewContext.hasChanges {
                try container.viewContext.save()
            }
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
}
