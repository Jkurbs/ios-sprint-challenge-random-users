//
//  UserDetailsViewController.swift
//  Random Users
//
//  Created by Kerby Jean on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var user: User?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateViews()
    }
    

    func updateViews() {
//        nameLabel.text = user?.name.first
//        imageView.image = image
    }

}
