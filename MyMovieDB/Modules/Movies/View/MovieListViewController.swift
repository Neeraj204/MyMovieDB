//
//  MovieListViewController.swift
//  MyMovieDB
//
//  Created by Neeraj on 10/06/23.
//

import UIKit
import CoreData

class MovieListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel = MovieListViewModel()
    
    private var isViewLoad: Bool = false
    private var isDataAvailable: Bool = false
    
    private var movieResultData : [MovieResultTable] = {
        CoreDataBaseHelper.sharedInstance.getData()
    }()
    
    //MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkOfflineData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isViewLoad { return }
        isViewLoad = true
        initialize()
    }
    
    //MARK: - Setup
    func checkOfflineData() {
        self.movieResultData.forEach { data in
            let obj = MovieResult(posterPath: data.posterPath ?? "", id: Int(data.id), title: data.title ?? "", overview: data.overview ?? "")
            
            self.viewModel.movieList.value?.append(obj)
        }
        self.isDataAvailable = self.movieResultData.count == 0 ? false : true
    }
    
    func initialize() {
        if !self.isDataAvailable {
            fetchMovies()
        }
        bindUI()
    }
    
    //MARK: - Update UI
    func bindUI() {
        viewModel.movieList.bind { _ in
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - API calls
    func fetchMovies() {
        if !Reachability.isConnectedToNetwork() {
            self.displayErrorMessage("Internet Connection is not Available!")
            return
        }
        self.viewModel.fatchMovies(view) { errorString in
            if let errorString = errorString {
                self.displayErrorMessage(errorString)
            }
        }
    }
}

//MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.movieList.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: Constant.kMoviesCell, for: indexPath) as! MoviesCell
        
        cell.loadData(data: (self.viewModel.movieList.value?[indexPath.item])!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVc = StoryBoardIdentifier.DetailViewController.viewController as! DetailViewController
        detailVc.movieData = self.viewModel.movieList.value?[indexPath.item]
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !self.isDataAvailable {
            if self.viewModel.pagination.page <= self.viewModel.pagination.totalPage && indexPath.item == self.viewModel.movieList.value!.count - 1 {
                fetchMovies()
            }
        }
    }
}
