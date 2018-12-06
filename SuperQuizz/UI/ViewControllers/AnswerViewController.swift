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

    @IBOutlet weak var firstAnswer: UIButton!
    @IBOutlet weak var secondAnswer: UIButton!
    @IBOutlet weak var thirdAnswer: UIButton!
    @IBOutlet weak var fourthAnswer: UIButton!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    var progressBarCancelled = false
    
    // DO NOT set this value to 0
    let PROGRESSBAR_MAX_TIME_IN_SECONDS : Float = 20.0
    
    @IBAction func onFirstAnswerClick(_ sender: Any) {
        question.userChoice = 1
        if (question.correctAnswer == 1) {
            userDidChooseAnswer(isCorrectAnswer: true)
        }
        else {
            userDidChooseAnswer(isCorrectAnswer: false)
        }
    }
    @IBAction func onSecondAnswerCllick(_ sender: Any) {
        question.userChoice = 2
        if (question.correctAnswer == 2) {
            userDidChooseAnswer(isCorrectAnswer: true)
        }
        else {
            userDidChooseAnswer(isCorrectAnswer: false)
        }
    }
    @IBAction func onThirdAnswerClick(_ sender: Any) {
        question.userChoice = 3
        if (question.correctAnswer == 3) {
            userDidChooseAnswer(isCorrectAnswer: true)
        }
        else {
            userDidChooseAnswer(isCorrectAnswer: false)
        }
    }
    @IBAction func onFourthAnswerClick(_ sender: Any) {
        question.userChoice = 4
        if (question.correctAnswer == 4) {
            userDidChooseAnswer(isCorrectAnswer: true)
        }
        else {
            userDidChooseAnswer(isCorrectAnswer: false)
        }
    }
    
    @IBOutlet weak var image: UIImageView!
    var onQuestionAnswered : ((_ question : Question, _ isCorrectAnswer : Bool) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionTitle.text = question.title
        firstAnswer.setTitle(question.propositions[0], for: .normal)
        secondAnswer.setTitle(question.propositions[1], for: .normal)
        thirdAnswer.setTitle(question.propositions[2], for: .normal)
        fourthAnswer.setTitle(question.propositions[3], for: .normal)

        if let imageName = question.image {
            if let resourcePath = Bundle.main.resourcePath {
                let path = resourcePath + "/" + imageName
                print(path)
            }
        }
        
        self.progressBar.progress = 0
        
        DispatchQueue.global(qos: .userInitiated).async {
            var barAdvance: Float = 0.0
            while barAdvance < 1.0 && !self.progressBarCancelled {
                Thread.sleep(forTimeInterval: 1)
                barAdvance += 1.0 / self.PROGRESSBAR_MAX_TIME_IN_SECONDS
                DispatchQueue.main.async {
                    self.progressBar.setProgress(barAdvance, animated: true)
                }
            }
            DispatchQueue.main.async {
                
                // if the progressBar is cancelled, we don't manage the view cancellation
                if !self.progressBarCancelled {
                    self.question.userChoice = -1
                    self.userDidChooseAnswer(isCorrectAnswer: false)
                }
            }
        }
    }
    
    func setOnResponseAnswered(closure : @escaping (_ question: Question,_ isCorrectAnswer :Bool)->()) {
        onQuestionAnswered = closure
    }
    
    func userDidChooseAnswer(isCorrectAnswer : Bool) {
        //TODO : Faire les animations de réussite ou d'échec
        progressBarCancelled = true
        self.dismiss(animated: true, completion: nil)
        onQuestionAnswered?(question, isCorrectAnswer)
    }
}

