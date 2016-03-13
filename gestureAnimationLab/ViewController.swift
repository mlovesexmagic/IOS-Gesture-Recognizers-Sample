//
//  ViewController.swift
//  gestureAnimationLab
//
//  Created by Zhipeng Mei on 3/11/16.
//  Copyright © 2016 Zhipeng Mei. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    var caofan: Bool!
    var trayOriginalCenter: CGPoint!
    
    @IBOutlet weak var trayView: UIView!
    
    var trayCenterWhenOpen: CGFloat?
    var trayCenterWhenDown: CGFloat?
    
    var newlyCreatedFace: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //        trayCenterWhenOpen = 480
        //        trayCenterWhenDown = 640
        trayCenterWhenOpen = trayView.center.y
        trayCenterWhenDown = trayView.center.y + trayView.frame.size.height - 40
        caofan = false
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// **** subview "TrayView" animation: Pan gestures ****
    @IBAction func onPan(sender: UIPanGestureRecognizer) {
        onTrayPanGesture(sender)
    }
    
    func onTrayPanGesture(panGestureRecognizer: UIPanGestureRecognizer) {

        // Absolute (x,y) coordinates in parent view's coordinate system
        let point = panGestureRecognizer.locationInView(trayView)
        
        // Total translation (x,y) over time in parent view's coordinate system
        //let translation = panGestureRecognizer.translationInView(view)
        let velocity = panGestureRecognizer.velocityInView(trayView)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            print("Gesture began at: \(point)")
            trayOriginalCenter = trayView.center
        }
        else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            print("Gesture changed at: \(point)")
            
            if(velocity.y > 0) {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 20, options: [], animations: { () -> Void in
                    //animation blocks here
                    self.trayView.center = CGPoint(x: self.trayOriginalCenter.x, y: self.trayCenterWhenDown!)
                    
                    }, completion: { (Bool) -> Void in
                        //animation blocks here
                })
            } else {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.trayView.center = CGPoint(x: self.trayOriginalCenter.x, y: self.trayCenterWhenOpen!)
                })
            }
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
           // print("Gesture ended at: \(point)")
            
        }
    }
// **** End Pan method ****
    
    
// **** subview "TrayView" animation: Tap gestures ****
    @IBAction func onTapTrayView(sender: UITapGestureRecognizer) {
        onTrayTapGesture(sender)
    }
    
    func onTrayTapGesture(sender: UITapGestureRecognizer) {
        if(caofan == false) {
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 20, options: [], animations: { () -> Void in
                //animation blocks here
                self.trayOriginalCenter = self.trayView.center
                self.trayView.center = CGPoint(x: self.trayOriginalCenter.x, y: self.trayCenterWhenDown!)
                self.caofan = true
                
                }, completion: { (Bool) -> Void in
                    //animation blocks here
            })
        }
        else if(caofan == true) {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.trayView.center = CGPoint(x: self.trayOriginalCenter.x, y: self.trayCenterWhenOpen!)
                self.caofan = false
            })
        }
    }
// **** End Tap method ****
    

    
    

//******************************* Faces Animation ************************
    //Step 1: creates faces
    func createFaces(panGestureRecognizer: UIPanGestureRecognizer){
        // Gesture recognizers know the view they are attached to
        let imageView = panGestureRecognizer.view as! UIImageView
        
        // Create a new image view that has the same image as the one currently panning
        newlyCreatedFace = UIImageView(image: imageView.image)
        
        // Add the new face to the tray's parent view.
        view.addSubview(newlyCreatedFace)
        
        // Initialize the position of the new face.
        newlyCreatedFace.center = imageView.center
        
        // Since the original face is in the tray, but the new face is in the
        // main view, you have to offset the coordinates
        newlyCreatedFace.center.y += trayView.frame.origin.y
        
        //*********** Adding Pan Gesture ***************
        // The onCustomPan: method will be defined in Step 3 below.
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onCustomPan:")
        // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
        newlyCreatedFace.userInteractionEnabled = true
        newlyCreatedFace.multipleTouchEnabled = true
        newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
        //***** End Pan Gesture

    }
    
    func onCustomPan(panGestureRecognizer: UIPanGestureRecognizer) {
        // Absolute (x,y) coordinates in parent view
        let point = panGestureRecognizer.locationInView(view)
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            //print("Gesture began at: \(point)")
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            //print("Gesture changed at: \(point)")
            newlyCreatedFace.center = point
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            //print("Gesture ended at: \(point)")
        }
    }
    
    //Step 2: create animation
    func createFacesAnimation(panGestureRecognizer: UIPanGestureRecognizer){
        let point = panGestureRecognizer.locationInView(view)
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            self.createFaces(panGestureRecognizer)
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.newlyCreatedFace.transform = CGAffineTransformMakeScale(2,2)
            })
        }
        else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            newlyCreatedFace.center = point
        }
        else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.newlyCreatedFace.transform = CGAffineTransformMakeScale(1.5,1.5)
            })
        }
    }
    
    // Pan gesture
    @IBAction func onDeadFacePan(panGestureRecognizer: UIPanGestureRecognizer) {
       createFacesAnimation(panGestureRecognizer)
    }
    
    @IBAction func happyPan(panGestureRecognizer: UIPanGestureRecognizer) {
        createFacesAnimation(panGestureRecognizer)
    }

    @IBAction func sadPan(panGestureRecognizer: UIPanGestureRecognizer) {
        createFacesAnimation(panGestureRecognizer)
    }
    
    @IBAction func onExcitedPan(panGestureRecognizer: UIPanGestureRecognizer) {
        createFacesAnimation(panGestureRecognizer)
    }
    
    @IBAction func onWinkPan(panGestureRecognizer: UIPanGestureRecognizer) {
        createFacesAnimation(panGestureRecognizer)
    }
    
    @IBAction func onTonguePan(panGestureRecognizer: UIPanGestureRecognizer) {
        createFacesAnimation(panGestureRecognizer)
    }
//******************************* End Faces Animation ************************


   
}

