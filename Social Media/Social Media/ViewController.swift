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
        
        let dataModel = DataModel(numberOfImages: String(self.pictures.count), selectedIndex: self.pictures[indexPath.row], currentPosition: String(indexPath.row))
        
        imagesVC.dataModel = dataModel
        self.navigationController?.pushViewController(imagesVC, animated: true)
    }

}

