//
//  ViewController.swift
//  Guess the Flag
//
//  Created by Alexey Meleshkevich on 04.04.2020.
//  Copyright © 2020 Alexey Meleshkevich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var answersCounter: UIBarButtonItem!
    
    var highestScore: Int!
    
    var countries: [String] = ["estonia",
                               "france",
                               "germany",
                               "ireland",
                               "italy",
                               "monaco",
                               "nigeria",
                               "poland",
                               "russia",
                               "spain",
                               "uk",
                               "us"]
    lazy var score = 0
    lazy var correctAnswer = 0
    lazy var answersNumber = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtons()
        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        self.answersCounter.title = "\(0)"
        self.score = 0
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        firstButton.setImage(UIImage(named: countries[0]), for: .normal)
        secondButton.setImage(UIImage(named: countries[1]), for: .normal)
        thirdButton.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased()
    }
    
    func setButtons() {
        firstButton.layer.borderWidth = 1
        secondButton.layer.borderWidth = 1
        thirdButton.layer.borderWidth = 1
        
        firstButton.layer.borderColor = UIColor.lightGray.cgColor
        secondButton.layer.borderColor = UIColor.lightGray.cgColor
        thirdButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func buttonPresser(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong, correct is \(correctAnswer + 1)"
            score -= 1
        }
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 3, options: [], animations: { [weak sender] in
            sender?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak sender] in
                sender?.transform = .identity
            }
        }, completion: nil)
        
        answersNumber += 1
        answersCounter.title = String(answersNumber)
        
        let defaults = UserDefaults.standard
        
        if answersNumber == 10 && score >= 5 {
            if var scoreHigh = defaults.value(forKey: "t1") as? Int {
                if scoreHigh > score {
                } else {
                    defaults.set(score, forKey: "t1")
                    
                    let alert = UIAlertController(title: "Congratsulations!", message: "New highest score \(scoreHigh)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "New game", style: .default, handler: { [weak self] (_) in
                        self?.askQuestion()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                defaults.set(score, forKey: "t1")
            }
            
            
            let alert = UIAlertController(title: title, message: "You won in this game!", preferredStyle: .alert)
            self.present(alert, animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                    self?.askQuestion()
                }
            })
            
        } else if answersNumber == 10 && score <= 5  {
            if var scoreHigh = defaults.value(forKey: "t1") as? Int {
                if scoreHigh > score {
                } else {
                    defaults.set(score, forKey: "t1")
                    
                    let alert = UIAlertController(title: "Congratsulations!", message: "New highest score \(scoreHigh)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "New game", style: .default, handler: { [weak self] (_) in
                        self?.askQuestion()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                defaults.set(score, forKey: "t1")
            }
            let alert = UIAlertController(title: title, message: "Не повезло не фортануло!", preferredStyle: .alert)
            
            self.present(alert, animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                    self?.askQuestion()
                }
            })
        }
        
        let alert = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Play", style: .default, handler: askQuestion(action:)))
        
        self.present(alert, animated: true, completion: nil)
    }
}

