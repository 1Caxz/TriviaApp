//
//  CardViewViewController.swift
//  TriviaApp
//
//  Created by Saiful I. Wicaksana on 19/11/17.
//  Copyright © 2017 icaksama. All rights reserved.
//

import UIKit

class CardViewViewController: UIViewController {
    
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblCategoryName: UILabel!
    
    internal var categoryName: String = ""
    internal var imageBG: UIImage = UIImage(named: "bg_general")!
    internal var imageIcon: UIImage = UIImage(named: "ic_general")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblCategoryName.adjustsFontSizeToFitWidth = true
        imgBackground.image = imageBG
        imgIcon.image = imageIcon
        lblCategoryName.text = categoryName
    }
}
