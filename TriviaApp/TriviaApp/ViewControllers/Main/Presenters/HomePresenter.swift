//
//  MainPresenter.swift
//  TriviaApp
//
//  Created by Saiful I. Wicaksana on 19/11/17.
//  Copyright © 2017 icaksama. All rights reserved.
//

import Foundation
import UIKit
import CardViewList

class HomePresenter: CardViewListDelegete {
    
    fileprivate var categoryModel: CategoryModel!
    fileprivate var questionModel: QuestionModel!
    fileprivate var cardViewList: CardViewList!
    fileprivate var categories: [Categories] = [Categories]()
    fileprivate var apiManager: APIManager = APIManager()
    fileprivate var util: Utilities = Utilities()
    fileprivate var cardViews: [UIViewController] = [UIViewController]()
    fileprivate var isCreated: Bool = false
    
    fileprivate var contentView: UIView!
    fileprivate var viewController: HomeViewController!
    
    init(viewController: HomeViewController, contentView: UIView) {
        self.viewController = viewController
        self.contentView = contentView
        self.categoryModel = CategoryModel()
        self.questionModel = QuestionModel()
        self.cardViewList = CardViewList()
        self.cardViewList.delegete = self
    }
    
    func cardView(_ scrollView: UIScrollView, didSelectCardView cardView: UIView, identifierCards identifier: String, index: Int) {
        if categories.indices.contains(index) {
            let questions = questionModel.getQuestions(byCategory: categories[index])
            if questions!.count > 0 {
                self.viewController.category = categories[index]
                self.viewController.questions = questions
                self.viewController.performSegue(withIdentifier: "questions", sender: nil)
            } else {
                self.requestQuestions(category: categories[index], amount: 20, difficulty: .easy, questionType: .multiple)
            }
        } else {
            print("Index category out of bound")
        }
    }
    
    fileprivate func requestQuestions(category: Categories, amount: Int, difficulty: URLAddressManager.DifficultTypes, questionType: URLAddressManager.QuestionTypes) {
        apiManager.requestQuestions(view: self.contentView, byCategory: category, amount: amount, difficulty: difficulty, questionType: questionType) { (status, description) in
            if status {
                let questions = self.questionModel.getQuestions(byCategory: category)
                self.viewController.category = category
                self.viewController.questions = questions
                self.viewController.performSegue(withIdentifier: "questions", sender: nil)
            } else {
                print("Error \(description)")
                self.util.showErrorDialog(viewController: self.viewController, title: "Oops!", message: description, event: {
                    self.requestQuestions(category: category, amount: 10, difficulty: difficulty, questionType: questionType)
                })
            }
        }
    }
    
    /** Add CardViews to contentView */
    internal func addCardViews() {
        self.categories.removeAll()
        self.categories = categoryModel.getAllCategories()!
        for category in categories {
            let cardView = self.viewController.storyboard?.instantiateViewController(withIdentifier: "CardView") as! CardViewViewController
            cardView.imageBG = getImageBackground(category: category.name!)
            cardView.imageIcon = getImageIcon(category: category.name!)
            cardView.categoryName = category.name!
            cardViews.append(cardView)
        }
        self.cardViewList.animationScroll = .transformToRight
        self.cardViewList.grid = 2
        self.cardViewList.marginCards = 3
        self.cardViewList.maxHeight = 30
        self.cardViewList.isClickable = true
        self.cardViewList.isMultipleTouch = false
        self.cardViewList.clickAnimation = .bounce
        self.cardViewList.isShadowEnable = false
        if !isCreated && categories.count > 0 {
            self.isCreated = true
            self.cardViewList.generateCardViewList(containerView: contentView, viewControllers: cardViews, listType: .vertical, identifier: "Categories")
        }
    }
    
    fileprivate func getImageIcon(category: String) -> UIImage {
        if category.contains("Animals") {
            return UIImage(named: "ic_animals")!
        } else if category.contains("Books") {
            return UIImage(named: "ic_books")!
        } else if category.contains("Celebrities") {
            return UIImage(named: "ic_celebrities")!
        } else if category.contains("Computers") {
            return UIImage(named: "ic_computers")!
        } else if category.contains("Film") {
            return UIImage(named: "ic_film")!
        } else if category.contains("Games") {
            return UIImage(named: "ic_games")!
        } else if category.contains("General") {
            return UIImage(named: "ic_general")!
        } else if category.contains("History") {
            return UIImage(named: "ic_history")!
        } else if category.contains("Music") {
            return UIImage(named: "ic_music")!
        } else if category.contains("Television") {
            return UIImage(named: "ic_tv")!
        } else {
            return UIImage(named: "ic_general")!
        }
    }
    
    fileprivate func getImageBackground(category: String) -> UIImage {
        if category.contains("Animals") {
            return UIImage(named: "bg_animals")!
        } else if category.contains("Books") {
            return UIImage(named: "bg_books")!
        } else if category.contains("Celebrities") {
            return UIImage(named: "bg_celebrities")!
        } else if category.contains("Computers") {
            return UIImage(named: "bg_computers")!
        } else if category.contains("Film") {
            return UIImage(named: "bg_film")!
        } else if category.contains("Games") {
            return UIImage(named: "bg_games")!
        } else if category.contains("General") {
            return UIImage(named: "bg_general")!
        } else if category.contains("History") {
            return UIImage(named: "bg_history")!
        } else if category.contains("Music") {
            return UIImage(named: "bg_music")!
        } else if category.contains("Television") {
            return UIImage(named: "bg_tv")!
        } else {
            return UIImage(named: "bg_general")!
        }
    }
}
