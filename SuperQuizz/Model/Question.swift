//
//  Question.swift
//  SuperQuizz
//
//  Created by formation 1 on 04/12/2018.
//  Copyright © 2018 formation 1. All rights reserved.
//

import Foundation

class Question {
    private let id : Int?
    public var title : String = ""
    public var correctAnswer : Int = 0
    public var propositions = ["", "", "", ""]
    public var userChoice : Int?
    public var imageUrl : String?
    
    init(id : Int?, title : String, correctAnswer : Int, propositions : [String], imageUrl: String?) {
        self.id = id
        self.title = title
        self.correctAnswer = correctAnswer
        self.propositions = propositions
        self.imageUrl = imageUrl
    }
    
    public func getId() -> Int? {
        return id
    }
}
