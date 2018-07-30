//
//  RoundView.swift
//  PlayWithDS
//
//  Created by shadowings on 2018/7/18.
//  Copyright © 2018年 shadowings. All rights reserved.
//

import UIKit

class RoundView: UIView {

    private var background: UIImageView!
    private var width: CGFloat!
    private var position: CGPoint!
    private var backgroundImage: UIImage!
    private var lightImage: UIImage!
    private var text: String!
    private var enabled: Bool = false
    
    init(position: CGPoint, diameter: CGFloat, labelText: String, backgroundImage: UIImage, lightImage: UIImage) {
        super.init(frame: CGRect(x: position.x, y: position.y, width: diameter, height: diameter))
        
        self.width = diameter
        self.position = position
        self.backgroundImage = backgroundImage
        self.lightImage = lightImage
        self.text = labelText
        
        let label = UILabel(frame : CGRect(x: 0 , y: 0 , width: diameter , height: diameter))
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.black
        label.text = labelText
        
        self.background = UIImageView(frame : CGRect(x: 0 , y: 0 , width: diameter , height: diameter))
        self.background.image = backgroundImage
        self.background.contentMode = .scaleToFill
        
        self.background.addSubview(label)
        addSubview(self.background)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func enableView(){
        self.enabled = true
    }
    
    func disableView(){
        self.enabled = false
    }
    
    func light(){
        self.background.image = lightImage
    }
    
    func extinguish(){
        self.background.image = backgroundImage
    }
    
    func getText() -> String {
        return text
    }
}
