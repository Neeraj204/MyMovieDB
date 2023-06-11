//
//  MoviePage.swift
//  MyMovieDB
//
//  Created by Neeraj on 10/06/23.
//

import Foundation

// MARK: - Main
struct MoviePage: Codable {
    let page, totalResults, totalPages: Int
    let results: [MovieResult]

    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Result
struct MovieResult: Codable {
    var posterPath: String
    var id: Int?
    var title: String
    var overview: String

    init(posterPath: String, id: Int? = nil, title: String, overview: String) {
        self.posterPath = posterPath
        self.id = id
        self.title = title
        self.overview = overview
    }
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case id
        case title
        case overview
    }
}
