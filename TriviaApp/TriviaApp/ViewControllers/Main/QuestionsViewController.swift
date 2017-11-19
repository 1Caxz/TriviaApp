//
//  QuestionsViewController.swift
//  TriviaApp
//
//  Created by Saiful I. Wicaksana on 19/11/17.
//  Copyright © 2017 icaksama. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController {
    
    @IBOutlet weak var itemBarQuestionNumber: UIBarButtonItem!
    @IBOutlet weak var itemBarRightAnswers: UIBarButtonItem!
    @IBOutlet weak var lblQuestion: UILabel!
    
    @IBOutlet weak var lblA: UILabel!
    @IBOutlet weak var lblB: UILabel!
    @IBOutlet weak var lblC: UILabel!
    @IBOutlet weak var lblD: UILabel!
    
    @IBOutlet weak var btnA: UIButton!
    @IBOutlet weak var btnB: UIButton!
    @IBOutlet weak var btnC: UIButton!
    @IBOutlet weak var btnD: UIButton!
    
    @IBOutlet weak var viewA: UIView!
    @IBOutlet weak var viewB: UIView!
    @IBOutlet weak var viewC: UIView!
    @IBOutlet weak var viewD: UIView!
    
    @IBOutlet weak var imgResponse: UIImageView!
    
    @IBOutlet weak var btnNext: UIButton!
    
    fileprivate let util: Utilities = Utilities()
    fileprivate var presenter: QuestionsPresenter!
    
    internal var category: Categories!
    internal var questions: [Questions]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetting()
        self.presenter = QuestionsPresenter(viewController: self)
    }
    
    fileprivate func viewSetting() {
        // Setting button
        util.radiusCorner(views: btnA, btnB, btnC, btnD, radius: 20)
        util.borderView(views: btnA, btnB, btnC, btnD, borderWidth: 2, color: .black)
        btnA.titleLabel?.adjustsFontSizeToFitWidth = true
        btnA.titleLabel?.textAlignment = .center
        btnB.titleLabel?.adjustsFontSizeToFitWidth = true
        btnB.titleLabel?.textAlignment = .center
        btnC.titleLabel?.adjustsFontSizeToFitWidth = true
        btnC.titleLabel?.textAlignment = .center
        btnD.titleLabel?.adjustsFontSizeToFitWidth = true
        btnD.titleLabel?.textAlignment = .center
        
        // Setting label
        util.radiusCorner(views: lblA, lblB, lblC, lblD, radius: 17)
        util.borderView(views: lblA, lblB, lblC, lblD, borderWidth: 2, color: .lightGray)
    }
    
    @IBAction func btnAOnTouch(_ sender: Any) {
        presenter.btnAAction(view: viewA)
    }
    
    @IBAction func btnBOnTouch(_ sender: Any) {
        presenter.btnBAction(view: viewB)
    }
    
    @IBAction func btnCOnTouch(_ sender: Any) {
        presenter.btnCAction(view: viewC)
    }
    
    @IBAction func btnDOnTouch(_ sender: Any) {
        presenter.btnDAction(view: viewD)
    }
    
    @IBAction func btnNextOnTouch(_ sender: Any) {
        presenter.btnNextAction()
    }
    
    
}
