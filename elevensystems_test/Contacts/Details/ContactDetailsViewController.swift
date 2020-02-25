//
//  ContactDetailsViewController.swift
//  elevensystems_test
//
//  Created by Calin Cristian on 25/02/2020.
//  Copyright © 2020 Calin Cristian Ciubotariu. All rights reserved.
//

import UIKit
import os.log

class ContactDetailsViewController: UIViewController {

    //  MARK: -IBOutlets
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var sendEmailButton: UIButton!
    
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var streetAddress1Label: UILabel!
    @IBOutlet weak var streetAddress2Label: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var zipCodeLabel: UILabel!
    
    
    @IBOutlet weak var lastNameTextInput: UITextField!
    @IBOutlet weak var firstNameTextInput: UITextField!
    @IBOutlet weak var phoneNumberTextInput: UITextField!
    @IBOutlet weak var streetAddress1TextInput: UITextField!
    @IBOutlet weak var streetAddress2TextInput: UITextField!
    @IBOutlet weak var cityTextInput: UITextField!
    @IBOutlet weak var stateTextInput: UITextField!
    @IBOutlet weak var zipCodeTextInput: UITextField!
    
    @IBOutlet weak var phoneNumberViewStack: UIStackView!
    @IBOutlet weak var phoneNumberEditStack: UIStackView!
    @IBOutlet weak var addressViewStack: UIStackView!
    @IBOutlet weak var addressEditStack: UIStackView!
    
    @IBOutlet weak var displayViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var editViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var editView: UIView!
    
    var contact: [String: String]?
    var editableState: Bool = false
    var newContact: Bool = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init() {
        self.init(contact: nil)
    }
    
    init(contact: [String: String]?) {
        self.contact = contact
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let _ = contact {
            initializeView()
        } else {
            editableState = true
        }
        
        configureView(forState: editableState)
        
        
//        let buttonSystemItem =  editableState ? UIBarButtonItem.SystemItem.save : UIBarButtonItem.SystemItem.edit
//        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: buttonSystemItem, target: self, action: #selector(editContact))
//        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    func initializeView() {
        if let firstName = contact?["firstName"],
            let lastName = contact?["lastName"] {
                fullNameLabel?.text = "\(firstName) \(lastName)"
            
            firstNameTextInput.text = firstName
            lastNameTextInput.text = lastName
        }
        
        if let phoneNumber = contact?["phoneNumber"] {
            phoneNumberLabel.text = phoneNumber
            phoneNumberTextInput.text = phoneNumber
            
            phoneNumberTextInput.isEnabled = true
        }
        
        if let streetAddress1 = contact?["streetAddress1"] {
            streetAddress1Label.text = streetAddress1
            streetAddress1TextInput.text = streetAddress1
        }
        
        if let streetAddress2 = contact?["streetAddress2"] {
            streetAddress2Label.text = streetAddress2
            streetAddress2TextInput.text = streetAddress2
        }
        
        if let city = contact?["city"] {
            cityLabel.text = city
            cityTextInput.text = city
        }
        
        if let state = contact?["state"] {
            stateLabel.text = state
            stateTextInput.text = state
        }
        
        if let zipCode = contact?["zipCode"] {
            zipCodeLabel.text = zipCode
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
    
    @objc func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    @objc func editContact() {
        editableState = true
        firstNameTextInput.becomeFirstResponder()
        configureView(forState: editableState)
    }
    
    @objc func saveContact() {
        editableState = false
        configureView(forState: editableState)
        
        
        if firstNameTextInput.isFirstResponder {
            firstNameTextInput.resignFirstResponder()
        }
        
        if lastNameTextInput.isFirstResponder {
            lastNameTextInput.resignFirstResponder()
        }
        
        if phoneNumberTextInput.isFirstResponder {
            phoneNumberTextInput.resignFirstResponder()
        }
        
        if streetAddress1TextInput.isFirstResponder {
            streetAddress1TextInput.resignFirstResponder()
        }
        
        if streetAddress2TextInput.isFirstResponder {
            streetAddress2TextInput.resignFirstResponder()
        }
        
        if cityTextInput.isFirstResponder {
            cityTextInput.resignFirstResponder()
        }
        
        if stateTextInput.isFirstResponder {
            stateTextInput.resignFirstResponder()
        }
        
        if zipCodeTextInput.isFirstResponder {
            zipCodeTextInput.resignFirstResponder()
        }
        
        if newContact {
            //  TODO: save action
            navigationController?.popViewController(animated: true)
        }
    }
    
    func configureView(forState state: Bool) {
        addressEditStack.isHidden = !state
        addressViewStack.isHidden = state
        
        phoneNumberEditStack.isHidden = !state
        phoneNumberViewStack.isHidden = state
        
        editView.isUserInteractionEnabled = true
        
        let buttonSystemItem =  state ? UIBarButtonItem.SystemItem.save : UIBarButtonItem.SystemItem.edit
        let barButtonAction = state ?  #selector(saveContact) : #selector(editContact)
        
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: buttonSystemItem, target: self, action: barButtonAction)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        displayViewConstraint.constant = state ? 0 : 200
        editViewConstraint.constant = state ? 240 : 0
        
        
        UIView.animate(withDuration: 500, animations: {
            self.displayView.isHidden = state
            self.editView.isHidden = !state
            self.editView.layoutIfNeeded()
            self.displayView.layoutIfNeeded()
        });
        
    }
}


//  MARK: -UITextFieldDelegate
extension ContactDetailsViewController: UITextFieldDelegate {
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
