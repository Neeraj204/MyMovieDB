//
//  Constants.swift
//  MyMovieDB
//
//  Created by Neeraj on 10/06/23.
//

import UIKit

enum WebServices {
    
    static let APIKey = "d1d8c25e10f882d5e3ce7d93211074af"
    
    static let baseURL = "https://api.themoviedb.org/3"
    
    static let movieDetailPath = baseURL + "/movie/popular?api_key=\(APIKey)&page="
    
    static let movieImagePath = "https://image.tmdb.org/t/p/w185/"
}

enum AlertMessage {
    static let noDataFound = "No data found!"
}

struct Constant {
    /// Cell Identifiers
    static let kMoviesCell = "MoviesCell"
    
    /// Entity Name
    static let kMovieResultTable = "MovieResultTable"
    
}

//MARK:- StoryboardName
enum StoryboardName: String {
    case Main = "Main"
    
    var storyboard: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
}

enum StoryBoardIdentifier : String {
    case DetailViewController = "DetailViewController"
    
    var viewController: UIViewController {
        var storyBoard: UIStoryboard
        
        switch self {
            
        case .DetailViewController:
            storyBoard = StoryboardName.Main.storyboard
            break
            
        default:
            return UIViewController()
        }
        
        let controller = storyBoard.instantiateViewController(withIdentifier: self.rawValue)
        return controller
    }
}
