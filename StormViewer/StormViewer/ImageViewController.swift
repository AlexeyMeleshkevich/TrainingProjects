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
        let defaults = UserDefaults.standard
        var openedTimes = 0
        if var times = defaults.value(forKey: "\(dataModel.selectedIndex)") as? Int {
            let alert = UIAlertController(title: nil, message: "You opened this image \(times) times!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                times += 1
                defaults.set(times, forKey: "\(self.dataModel.selectedIndex)")
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            openedTimes = 1
            let alert = UIAlertController(title: "You never opened this picture.", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                defaults.set(openedTimes, forKey: "\(self.dataModel.selectedIndex)")
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        //        guard let data = dataModel else { return }
        title = dataModel.selectedIndex
        navigationItem.largeTitleDisplayMode = .never
        
        self.imageView.image = UIImage(named: dataModel.selectedIndex)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            guard let number = self?.dataModel.currentPosition else { return }
            guard let allNumbers = self?.dataModel.numberOfImages else { return }
            
            let alert = UIAlertController(title: "Picture \(number) of \(allNumbers)", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)

            self?.present(alert, animated: true, completion: nil)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        guard let data = dataModel else { return }
        
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
