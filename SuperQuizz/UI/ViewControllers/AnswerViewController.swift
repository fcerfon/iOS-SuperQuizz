//
//  ViewController.swift
//  SuperQuizz
//
//  Created by formation 1 on 04/12/2018.
//  Copyright © 2018 formation 1. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {

    var question : Question!
    
    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var firstAnswer: UILabel!
    @IBOutlet weak var secondAnswer: UILabel!
    @IBOutlet weak var thirdAnswer: UILabel!
    @IBOutlet weak var fourthAnswer: UILabel!
    @IBOutlet weak var image: UIImageView!
    var onQuestionAnswered : ((_ question : Question, _ isCorrectAnswer : Bool) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionTitle.text = question.title
        firstAnswer.text = question.propositions[0]
        secondAnswer.text = question.propositions[1]
        thirdAnswer.text = question.propositions[2]
        fourthAnswer.text = question.propositions[3]
        
        if let imageName = question.image {
            if let resourcePath = Bundle.main.resourcePath {
                let path = resourcePath + "/" + imageName
                print(path)
            }
        }
    }
    
    func setOnResponseAnswered(closure : @escaping (_ question: Question,_ isCorrectAnswer :Bool)->()) {
        onQuestionAnswered = closure
    }
    
    func userDidChooseAnswer(isCorrectAnswer : Bool) {
        //TODO : Faire les animations de réussite ou d'échec
        
        self.dismiss(animated: true, completion: nil)
        onQuestionAnswered?(question, isCorrectAnswer)
        
    }
}

