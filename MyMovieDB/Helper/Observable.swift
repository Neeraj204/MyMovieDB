//
//  Observable.swift
//  MyMovieDB
//
//  Created by Neeraj on 10/06/23.
//

import Foundation

class Observable<T> {
    typealias Listener = ((T?) -> Void)
    var listener: Listener?
    
    var value: T? {
        didSet {
            mainThread {
                self.listener?(self.value)
            }
        }
    }
    
    init(_ value: T?) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
