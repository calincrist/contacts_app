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
    var contacts = [[
        "contactID": "1",
        "firstName": "Calin",
        "lastName": "Ciubotariu",
        "phoneNumber": "07123123123",
        "streetAddress1": "Strada Nicolae Iroga",
        "streetAddress2": "nr. -, bl. 62, sc. A",
        "city": "Vaslui",
        "state": "Florida",
        "zipCode": "402123"
    ], [
        "contactID": "2",
        "firstName": "Calin2",
        "lastName": "Ciubotariu2",
        "phoneNumber": "07123123124",
        "streetAddress1": "Strada Nicolae Iroga",
        "streetAddress2": "nr. -, bl. 62, sc. A",
        "city": "Vaslui",
        "state": "Florida",
        "zipCode": "402123"
    ]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContact))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    @objc func addContact() {
        let navigationController = self.navigationController
        let detailsViewController: ContactDetailsViewController = ContactDetailsViewController()
        detailsViewController.newContact = true
        
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as? ContactTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ContactTableViewCell.")
        }
        
        
        let contact = contacts[indexPath.row]
        
        if let firstName = contact["firstName"],
            let lastName = contact["lastName"] {
                cell.fullNameLabel?.text = "\(firstName) \(lastName)"
        }
        
        if let phoneNumber = contact["phoneNumber"] {
            cell.phoneNumberLabel?.text = phoneNumber
        }
        
        
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = contacts[indexPath.row]
        
        let navigationController = self.navigationController
        let detailsViewController: ContactDetailsViewController = ContactDetailsViewController()
        detailsViewController.contact = contact
        
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        // 1
        let deleteHandler: UIContextualAction.Handler = { [weak self] action, view, callback in
            self?.contacts.remove(at: indexPath.row);
            
            self?.tableView.beginUpdates()
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
            self?.tableView.endUpdates()
            
            callback(true)
        }

      // 2
      let deleteAction = UIContextualAction(style: .destructive,
                                            title: "Delete",
                                            handler: deleteHandler)

      // 3
      return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

