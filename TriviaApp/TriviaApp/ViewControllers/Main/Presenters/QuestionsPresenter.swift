//
//  QuestionsPresenter.swift
//  TriviaApp
//
//  Created by Saiful I. Wicaksana on 19/11/17.
//  Copyright © 2017 icaksama. All rights reserved.
//

import Foundation
import UIKit
import CardViewList

class QuestionsPresenter {
    
    fileprivate var viewController: QuestionsViewController!
    fileprivate let cardViewEffect: CardViewAnimation = CardViewAnimation()
    fileprivate var questionCounter: Int = 0
    fileprivate var rightAnswers: Int = 0
    fileprivate var wrongAnswers: Int = 0
    fileprivate var questions: [Questions]!
    fileprivate var buttons: [UIButton] = [UIButton]()
    fileprivate let util: Utilities = Utilities()
    
    init(viewController: QuestionsViewController) {
        self.viewController = viewController
        self.questions =  viewController.questions.shuffled()
        self.questionCounter = 0
        self.rightAnswers = 0
        self.wrongAnswers = 0
        self.buttons = [self.viewController.btnA, self.viewController.btnB, viewController.btnC, self.viewController.btnD]
        self.startStudy()
    }
    
    fileprivate func startStudy() {
        let question = self.questions[questionCounter]
        self.viewController.itemBarQuestionNumber.title = "Question no. \(questionCounter + 1)"
        self.viewController.itemBarRightAnswers.title = "\(rightAnswers) Right Answers"
        self.viewController.lblQuestion.text = question.question
        self.viewController.imgResponse.image = nil
        let options = getOptionsShuffled(question: question)
        for i in 0 ..< buttons.count {
            if options.indices.contains(i) {
                buttons[i].setTitle(options[i], for: .normal)
                if options[i] == question.correct_answer! {
                    buttons[i].tag = 1
                } else {
                    buttons[i].tag = 0
                }
            }
        }
        setEnableButtons(isEnable: true)
    }
    
    fileprivate func nextQuestion() {
        self.questionCounter += 1
        if questionCounter < questions.count {
            self.startStudy()
        } else {
            self.viewController.navigationController?.popViewController(animated: true)
        }
    }
    
    fileprivate func getOptionsShuffled(question: Questions) -> [String] {
        var option: [String] = [String]()
        option.append(question.correct_answer!)
        let incorectOptions = (question.incorrect_answers as! [String]).shuffled()
        for opt in incorectOptions {
            option.append(opt)
        }
        return option.shuffled()
    }
    
    fileprivate func setEnableButtons(isEnable: Bool) {
        for button in buttons {
            if isEnable {
                button.backgroundColor = util.colorFromHex(hex: "#f4f4f4")
            }
            button.isEnabled = isEnable
        }
        self.viewController.btnNext.isEnabled = !isEnable
        if isEnable {
            self.viewController.btnNext.backgroundColor = UIColor.lightGray
        } else {
            self.viewController.btnNext.backgroundColor = util.colorFromHex(hex: "#FB4040")
        }
    }
    
    fileprivate func setButtonOnTouch(view: UIView, button: UIButton) {
        cardViewEffect.bounce(view: view)
        setEnableButtons(isEnable: false)
        if button.tag == 1 {
            self.util.playAudio(name: "correct")
            self.rightAnswers += 1
            button.backgroundColor = util.colorFromHex(hex: "#50e3c2")
            self.viewController.imgResponse.image = UIImage(named: "correct")
        } else {
            self.util.playAudio(name: "wrong")
            self.wrongAnswers = (rightAnswers - 1) < 0 ? 0 : (rightAnswers - 1)
            button.backgroundColor = util.colorFromHex(hex: "#FB4040")
            self.viewController.imgResponse.image = UIImage(named: "wrong")
            for btn in buttons {
                if btn.tag == 1 {
                    let correctColor = util.colorFromHex(hex: "#50e3c2")
                    let normalColor = util.colorFromHex(hex: "#f4f4f4")
                    util.winxColorAnimation(view: btn, colorOne: correctColor, colorTwo: normalColor, duration: 0.2)
                }
            }
        }
        self.viewController.itemBarRightAnswers.title = "\(rightAnswers) Right Answers"
    }
    
    internal func btnAAction(view: UIView) {
        self.setButtonOnTouch(view: view, button: viewController.btnA)
    }
    
    internal func btnBAction(view: UIView) {
        self.setButtonOnTouch(view: view, button: viewController.btnB)
    }
    
    internal func btnCAction(view: UIView) {
        self.setButtonOnTouch(view: view, button: viewController.btnC)
    }
    
    internal func btnDAction(view: UIView) {
        self.setButtonOnTouch(view: view, button: viewController.btnD)
    }
    
    internal func btnNextAction() {
        self.nextQuestion()
    }
}
