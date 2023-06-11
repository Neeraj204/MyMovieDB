//
//  MoviesCell.swift
//  MyMovieDB
//
//  Created by Neeraj on 10/06/23.
//

import UIKit

class MoviesCell: UICollectionViewCell {
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func loadData(data: MovieResult) {
        self.imgMovie.loadImage(withUrl: WebServices.movieImagePath + data.posterPath)
        self.lblTitle.text = data.title
    }
}
