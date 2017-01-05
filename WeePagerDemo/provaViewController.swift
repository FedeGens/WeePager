//
//  provaViewController.swift
//  MyPager
//
//  Created by Federico Gentile on 02/01/17.
//  Copyright © 2017 Federico Gentile. All rights reserved.
//

import Foundation
import UIKit

class ProvaViewController: UIViewController {
    
    @IBOutlet weak var tableView_: BasicTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "miao")
        for i in 0...10 {
            
            tableView_.addBasicCell(withType: .textImage, inSection: 0, atIndex: nil, withTitle: "Cell number "+String(i), withSubtitle: nil, withImage: image)
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
