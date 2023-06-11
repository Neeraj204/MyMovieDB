//
//  Extensio.swift
//  MyMovieDB
//
//  Created by Neeraj on 10/06/23.
//

import UIKit

//MARK: - DispatchQueue
func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}

func mainThread(_ completion: @escaping () -> ()) {
    DispatchQueue.main.async {
        completion()
    }
}

//userInteractive
//userInitiated
//default
//utility
//background
//unspecified
func backgroundThread(_ qos: DispatchQoS.QoSClass = .userInitiated , completion: @escaping () -> ()) {
    DispatchQueue.global(qos:qos).async {
        completion()
    }
}


let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImage(withUrl urlString: String) {
        let url = URL(string: urlString)
        if url == nil {return}
        self.image = nil

        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }

        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activityIndicator.style = .medium
        } else {
            activityIndicator.style = .gray
        }
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center

        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            guard error == nil else {
                print(error!)
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    activityIndicator.removeFromSuperview()
                }
            }

        }).resume()
    }
}

//MARK: - Private methods
extension UIViewController {
    func displayErrorMessage(_ errorMessage: String) {
        let alertController = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
