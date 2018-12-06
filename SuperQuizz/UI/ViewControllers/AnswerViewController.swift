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
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    var work : DispatchWorkItem?
    
    // DO NOT set this value to 0
    let progressMaxTimeInSeconds : Float = 3.0
    
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
    
    var onQuestionAnswered : ((_ question : Question, _ isCorrectAnswer : Bool) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionTitle.text = question.title
        firstAnswer.setTitle(question.propositions[0], for: .normal)
        secondAnswer.setTitle(question.propositions[1], for: .normal)
        thirdAnswer.setTitle(question.propositions[2], for: .normal)
        fourthAnswer.setTitle(question.propositions[3], for: .normal)
        
        if question.imageUrl != nil {
            CachedImages.instance.loadImageFromUrl(imageUrl: question.imageUrl!) { (data : Data) in
                self.image.image = UIImage(data: data)
            }
        }

        self.progressBar.progress = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        work = DispatchWorkItem {
            DispatchQueue.global(qos: .userInitiated).async {
                var barAdvance: Float = 0.0
                while barAdvance < 1.0 {
                    Thread.sleep(forTimeInterval: 0.01)
                    
                    if self.work?.isCancelled ?? false {
                        return
                    }
                    
                    barAdvance += 1.0 / (self.progressMaxTimeInSeconds * 100)
                    DispatchQueue.main.async {
                        self.progressBar.setProgress(barAdvance, animated: true)
                    }
                }
                DispatchQueue.main.async {
                        self.question.userChoice = -1
                        self.userDidChooseAnswer(isCorrectAnswer: false)
                }
            }
        }
        work?.perform()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        work?.cancel()
    }
    
    func setOnResponseAnswered(closure : @escaping (_ question: Question,_ isCorrectAnswer :Bool)->()) {
        onQuestionAnswered = closure
    }
    
    func userDidChooseAnswer(isCorrectAnswer : Bool) {
        //TODO : Faire les animations de réussite ou d'échec
        work?.cancel()
        if question != nil {
            self.dismiss(animated: true, completion: nil)
            onQuestionAnswered?(question, isCorrectAnswer)
        }
    }
}
