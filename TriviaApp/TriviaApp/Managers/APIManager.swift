//
//  APIManager.swift
//  TriviaApp
//
//  Created by Saiful I. Wicaksana on 19/11/17.
//  Copyright © 2017 icaksama. All rights reserved.
//

import Foundation
import Alamofire
import JGProgressHUD

class APIManager {
    
    fileprivate let urlAddress: URLAddressManager = URLAddressManager()
    fileprivate let categoryModel: CategoryModel = CategoryModel()
    fileprivate let questionModel: QuestionModel = QuestionModel()
    fileprivate let util: Utilities = Utilities()
    fileprivate let dialog = JGProgressHUD(style: .dark)
    
    /** Request master category from https://opentdb.com/ and save to coredata */
    internal func requestCategories(view: UIView, completion: @escaping(_ status: Bool, _ error: String) -> ()) {
        startDialog(view: view)
        if !util.isConnectedToInternet() {
            dismissDialog()
            completion(false, "No internet connection. Please check your internet connection and try again.")
            return
        }
        Alamofire.request(urlAddress.getAPICategory()).responseJSON { response in
            if response.response?.statusCode == 200 {
                if let json = response.result.value as? [String: Any] {
                    self.categoryModel.parseAndSave(JSON: json, completion: { (status) in
                        if status {
                            self.dismissDialog()
                            self.startDialogSuccess(view: view, completion: {
                                completion(true, "Request completed!")
                            })
                        } else {
                            self.dismissDialog()
                            completion(false, "Something wrong from server. Please try again later.")
                        }
                    })
                } else {
                    // Error print special for developer
                    print("Dev info : Data response is not JSON")
                    // Error message special for user
                    self.dismissDialog()
                    completion(false, "Something wrong from server. Please try again later.")
                }
            } else {
                self.dismissDialog()
                completion(false, (response.error?.localizedDescription)!)
            }
        }
    }
    
    /** Request question from https://opentdb.com/ by category id with maximum amount is 50 */
    internal func requestQuestions(view: UIView, byCategory: Categories, amount: Int, difficulty: URLAddressManager.DifficultTypes, questionType: URLAddressManager.QuestionTypes, completion: @escaping(_ status: Bool, _ error: String) -> ()) {
        startDialog(view: view)
        if !util.isConnectedToInternet() {
            dismissDialog()
            completion(false, "No internet connection. Please check your internet connection and try again.")
            return
        }
        let url: String = urlAddress.getAPIQuestion(categoryId: Int(byCategory.id), amount: amount, difficulty: difficulty, questionType: questionType)
        Alamofire.request(url).responseJSON { response in
            if response.response?.statusCode == 200 {
                if let json = response.result.value as? [String: Any] {
                    if let responseCode = json["response_code"] as? Int {
                        if responseCode == 0 {
                            self.questionModel.parseAndSave(JSON: json, category: byCategory, completion: { (status) in
                                if status {
                                    self.dismissDialog()
                                    self.startDialogSuccess(view: view, completion: {
                                        completion(true, "Request completed!")
                                    })
                                } else {
                                    self.dismissDialog()
                                    completion(false, "Something wrong from server. Please try again later.")
                                }
                            })
                        } else {
                            // Error print special for developer
                            print("Dev info : response code is \(responseCode)")
                            // Error message special for user
                            self.dismissDialog()
                            completion(false, "Something wrong from server. Please try again later.")
                        }
                    }
                } else {
                    // Error print special for developer
                    print("Dev info : Data response is not JSON")
                    // Error message special for user
                    self.dismissDialog()
                    completion(false, "Something wrong from server. Please try again later.")
                }
            } else {
                self.dismissDialog()
                completion(false, (response.error?.localizedDescription)!)
            }
        }
    }
    
    
    
    fileprivate func startDialogSuccess(view: UIView, completion: @escaping() -> ()) {
        let dialog = JGProgressHUD(style: .dark)
        dialog.textLabel.text = "Success"
        dialog.indicatorView = JGProgressHUDSuccessIndicatorView()
        dialog.show(in: view)
        dialog.dismiss(afterDelay: 0.5, animated: true)
        util.delay(second: 0.6) {
            completion()
        }
    }
    
    fileprivate func startDialog(view: UIView) {
        dialog.textLabel.text = "Loading"
        dialog.show(in: view)
    }
    
    fileprivate func dismissDialog() {
        dialog.dismiss(animated: true)
    }
}
