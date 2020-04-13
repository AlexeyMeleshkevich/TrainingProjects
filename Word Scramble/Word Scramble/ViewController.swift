//
//  ViewController.swift
//  Word Scramble
//
//  Created by Alexey Meleshkevich on 07.04.2020.
//  Copyright © 2020 Alexey Meleshkevich. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    lazy var allWords = [String]()
    lazy var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        if let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsUrl) {
                allWords = startWords.components(separatedBy: "\n")
            }
        } else if allWords.isEmpty  {
            allWords = ["Damn you failed"]
        }
        
        startGame()
    }
    
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "C1", for: indexPath)
        
        cell.textLabel?.text = usedWords[indexPath.row]
        
        return cell
    }

    @objc func promptForAnswer() {
        let alert = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        
        alert.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alert] _ in
            guard let answer = alert?.textFields?[0].text, !answer.isEmpty else { return }
            self?.submit(answer)
        }
        alert.addAction(submitAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer) && isOriginal(word: lowerAnswer) && isReal(word: lowerAnswer) && moreThanThree(word: lowerAnswer) {
            usedWords.insert(answer, at: 0)
            
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            
            return
        } else {
            showErrorMessage(word: lowerAnswer)
        }
    }

    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        if word == self.title!.lowercased() {
            return false
        }
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func moreThanThree(word: String) -> Bool {
        if word.count<3 {
            return false
        } else {
            return true
        }
    }
    
    func showErrorMessage(word: String) {
        
        var errorTitle: String = String()
        var errorMessage: String = String()
        
         if !isPossible(word: word) {
            errorTitle = "Word not recognized"
            errorMessage = "You just cant make them up!"
        } else if !isOriginal(word: word) {
            errorTitle = "Word already used"
            errorMessage = "Be more original!"
        } else if !isReal(word: word) {
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from \(title!.lowercased())"
        } else if !moreThanThree(word: word) {
            errorTitle = "Word is too short"
            errorMessage = "Think more!"
        }
        
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

