//
//  CategoryModel.swift
//  TriviaApp
//
//  Created by Saiful I. Wicaksana on 18/11/17.
//  Copyright © 2017 icaksama. All rights reserved.
//

import Foundation
import CoreData

class CategoryModel {
    
    /** Parse JSON from server and save to core data */
    internal func parseAndSave(JSON: [String: Any], completion: @escaping(_ status: Bool) -> ()) {
        if let categories = JSON["trivia_categories"] as? [[String: Any]] {
            for category in categories {
                let id: Int = (category["id"]! as? Int) ?? 0
                let name: String = (category["name"]! as? String) ?? ""
                addCategory(categoryId: id, name: name)
            }
            completion(true)
        } else {
            // Error print special for developer
            print("Dev info : Nothing field with name trivia_categories in JSON")
            // Error message special for user
            completion(false)
        }
    }
    
    /** Add category data to core data */
    internal func addCategory(categoryId: Int, name: String) {
        if #available(iOS 10.0, *) {
            let category = Categories(context: CoreDataStack.managedObjectContext)
            category.id = Int16(categoryId)
            category.name = name
        } else {
            let entityDesc = NSEntityDescription.entity(forEntityName: "Categories", in: CoreDataStack.managedObjectContext)
            let category = Categories(entity: entityDesc!, insertInto: CoreDataStack.managedObjectContext)
            category.id = Int16(categoryId)
            category.name = name
        }
        CoreDataStack.saveContext()
    }
    
    /** Get all categories from core data */
    internal func getAllCategories() -> [Categories]? {
        let fetchRequest = NSFetchRequest<Categories>(entityName: "Categories")
        do {
            let fetchedResults = try CoreDataStack.managedObjectContext.fetch(fetchRequest)
            return fetchedResults
        } catch let error as NSError {
            print(error.description)
        }
        return nil
    }
    
    /** Get questions by id from core data */
    internal func getCategory(byId: Int) -> Categories? {
        let fetchRequest = NSFetchRequest<Categories>(entityName: "Categories")
        do {
            let fetchedResults = try CoreDataStack.managedObjectContext.fetch(fetchRequest)
            for category in fetchedResults {
                if category.id == byId {
                    return category
                }
            }
        } catch let error as NSError {
            print(error.description)
        }
        return nil
    }
}
