//
//  URLAddressManager.swift
//  TriviaApp
//
//  Created by Saiful I. Wicaksana on 18/11/17.
//  Copyright © 2017 icaksama. All rights reserved.
//

import Foundation

class URLAddressManager {
    
    /** List of Question Types */
    internal enum DifficultTypes: String {
        case easy = "easy"
        case medium = "medium"
        case hard = "hard"
    }
    
    /** List of Question Types */
    internal enum QuestionTypes: String {
        case multiple = "multiple"
        case trueOrFalse = "boolean"
    }
    
    /** Get API Base URL */
    internal let BASE_URL: String = "http://opentdb.com"
    
    /** Get URL API for master category */
    internal func getAPICategory() -> String {
        return BASE_URL + "/api_category.php"
    }
    
    /** Get URL API for Question */
    internal func getAPIQuestion(categoryId: Int, amount: Int, difficulty: DifficultTypes, questionType: QuestionTypes) -> String {
        return BASE_URL + "/api.php?amount=\(amount)&category=\(categoryId)&difficulty=\(difficulty.rawValue)&type=\(questionType.rawValue)"
    }
}
