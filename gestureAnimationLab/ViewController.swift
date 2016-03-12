//
//  ViewController.swift
//  gestureAnimationLab
//
//  Created by Zhipeng Mei on 3/11/16.
//  Copyright © 2016 Zhipeng Mei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var trayOriginalCenter: CGPoint!
    @IBOutlet weak var trayView: UIView!
    
    var trayCenterWhenOpen: CGFloat?
    var trayCenterWhenDown: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        trayCenterWhenOpen = 480
//        trayCenterWhenDown = 640
        trayCenterWhenOpen = trayView.center.y
        trayCenterWhenDown = trayView.center.y + trayView.frame.size.height - 40
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onPan(sender: UIPanGestureRecognizer) {
        onTrayPanGesture(sender)
    }
    
    func onTrayPanGesture(panGestureRecognizer: UIPanGestureRecognizer) {

        // Absolute (x,y) coordinates in parent view's coordinate system
        let point = panGestureRecognizer.locationInView(trayView)
        
        // Total translation (x,y) over time in parent view's coordinate system
        let translation = panGestureRecognizer.translationInView(view)
        
        let velocity = panGestureRecognizer.velocityInView(trayView)

        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            print("Gesture began at: \(point)")
            trayOriginalCenter = trayView.center
        

            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            print("Gesture changed at: \(point)")
            
            if(velocity.y > 0) {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.trayView.center = CGPoint(x: self.trayOriginalCenter.x, y: self.trayCenterWhenDown!)

                })
            } else {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.trayView.center = CGPoint(x: self.trayOriginalCenter.x, y: self.trayCenterWhenOpen!)
                })
            }
            
            

        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            print("Gesture ended at: \(point)")
            
        }
    }

}

