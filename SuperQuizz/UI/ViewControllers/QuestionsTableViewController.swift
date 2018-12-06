//
//  QuestionsTableViewController.swift
//  SuperQuizz
//
//  Created by formation 1 on 04/12/2018.
//  Copyright © 2018 formation 1. All rights reserved.
//

import UIKit

class QuestionsTableViewController: UITableViewController {

    var questions = [
        Question(id: nil, title: "Quelle est la capitale de la France", correctAnswer : 2, propositions : ["Londres", "Paris", "Marseille", "Toulouse"]),
        Question(id: nil, title: "Ils ont des chapeaux ronds vive les ...", correctAnswer : 1, propositions : ["Les bretons", "Les nantais", "Les parisiens", "Les toulousains"]),
        Question(id: nil, title: "Chien ou chat ?", correctAnswer : 1, propositions : ["Chien", "Chat", "Chat", "Chat"]),
        Question(id: nil, title: "Ce célèbre gâteau breton s'écrit : ", correctAnswer : 3, propositions : ["Kouinamant", "Kouign amant", "Kouin amann", "Kouinaman"]),
        Question(id: nil, title: "Laquelle de ces marques est française ?", correctAnswer : 4, propositions : ["Kawazaki", "Mitsubishi", "Volwagen", "Citroën"])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTableViewCell")
        updateQuestionList()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let q : Question = questions[indexPath.row]
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AnswerViewController") as! AnswerViewController
        vc.question = q
        vc.setOnResponseAnswered { (questionAnswered, result) in
            //TODO : Mettre à jour la liste, ou faire un appel reseau, ou mettre à jour la base
            self.navigationController?.popViewController(animated: true)
            self.tableView.reloadData()
        }
        
        self.show(vc, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as? QuestionTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        let quest = questions[indexPath.row]
        
        if let userChoice = quest.userChoice {
            if (userChoice == quest.correctAnswer) {
                cell.backgroundColor = UIColor.green
            }
            else {
                cell.backgroundColor = UIColor.red
            }
        }
        cell.LinearListQuestionTitleLabel.text = quest.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexpath) in
            //TODO: edit question
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateOrEditQuestionViewController") as! CreateOrEditQuestionViewController
            controller.delegate = self
            controller.questionToEdit = self.questions[indexPath.row]
            self.present(controller, animated: true, completion: nil)
            
        }
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexpath) in
            
            _ = APIClient.instance.deleteOneQuestionFromServer(q: self.questions[indexPath.row], onSuccess: {
                DispatchQueue.main.async {
                    self.questions.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
            }, onError: { (Error) in })
        }
        return [editAction,deleteAction]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCreateOrEditViewController" {
            let controller = segue.destination as! CreateOrEditQuestionViewController
            controller.delegate = self
        }
    }
    
    func updateQuestionList() {
        let _ = APIClient.instance.getAllQuestionsFromServer(onSuccess: { (serverQuestions) in
            self.questions = serverQuestions
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (Error) in
            print(Error)
        }
    }
}

extension QuestionsTableViewController : CreateOrEditQuestionDelegate {
    func userDidEditQuestion(q: Question) {
        _ = APIClient.instance.editServerQuestion(q: q, onSuccess: { (serverQuestion: Question?) in
            
            for i in 0...self.questions.count {
                if self.questions[i].getId() == q.getId() {
                    self.questions[i] = q
                    break
                }
            }
            
            DispatchQueue.main.async {
                self.presentedViewController?.dismiss(animated: true, completion: nil)
                self.tableView.reloadData()
            }
        }, onError: { (Error) in
            
        })
    }
    
    func userDidCreateQuestion(q: Question, from vc: CreateOrEditQuestionViewController) {
        _ = APIClient.instance.createServerQuestion(q: q, onSuccess: { (q: Question?) in
            guard let question = q else {
                return
            }
            self.questions.append(question)
            DispatchQueue.main.async {
                self.presentedViewController?.dismiss(animated: true, completion: nil)
                self.tableView.reloadData()
                
            }
        }) { (Error) in
            
        }
    }
}
