//
//  ViewController.swift
//  StormViewer
//
//  Created by Alexey Meleshkevich on 03.04.2020.
//  Copyright © 2020 Alexey Meleshkevich. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Storm Viewer"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(recommendApp))
        navigationController?.navigationBar.prefersLargeTitles = true
        pictures = getImages()
    }
    
    func getImages() -> [String] {
        var pics = [String]()
        
        let fm = FileManager.default
        guard let path = Bundle.main.resourcePath else { return [String]()}
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                 pics.append(item)
            }
        }
        
        return pics.sorted()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "C.pictures", for: indexPath)

        cell.textLabel?.text = pictures[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let imagesVC = storyboard?.instantiateViewController(identifier: "ImagesVC") as? ImageViewController else { return }
        
        imagesVC.dataModel.currentPosition = String(indexPath.row)
        imagesVC.dataModel.selectedIndex = self.pictures[indexPath.row]
        imagesVC.dataModel.numberOfImages = String(self.pictures.count)
        
        print(String(indexPath.row))
        print(self.pictures[indexPath.row])
        print(String(self.pictures.count))
        
//        self.present(imagesVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(imagesVC, animated: true)
    }
    
    @objc func recommendApp() {
        let alert = UIAlertController(title: "Recommendation!", message: "Try our Social Media App!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

}

