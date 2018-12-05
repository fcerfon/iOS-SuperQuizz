//
//  CreateOrEditQuestionViewController.swift
//  SuperQuizz
//
//  Created by formation 1 on 05/12/2018.
//  Copyright © 2018 formation 1. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

protocol CreateOrEditQuestionDelegate : AnyObject {
    func userDidEditQuestion(q : Question) -> ()
    func userDidCreateQuestion(q : Question) -> ()
}

class CreateOrEditQuestionViewController: UIViewController {
    
    //MARK IBoutlet

    @IBOutlet weak var titleQuestion: UITextField!
    
    @IBOutlet weak var firstPropositionSwitch: UISwitch!
    @IBOutlet weak var secondPropositionSwitch: UISwitch!
    @IBOutlet weak var thirdPropositionSwitch: UISwitch!
    @IBOutlet weak var fourthPropositionSwitch: UISwitch!
    
    @IBOutlet weak var firstPropositionText: UITextField!

    @IBOutlet weak var secondPropositionText: UITextField!
    @IBOutlet weak var thirdPropositionText: UITextField!
    @IBOutlet weak var fourthPropositionText: UITextField!
    
    @IBOutlet weak var validateButton: UIButton!
    
    @IBAction func validated(_ sender: UIButton) {
        createOrEditQuestion()
    }
    
    var switches : [UISwitch]?
    var propositions : [UITextField]?
    
    //MARK end IBoutlet
    
    var questionToEdit: Question?
    var correctAnswer: Int = 1
    weak var delegate : CreateOrEditQuestionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let q : Question = questionToEdit {
            
            titleQuestion.text = q.title
            
            propositions = [
                        firstPropositionText,
                        secondPropositionText,
                        thirdPropositionText,
                        fourthPropositionText
                    ]
            
            for (i, propo) in propositions!.enumerated() {
                propo.text = q.propositions[i]
            }
            
            switches = [
                        firstPropositionSwitch,
                        secondPropositionSwitch,
                        thirdPropositionSwitch,
                        fourthPropositionSwitch
                    ]
            
            firstPropositionSwitch.setOn(false, animated: false)
            switches?[q.correctAnswer].setOn(true, animated: false)
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(validateView(_:)))
        gesture.numberOfTapsRequired = 1
        
        view.addGestureRecognizer(gesture)
    }
    
    @objc func validateView(_ gesture:UITapGestureRecognizer)
    {
        createOrEditQuestion()
    }
    
    func createOrEditQuestion () {
        if let question = questionToEdit {
            delegate?.userDidEditQuestion(q: question)
        } else {
            
            let title = titleQuestion.text ?? ""
            let firstProposition = firstPropositionText.text ?? ""
            let secondProposition = secondPropositionText.text ?? ""
            let thirdProposition = thirdPropositionText.text ?? ""
            let fourthProposition = fourthPropositionText.text ?? ""
            
            let question = Question(title: title, correctAnswer: correctAnswer, propositions: [firstProposition,secondProposition,thirdProposition,fourthProposition])
            
            delegate?.userDidCreateQuestion(q: question)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
