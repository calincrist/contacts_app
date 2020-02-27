//
//  ContactDetailsViewController.swift
//  elevensystems_test
//
//  Created by Calin Cristian on 25/02/2020.
//  Copyright © 2020 Calin Cristian Ciubotariu. All rights reserved.
//

import UIKit
import MessageUI

import os.log

protocol ContactActionDelegate: class {
    func saveAction()
}

class ContactDetailsViewController: UIViewController {
    
    //  MARK: -IBOutlets
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    weak var contactActionDelegate: ContactActionDelegate!
    
    enum State {
        case display
        case edit
        case add
    }
    var state: State = .add
    var presentedContent: UIViewController = UIViewController()
    
    var contact: ContactItem?
    
    var coreData: CoreDataHelper?
    
    
    //  MARK: - Init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init() {
        self.init(contact: nil)
    }
    
    init(contact: ContactItem?) {
        self.contact = contact
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeView()
        
        configureBarButtonItem(forState: state)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    
    //  MARK: - Add content views
    
    func initializeView() {
        if let firstName = contact?.firstName,
            let lastName = contact?.lastName {
            fullNameLabel?.text = "\(firstName) \(lastName)"
        }
        
        presentedContent = viewController(for: state)
        presentedContent.view.frame = containerView.frame
        addChild(presentedContent)
        
        containerView.addSubview(presentedContent.view)
        presentedContent.didMove(toParent: self)
        
        setContentViewConstraints(for: presentedContent)
    }
    
    
    func addEditContentView() {
        
        presentedContent.willMove(toParent: nil)
        presentedContent.view.removeFromSuperview()
        presentedContent.removeFromParent()
        
        presentedContent = viewController(for: .edit)
        presentedContent.view.frame = containerView.frame
        addChild(presentedContent)
        
        containerView.addSubview(presentedContent.view)
        presentedContent.didMove(toParent: self)
        
        setContentViewConstraints(for: presentedContent)
    }
    
    func addDisplayContentView() {
        
        presentedContent.willMove(toParent: nil)
        presentedContent.view.removeFromSuperview()
        presentedContent.removeFromParent()
        
        presentedContent = viewController(for: .display)
        presentedContent.view.frame = containerView.frame
        addChild(presentedContent)
        
        containerView.addSubview(presentedContent.view)
        presentedContent.didMove(toParent: self)
        
        setContentViewConstraints(for: presentedContent)
    }
    
    func setContentViewConstraints(for viewController: UIViewController) {
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        viewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        viewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        
        viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        
    }
    
    @objc func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func configureBarButtonItem(forState state: State) {
    
        let buttonSystemItem =  state == .display ? UIBarButtonItem.SystemItem.edit : UIBarButtonItem.SystemItem.save
        let barButtonAction = state == .display ? #selector(editContact) : #selector(saveContact)
        
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: buttonSystemItem, target: self, action: barButtonAction)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    
    
    //  MARK: - Actions
    
    @objc func editContact() {
        state = .edit
        configureBarButtonItem(forState: state)
        addEditContentView()
    }
    
    @objc func saveContact() {
        
        contactActionDelegate.saveAction()
        addDisplayContentView()
        
        state = .display
        configureBarButtonItem(forState: state)
    }
    
    @IBAction func makeCall(_ sender: Any) {
        
        guard let phoneNumber = contact?.phoneNumber else {
            return
        }
    
        guard let url = URL(string: "tel://\(phoneNumber)") else {
            return
        }
        
        print("making a call to \(url)")
        
        UIApplication.shared.open(url)
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        
        guard MFMessageComposeViewController.canSendText() else {
            print("Cannot send text")
            return
        }
        
        guard let phoneNumber = contact?.phoneNumber else {
            return
        }
        
        let messageViewController = MFMessageComposeViewController()
        messageViewController.recipients = [phoneNumber]
        messageViewController.messageComposeDelegate = self
     
        present(messageViewController, animated: true, completion: nil)
    }
    
}

extension ContactDetailsViewController: EditableContactDelegate {
    func updatedInfo(updatedContact: ContactItem?) {
        
        switch state {
        case .add:
            coreData?.addContact(updatedContact!)
            navigationController?.popViewController(animated: true)
            
        case .edit:
            fullNameLabel.text = updatedContact!.fullName
            coreData?.updateContact(updatedContact!)
            
            contact = coreData?.fetchContact(by: updatedContact!.contactID!)
            view.setNeedsDisplay()
            
        default:
            break
        }
    }
}

extension ContactDetailsViewController: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            print("Cancelled")
            dismiss(animated: true, completion: nil)
            
        case .failed:
            print("Failed")
            dismiss(animated: true, completion: nil)
            
        case .sent:
            print("Sent!")
            dismiss(animated: true, completion: nil)
            
        default:
            break
        }
    }
}

private extension ContactDetailsViewController {
    
    func viewController(for state: State?) -> UIViewController {

        switch state {
        case .add:
            let destinationViewController = EditInfoViewController()
            
            destinationViewController.delegate = self
            contactActionDelegate = destinationViewController
            
            return destinationViewController
        
        case .edit:
            let destinationViewController = EditInfoViewController()
            destinationViewController.contact = contact
            
            destinationViewController.delegate = self
            contactActionDelegate = destinationViewController
            
            return destinationViewController
            
        case .display:
            let destinationViewController = DisplayInfoViewController()
            destinationViewController.contact = contact
            return destinationViewController
            
        default:
            return UIViewController()
        }
    }
}
