//
//  ImageViewController.swift
//  StormViewer
//
//  Created by Alexey Meleshkevich on 03.04.2020.
//  Copyright © 2020 Alexey Meleshkevich. All rights reserved.
//

import Foundation
import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var dataModel: DataModel = DataModel(numberOfImages: "nil", selectedIndex: "nil", currentPosition: "nil")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        guard let data = dataModel else { return }
        title = dataModel.selectedIndex
        navigationItem.largeTitleDisplayMode = .never
        
        self.imageView.image = UIImage(named: dataModel.selectedIndex)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        guard let data = dataModel else { return }
        
        let alert = UIAlertController(title: "Picture \(dataModel.currentPosition) of \(dataModel.numberOfImages)", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
