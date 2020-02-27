//
//  DisplayInfoViewController.swift
//  elevensystems_test
//
//  Created by Calin Cristian on 26/02/2020.
//  Copyright © 2020 Calin Cristian Ciubotariu. All rights reserved.
//

import UIKit

class DisplayInfoViewController: UIViewController {
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var streetAddress1Label: UILabel!
    @IBOutlet weak var streetAddress2Label: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var zipCodeLabel: UILabel!
    
    var contact: ContactItem?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "DisplayInfoViewController", bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeView()
    }
    
    func initializeView() {
        
        if let phoneNumber = contact?.phoneNumber {
            phoneNumberLabel.text = phoneNumber
        }
        
        if let streetAddress1 = contact?.streetAddress1 {
            streetAddress1Label.text = streetAddress1
        }
        
        if let streetAddress2 = contact?.streetAddress2 {
            streetAddress2Label.text = streetAddress2
        }
        
        if let city = contact?.city {
            cityLabel.text = city
        }
        
        if let state = contact?.state {
            stateLabel.text = state
        }
        
        if let zipCode = contact?.zipCode {
            zipCodeLabel.text = zipCode
        }
    }
}
