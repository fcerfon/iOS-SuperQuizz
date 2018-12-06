//
//  APIClient.swift
//  SuperQuizz
//
//  Created by formation 1 on 06/12/2018.
//  Copyright © 2018 formation 1. All rights reserved.
//

import Foundation

class APIClient {
    
    static let instance = APIClient()
    
    private let authorImg = "https://img.sheetmusic.direct/catalogue/contributor/e557d666-3595-4d82-8830-9cef343ab3a6/large.jpg"
    private let author = "Florent"
    private let urlServer = "http://localhost:3000"
    private init () {}
    
    func getAllQuestionsFromServer(onSuccess:@escaping ([Question])->(), onError:@escaping (Error)->())-> URLSessionTask {
        
        var request = URLRequest(url: URL(string: "\(urlServer)/questions")! )
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                
                let dataArray = try! JSONSerialization.jsonObject(with: data, options: []) as! [Any]
                var questionsToreturn = [Question]()
                for object in dataArray {
                    
                    guard let q = self.createQuestionFromJson(objectDictionary: object as! [String: Any]) else {
                        continue
                    }
                    questionsToreturn.append(q)
                }
                onSuccess(questionsToreturn)
                
            } else  {
                onError(error!)
            }
        }
        // lance la tache
        task.resume()
        
        // revoie la tache pour pouvoir l'annuler
        return task
    }
    
    func createQuestionFromJson(objectDictionary : [String: Any]) -> Question? {
        
        guard let title = objectDictionary["title"] else {
            return nil
        }
        if title as! String == "qfdsvcx" {
            print("lolo")
        }
        guard let firstProposition = objectDictionary["answer_1"] else {
            return nil
        }
        guard let secondProposition = objectDictionary["answer_2"] else {
            return nil
        }
        guard let thirdProposition = objectDictionary["answer_3"] else {
            return nil
        }
        guard let fourthProposition = objectDictionary["answer_4"] else {
            return nil
        }
        
        if let id = objectDictionary["id"] as? NSNumber {
            if let correctAnswer = objectDictionary["correct_answer"] as? NSNumber {
                let q  = Question(id : Int(id),
                                  title: title as! String,
                                  correctAnswer: Int(correctAnswer),
                                  propositions: [firstProposition as! String,
                                                 secondProposition as! String,
                                                 thirdProposition as! String,
                                                 fourthProposition as! String])
                return q
            }
        }

        return nil
    }
    
    func deleteOneQuestionFromServer(q : Question, onSuccess:@escaping ()->(), onError:@escaping (Error)->())-> URLSessionTask {
        
        let questionId = q.getId() ?? -1
        var request = URLRequest(url: URL(string: "\(urlServer)/questions/" + String(questionId))! )
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if data != nil && error == nil {
                onSuccess()
            } else  {
                onError(error!)
            }
        }
        task.resume()
        
        return task
    }
    
    func createServerQuestion(q : Question, onSuccess:@escaping (_: Question?)->(), onError:@escaping (Error)->())-> URLSessionTask {
        
        // prepare json
        
        let json: [String: Any] = ["title": q.title,
                                   "correct_answer" : q.correctAnswer,
                                   "answer_1" : q.propositions[0],
                                   "answer_2" : q.propositions[1],
                                   "answer_3" : q.propositions[2],
                                   "answer_4" : q.propositions[3],
                                   "author_img_url" : authorImg,
                                   "author" : author]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // prepare request
        
        var request = URLRequest(url: URL(string: "\(urlServer)/questions/")! )
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // send request
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            if data != nil && error == nil {
                
                guard let data = data else {
                    onError(NSError(domain:"", code:-1, userInfo:["error": "no data"]))
                    return
                }
                
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    
                    let q = self.createQuestionFromJson(objectDictionary: responseJSON)
                    onSuccess(q)
                }
            } else  {
                onError(error!)
            }
        }
        
        task.resume()
        
        return task
    }

    func editServerQuestion(q : Question, onSuccess:@escaping (_: Question?)->(), onError:@escaping (Error)->())-> URLSessionTask {
        
        // prepare json
        
        let json: [String: Any] = ["title": q.title,
                                   "correct_answer" : q.correctAnswer,
                                   "answer_1" : q.propositions[0],
                                   "answer_2" : q.propositions[1],
                                   "answer_3" : q.propositions[2],
                                   "answer_4" : q.propositions[3],
                                   "author_img_url" : authorImg,
                                   "author" : author]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // prepare request
        
        let questionId = q.getId() ?? -1
        var request = URLRequest(url: URL(string: "\(urlServer)/questions/" + String(questionId))! )
        request.httpMethod = "PUT"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // send request
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if data != nil && error == nil {
                
                guard let data = data else {
                    onError(NSError(domain:"", code:-1, userInfo:["error": "no data"]))
                    return
                }
                
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    
                    let q = self.createQuestionFromJson(objectDictionary: responseJSON)
                    onSuccess(q)
                }
            } else  {
                onError(error!)
            }
        }
        
        task.resume()
        
        return task
    }
}
