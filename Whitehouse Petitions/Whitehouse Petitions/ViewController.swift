//
//  ViewController.swift
//  Whitehouse Petitions
//
//  Created by Alexey Meleshkevich on 08.04.2020.
//  Copyright © 2020 Alexey Meleshkevich. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var urlString: String = String()
    var buffPetitions = [Petition]()
    var filtredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        guard let url = URL(string: urlString) else { showError(); return }
        guard let data = try? Data(contentsOf: url) else { return }
        
        parse(json: data)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showData))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(sort))
    }
    
    @objc func sort() {
        let alert = UIAlertController(title: "Enter a text to filter", message: urlString, preferredStyle: .alert)
        alert.addTextField { (tf) in
            tf.placeholder = "Enter text here"
        }
        alert.addAction(UIAlertAction(title: "Filted", style: .default, handler: { (_) in
            if self.isHere(word: alert.textFields![0].text!) {
                self.buffPetitions = self.petitions
                self.petitions = self.filtredPetitions
                self.tableView.reloadData()
            }
        }))
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func isHere(word: String) -> Bool {
        for petition in petitions {
            if petition.title.contains(word) || petition.body.contains(word) {
                filtredPetitions.append(petition)
            }
        }
        
        if filtredPetitions.count != 0 {
            return true
        } else {
            let alert = UIAlertController(title: "Error", message: "There is no pretitions with such data", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
    }
    
    @objc func showData() {
        let alert = UIAlertController(title: "You watching info from:", message: urlString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showError() {
        let alert = UIAlertController(title: "Loading error", message: "There was a problem loading the feed. Check your connection", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        guard let jsonPetitions = try? decoder.decode(Petitions.self, from: json) else { return }
        
        petitions = jsonPetitions.results
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "C1", for: indexPath)
        
        let petition = petitions[indexPath.row]
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = DetailViewController()
        
        detailVC.detailItem = petitions[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}

