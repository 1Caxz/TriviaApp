//
//  ViewController.swift
//  TriviaApp
//
//  Created by Saiful I. Wicaksana on 18/11/17.
//  Copyright © 2017 icaksama. All rights reserved.
//

import UIKit
import CardViewList

class HomeViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    
    fileprivate var presenter: HomePresenter!
    internal var category: Categories!
    internal var questions: [Questions]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = HomePresenter(viewController: self, contentView: contentView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.addCardViews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "questions" {
            if let toViewController = segue.destination as? QuestionsViewController {
                toViewController.category = self.category
                toViewController.questions = self.questions
            }
        }
    }
}

