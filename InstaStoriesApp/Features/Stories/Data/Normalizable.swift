//
//  Normalizable.swift
//  InstaStoriesApp
//
//  Created by Usman on 17.05.25.
//

import Foundation

protocol Normalizable {
    associatedtype Output
    
    func normalize() -> Output
}
