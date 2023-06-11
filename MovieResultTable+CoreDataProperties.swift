//
//  MovieResultTable+CoreDataProperties.swift
//  MyMovieDB
//
//  Created by Neeraj on 11/06/23.
//
//

import Foundation
import CoreData


extension MovieResultTable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieResultTable> {
        return NSFetchRequest<MovieResultTable>(entityName: "MovieResultTable")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var overview: String?
    @NSManaged public var posterPath: String?

}

extension MovieResultTable : Identifiable {

}
