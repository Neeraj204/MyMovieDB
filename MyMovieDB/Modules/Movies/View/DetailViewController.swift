//
//  DetailViewController.swift
//  MyMovieDB
//
//  Created by Mehul on 11/06/23.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAbout: UILabel!
    
    var movieData: MovieResult!
    
    //MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupData(self.movieData)
    }
    
    //MARK: - Setup data
    func setupData(_ data: MovieResult) {
        self.imgMovie.loadImage(withUrl: WebServices.movieImagePath + data.posterPath)
        self.lblTitle.text = data.title
        self.lblAbout.text = data.overview
    }
}
