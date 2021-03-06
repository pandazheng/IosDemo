//
//  ViewController.swift
//  AutoLayoutConstraints
//
//  Created by panda zheng on 16/8/12.
//  Copyright © 2016年 pandazheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let colorView = UIView();
    var initialConstraints = [NSLayoutConstraint]();

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        colorView.translatesAutoresizingMaskIntoConstraints = false;
        colorView.backgroundColor = UIColor.blueColor();
        
        self.view.addSubview(colorView);
        
        let leadingConstraint = colorView.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor);
        let trailingConstraint = colorView.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor);
        let topConstraint = colorView.topAnchor.constraintEqualToAnchor(self.view.topAnchor);
        let bottomConstraint = colorView.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor, constant: -50);
        
        initialConstraints.appendContentsOf([leadingConstraint,trailingConstraint,topConstraint,bottomConstraint]);
        
        NSLayoutConstraint.activateConstraints(initialConstraints);
        
    }

    @IBAction func changeConstraints(sender: AnyObject) {
        
        NSLayoutConstraint.deactivateConstraints(initialConstraints);
        
        let widthConstraint = colorView.widthAnchor.constraintEqualToConstant(100);
        let heightConstraint = colorView.heightAnchor.constraintEqualToConstant(100);
        
        let centerXConstraint = colorView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor);
        let centerYConstraint = colorView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor);
        
        NSLayoutConstraint.activateConstraints([widthConstraint,heightConstraint,centerXConstraint,centerYConstraint]);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

