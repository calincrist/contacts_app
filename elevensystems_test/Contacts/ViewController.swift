//
//  ViewController.swift
//  elevensystems_test
//
//  Created by Calin Cristian on 24/02/2020.
//  Copyright © 2020 Calin Cristian Ciubotariu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = ContactsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContact))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        fetchInitialContacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.fetchAll()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchInitialContacts() {
        
        viewModel.fetchAll()
        
//        contacts = JSONLoader.loadJSON(file: "initialContacts")
//
//        let manager = CoreDataHelper()
//
//        for contact in contacts {
//            print("Adding", contact)
//            manager.addContact(contact)
//        }
    }

    @objc func addContact() {
        let navigationController = self.navigationController
        
        let detailsViewController = UIStoryboard(name: "ContactDetails",
                                                 bundle: nil).instantiateViewController(withIdentifier: "contactDetailsViewController") as! ContactDetailsViewController
        detailsViewController.state = .add
        detailsViewController.coreData = viewModel.manager
        
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfContacts()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as? ContactTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ContactTableViewCell.")
        }
        
        
        let contact = viewModel.contactItem(at: indexPath)
        
        if let firstName = contact.firstName,
            let lastName = contact.lastName {
                cell.fullNameLabel?.text = "\(firstName) \(lastName)"
        }
        
        if let contactID = contact.contactID {
            cell.phoneNumberLabel?.text = contactID
        }
        
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = viewModel.contactItem(at: indexPath)
        
        let detailsViewController = UIStoryboard(name: "ContactDetails",
                                                 bundle: nil).instantiateViewController(withIdentifier: "contactDetailsViewController") as! ContactDetailsViewController
        detailsViewController.contact = contact
        detailsViewController.coreData = viewModel.manager
        detailsViewController.state = .display
        
        
        let navigationController = self.navigationController
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteHandler: UIContextualAction.Handler = { [weak self] action, view, callback in
            
            guard let weakSelf = self else {
                return
            }
            
            let contact = weakSelf.viewModel.contactItem(at: indexPath)
            guard weakSelf.viewModel.deleteContact(contact) else {
                return
            }
            
            weakSelf.tableView.beginUpdates()
            weakSelf.tableView.deleteRows(at: [indexPath], with: .fade)
            weakSelf.tableView.endUpdates()
            
            callback(true)
        }
      let deleteAction = UIContextualAction(style: .destructive,
                                            title: "Delete",
                                            handler: deleteHandler)

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

