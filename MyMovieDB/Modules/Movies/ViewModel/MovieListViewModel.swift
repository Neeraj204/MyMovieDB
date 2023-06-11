//
//  MovieListViewModel.swift
//  MyMovieDB
//
//  Created by Neeraj on 10/06/23.
//

import UIKit

struct Pagination {
    var page: Int
    var lastPageReached: Bool
    var totalPage:Int = 3
}

class MovieListViewModel {
    var pagination = Pagination(page: 1, lastPageReached: false)
    
    var movieList: Observable<[MovieResult]> = Observable([])
}

extension MovieListViewModel {
    func fatchMovies(_ loaderInView: UIView, completion: @escaping (_ errorString: String?) -> Void) {
        
        if pagination.lastPageReached {
            completion(AlertMessage.noDataFound)
            return
        }
        
        APICall().get(apiUrl: WebServices.movieDetailPath + "\(pagination.page)", model: MoviePage.self, loaderInView: loaderInView) { [weak self] (result) in
            switch result {
            case .success(let response):

                self?.movieList.value?.append(contentsOf: response.results)
                CoreDataBaseHelper.sharedInstance.saveData(object: response.results)
                
                if self?.pagination.totalPage == self?.pagination.page {
                    self?.pagination.lastPageReached = true
                }
                self?.pagination.page += 1
                completion(nil)
            case .failure(let response):
                completion(response.message)
            case .error(let error):
                debugPrint(error?.localizedDescription ?? "")
                completion(error?.localizedDescription)
            }
        }
        
    }
}
