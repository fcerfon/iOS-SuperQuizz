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
    
    let switches : [UISwitch]
    
    //MARK end IBoutlet
    
    var questionToEdit: Question?
    weak var delegate : CreateOrEditQuestionDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        switches = [firstPropositionSwitch, secondPropositionSwitch, thirdPropositionSwitch, fourthPropositionSwitch]
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let q : Question = questionToEdit {
            
            titleQuestion.text = q.title
            
            firstPropositionText.placeholder = q.propositions[0]
            secondPropositionText.placeholder = q.propositions[1]
            thirdPropositionText.placeholder = q.propositions[2]
            fourthPropositionText.placeholder = q.propositions[3]
            
            firstPropositionSwitch.setOn(false, animated: false)
            switches[q.correctAnswer].setOn(true, animated: false)
        }
    }
    
    func createOrEditQuestion () {
        if let question = questionToEdit {
            delegate?.userDidEditQuestion(q: question)
        } else {
            let question = Question(title: "", correctAnswer: 0, propositions: [""])
            delegate?.userDidCreateQuestion(q: question)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
