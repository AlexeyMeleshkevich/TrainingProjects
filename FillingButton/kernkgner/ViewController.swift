//
//  ViewController.swift
//  kernkgner
//
//  Created by Alexey Meleshkevich on 17.04.2020.
//  Copyright © 2020 Alexey Meleshkevich. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CAAnimationDelegate {

    @IBOutlet weak var button: UIButton!
    
    let animation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.fillMode = CAMediaTimingFillMode(rawValue: "both")
        animation.duration = 3
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: "easeOut"))
        animation.isRemovedOnCompletion = false
        return animation
    }()
    
    var overViewSublayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        
        layer.lineCap = CAShapeLayerLineCap(rawValue: "square")
        layer.strokeStart = 0
        layer.strokeEnd = 0
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = nil
        
        return layer
    }()
    
    var path: UIBezierPath = {
        let path = UIBezierPath()
        return path
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.backgroundColor = UIColor.lightGray
        button.layer.borderColor = UIColor.black.cgColor
        
        animation.delegate = self
        
        setViewSublayer(lay: overViewSublayer)
    }
    
    func setViewSublayer(lay: CAShapeLayer) {
        view.layer.addSublayer(lay)
        
        lay.frame = button.bounds
        lay.lineWidth = button.frame.width
        
        setPath(lay: lay)
    }
    
    func setPath(lay: CAShapeLayer) {
        path.move(to: CGPoint(x: button.frame.midX, y: button.frame.maxY))
        path.addLine(to: CGPoint(x: button.frame.midX, y: button.frame.minY))
        
        lay.path = path.cgPath
    }

    @IBAction func actionnnn(_ sender: Any) {
        
        overViewSublayer.add(animation, forKey: animation.keyPath)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let alert = UIAlertController(title: "Hello", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

