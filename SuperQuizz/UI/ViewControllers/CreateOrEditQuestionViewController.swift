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
        
        propositions = [
            firstPropositionText,
            secondPropositionText,
            thirdPropositionText,
            fourthPropositionText
        ]
        
        switches = [
            firstPropositionSwitch,
            secondPropositionSwitch,
            thirdPropositionSwitch,
            fourthPropositionSwitch
        ]
        
        if let q : Question = questionToEdit {
            
            titleQuestion.text = q.title
            
            for (i, propo) in propositions!.enumerated() {
                propo.text = q.propositions[i]
            }
            
            firstPropositionSwitch.setOn(false, animated: false)
            switches?[q.correctAnswer].setOn(true, animated: false)
        }
    }
    
    @IBAction func onSwitchTapped(_ sender: UISwitch) {
        if (switches != nil) {
            for sw in switches! {
                sw.setOn(false, animated: true)
            }
            sender.setOn(true, animated: false)
        }
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
