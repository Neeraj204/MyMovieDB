//
//  CoreDataBaseHelper.swift
//  MyMovieDB
//
//  Created by Neeraj on 11/06/23.
//

import Foundation
import CoreData
import UIKit

class CoreDataBaseHelper{
    static var sharedInstance = CoreDataBaseHelper()
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func saveData(object: [MovieResult]) {
        for dictData in object {

            let list = NSEntityDescription.insertNewObject(forEntityName: Constant.kMovieResultTable, into: context!) as! MovieResultTable
            
            list.id = Int32(dictData.id!)
            list.posterPath = dictData.posterPath
            list.title = dictData.title
            list.overview = dictData.overview
            
            do {
                try context?.save()
            } catch {
                print("data is Not Save")
            }
        }
    }
    
    func getData() -> [MovieResultTable] {
        var list = [MovieResultTable]()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constant.kMovieResultTable)
        
        do {
            list = try context?.fetch(fetchRequest) as! [MovieResultTable]
        } catch {
            print("can not Get Data")
        }
        return list
    }
}
