//
//  ViewController.swift
//  Auto Layout 2
//
//  Created by Alexey Meleshkevich on 08.04.2020.
//  Copyright © 2020 Alexey Meleshkevich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()
    }
    
    func setLabels() {
        var labelsDictionary = [String: UILabel]()
        
        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.backgroundColor = UIColor.red
        label1.text = "THESE"
        label1.textAlignment = .center
        label1.sizeToFit()
        labelsDictionary.updateValue(label1, forKey: "label1")
        
        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.backgroundColor = UIColor.cyan
        label2.text = "ARE"
        label2.textAlignment = .center
        label2.sizeToFit()
        labelsDictionary.updateValue(label2, forKey: "label2")
        
        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.backgroundColor = UIColor.yellow
        label3.text = "SOME"
        label3.textAlignment = .center
        label3.sizeToFit()
        labelsDictionary.updateValue(label3, forKey: "label3")
        
        let label4 = UILabel()
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.backgroundColor = UIColor.green
        label4.text = "AWESOME"
        label4.textAlignment = .center
        label4.sizeToFit()
        labelsDictionary.updateValue(label4, forKey: "label4")
        
        let label5 = UILabel()
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.backgroundColor = UIColor.orange
        label5.text = "LABELS"
        label5.textAlignment = .center
        label5.sizeToFit()
        labelsDictionary.updateValue(label5, forKey: "label5")
        
        for labels in labelsDictionary.values {
            self.view.addSubview(labels)
        }
        
        /*
        for label in labelsDictionary.keys {
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-50-[\(label)]-50-|", options: [], metrics: nil, views: labelsDictionary))
        }
        
        let metrics = ["labelHeight": 88]
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-50-[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|", options: [], metrics: metrics, views: labelsDictionary))
        */
        
        var previous: UILabel?
        
        for label in [label1, label2, label3, label4, label5] {
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
//            label.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/5).isActive = true
            label.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            if let previous = previous {
                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
            } else {
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
            }
            
            previous = label
        }
    }


}

