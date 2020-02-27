//
//  EditInfoViewController.swift
//  elevensystems_test
//
//  Created by Calin Cristian on 26/02/2020.
//  Copyright © 2020 Calin Cristian Ciubotariu. All rights reserved.
//

import UIKit


protocol EditableContactDelegate: class {
    func updatedInfo(updatedContact: ContactItem?)
}


class EditInfoViewController: UIViewController {

    @IBOutlet weak var lastNameTextInput: UITextField!
    @IBOutlet weak var firstNameTextInput: UITextField!
    @IBOutlet weak var phoneNumberTextInput: UITextField!
    @IBOutlet weak var streetAddress1TextInput: UITextField!
    @IBOutlet weak var streetAddress2TextInput: UITextField!
    @IBOutlet weak var cityTextInput: UITextField!
    @IBOutlet weak var stateTextInput: UITextField!
    @IBOutlet weak var zipCodeTextInput: UITextField!
    
    weak var delegate: EditableContactDelegate!
    
    var contact: ContactItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeView()
    }

    func initializeView() {
        
        if let firstName = contact?.firstName {
            firstNameTextInput.text = firstName
        }
        
        if let lastName = contact?.lastName {
            lastNameTextInput.text = lastName
        }
        
        if let phoneNumber = contact?.phoneNumber {
            phoneNumberTextInput.text = phoneNumber
            phoneNumberTextInput.isEnabled = true
        }
        
        if let streetAddress1 = contact?.streetAddress1 {
            streetAddress1TextInput.text = streetAddress1
        }
        
        if let streetAddress2 = contact?.streetAddress2 {
            streetAddress2TextInput.text = streetAddress2
        }
        
        if let city = contact?.city {
            cityTextInput.text = city
        }
        
        if let state = contact?.state {
            stateTextInput.text = state
        }
        
        if let zipCode = contact?.zipCode {
            zipCodeTextInput.text = zipCode
        }
        
        firstNameTextInput.delegate = self
        lastNameTextInput.delegate = self
        phoneNumberTextInput.delegate = self
        streetAddress1TextInput.delegate = self
        streetAddress2TextInput.delegate = self
        cityTextInput.delegate = self
        stateTextInput.delegate = self
        zipCodeTextInput.delegate = self
    }
}

extension EditInfoViewController: ContactActionDelegate {
    func saveAction() {
        
        print("saveAction called", delegate!)

        var contactCopy: ContactItem? = nil
        
        if let contact = contact {
            contactCopy = contact
        } else {
            contactCopy = ContactItem()
            contactCopy?.contactID = UUID().uuidString
        }
        
        contactCopy?.firstName = firstNameTextInput.text
        contactCopy?.lastName = lastNameTextInput.text
        contactCopy?.phoneNumber = phoneNumberTextInput.text
        contactCopy?.streetAddress1 = streetAddress1TextInput.text
        contactCopy?.streetAddress2 = streetAddress2TextInput.text
        contactCopy?.city = cityTextInput.text
        contactCopy?.state = stateTextInput.text
        contactCopy?.zipCode = zipCodeTextInput.text
        
        delegate.updatedInfo(updatedContact: contactCopy)
    }
}


//  MARK: -UITextFieldDelegate

extension EditInfoViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case firstNameTextInput:
            firstNameTextInput.resignFirstResponder()
            lastNameTextInput.becomeFirstResponder()
            
        case lastNameTextInput:
            lastNameTextInput.resignFirstResponder()
            phoneNumberTextInput.becomeFirstResponder()
            
        case phoneNumberTextInput:
            phoneNumberTextInput.resignFirstResponder()
            streetAddress1TextInput.becomeFirstResponder()
            
        case streetAddress1TextInput:
            streetAddress1TextInput.resignFirstResponder()
            streetAddress2TextInput.becomeFirstResponder()
            
        case streetAddress2TextInput:
            streetAddress2TextInput.resignFirstResponder()
            cityTextInput.becomeFirstResponder()
            
        case cityTextInput:
            cityTextInput.resignFirstResponder()
            stateTextInput.becomeFirstResponder()
            
        case stateTextInput:
            stateTextInput.resignFirstResponder()
            zipCodeTextInput.becomeFirstResponder()
            
        case zipCodeTextInput:
            zipCodeTextInput.resignFirstResponder()
            
        default: break
            
        }
        
        
        return true
    }
}
