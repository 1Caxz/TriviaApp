//
//  QuestionModel.swift
//  TriviaApp
//
//  Created by Saiful I. Wicaksana on 18/11/17.
//  Copyright © 2017 icaksama. All rights reserved.
//

import Foundation
import CoreData

class QuestionModel {
    
    
    /** Parse JSON from server and save to core data */
    internal func parseAndSave(JSON: [String: Any], category: Categories, completion: @escaping(_ status: Bool) -> ()) {
        if let questions = JSON["results"] as? [[String: Any]] {
            for question in questions {
                let type: String = (question["type"] as? String) ?? ""
                let difficulty: String = (question["difficulty"] as? String) ?? ""
                let questions: String = (question["question"] as? String) ?? ""
                let correctAnswer: String = (question["correct_answer"] as? String) ?? ""
                let incorrectAnswers: [String] = (question["incorrect_answers"] as? [String]) ?? [String]()
                addQuestions(category: category, type: type, difficulty: difficulty, question: questions, correctAnswer: correctAnswer, incorrectAnswers: incorrectAnswers)
            }
            completion(true)
        } else {
            // Error print special for developer
            print("Dev info : Nothing field with name results in JSON")
            // Error message special for user
            completion(false)
        }
    }
    
    /** Add question and relation to core data */
    internal func addQuestions(category: Categories, type: String, difficulty: String, question: String, correctAnswer: String, incorrectAnswers: [String]) {
        if #available(iOS 10.0, *) {
            let questions = Questions(context: CoreDataStack.managedObjectContext)
            questions.category = category
            questions.type = type
            questions.difficulty = difficulty
            questions.question = question
            questions.correct_answer = correctAnswer
            questions.incorrect_answers = incorrectAnswers as NSObject
        } else {
            let entityDesc = NSEntityDescription.entity(forEntityName: "Questions", in: CoreDataStack.managedObjectContext)
            let questions = Questions(entity: entityDesc!, insertInto: CoreDataStack.managedObjectContext)
            questions.category = category
            questions.type = type
            questions.difficulty = difficulty
            questions.question = question
            questions.correct_answer = correctAnswer
            questions.incorrect_answers = incorrectAnswers as NSObject
        }
        CoreDataStack.saveContext()
    }

    /** Get all questions from core data */
    internal func getAllQuestions() -> [Questions]? {
        let fetchRequest = NSFetchRequest<Questions>(entityName: "Questions")
        do {
            let fetchedResults = try CoreDataStack.managedObjectContext.fetch(fetchRequest)
            return fetchedResults
        } catch let error as NSError {
            print(error.description)
        }
        return nil
    }

    /** Get questions by relation categories class */
    internal func getQuestions(byCategory: Categories) -> [Questions]? {
        var questions: [Questions] = [Questions]()
        let fetchRequest = NSFetchRequest<Questions>(entityName: "Questions")
        do {
            let fetchedResults = try CoreDataStack.managedObjectContext.fetch(fetchRequest)
            for question in fetchedResults {
                if question.category == byCategory {
                    questions.append(question)
                }
            }
            return questions
        } catch let error as NSError {
            print(error.description)
        }
        return nil
    }
}
