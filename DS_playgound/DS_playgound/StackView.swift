//
//  TSView.swift
//  PlayWithDS
//
//  Created by shadowings on 2018/7/18.
//  Copyright © 2018年 shadowings. All rights reserved.
//

import UIKit

class StackView: UIView {
    
    let target = ["7","6","5","8","9","11","10","4","3","12","2","1"]
    
    var now = [String]()
    var stack = [RoundView]()
    var roundArray = [RoundView]()
    var nowText:UITextView!
    var targetText:UITextView!
    var targetItem = 0                      //应该选中的项目编号
    var selectedItem = -1                   //当前选中的项目编号
    var diameter:CGFloat = 50.0
    var win = false
    var lose = false
    
    init(frame: CGRect, roundCount: Int) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        let background = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        background.image = #imageLiteral(resourceName: "GameBackground")
        addSubview(background)
        
        let stackView = UIImageView(frame : CGRect(x: UIScreen.main.bounds.width - 200 , y: 100 , width: 110 , height: UIScreen.main.bounds.height - 300))
        stackView.image = #imageLiteral(resourceName: "Stack")
        stackView.contentMode = .scaleToFill
        addSubview(stackView)
        
        let popButton = UIButton(frame : CGRect(x: UIScreen.main.bounds.width - 205 , y: UIScreen.main.bounds.height - 150 , width: 120 , height: 40))
        popButton.setBackgroundImage(#imageLiteral(resourceName: "PopButton"), for: .normal)
        popButton.addTarget(self, action:#selector(pop), for:.touchUpInside)
        addSubview(popButton)
        
        let holderView = UIImageView(frame : CGRect(x: 40 , y: UIScreen.main.bounds.height - 160 , width: UIScreen.main.bounds.width - 280 , height: 120))
        holderView.image = #imageLiteral(resourceName: "OutputHolder")
        holderView.contentMode = .scaleToFill
        addSubview(holderView)
        
        nowText = UITextView(frame: CGRect(x: 50 , y: UIScreen.main.bounds.height - 150 , width: UIScreen.main.bounds.width - 300 , height: 50))
        nowText.textColor = UIColor.blue
        nowText.font = UIFont.systemFont(ofSize: 20)
        nowText.isEditable = false
        nowText.isSelectable = false
        nowText.backgroundColor = UIColor.clear
        addSubview(nowText)
        
        targetText = UITextView(frame: CGRect(x: 50 , y: UIScreen.main.bounds.height - 100 , width: UIScreen.main.bounds.width - 300 , height: 50))
        targetText.textColor = UIColor.blue
        targetText.font = UIFont.systemFont(ofSize: 20)
        targetText.isEditable = false
        targetText.isSelectable = false
        targetText.backgroundColor = UIColor.clear
        for item in target {
            targetText.text = targetText.text + "\t\(item)"
        }
        addSubview(targetText)
        
        
        for i in 0..<roundCount {
            let position = CGPoint(x: 100 + Int(self.diameter + 10) * (i % 6), y: 200 + Int(self.diameter + 10) * Int(i / 6))
            let round = RoundView.init(position: position, diameter: self.diameter, labelText: "\(i + 1)", backgroundImage: #imageLiteral(resourceName: "Circle"), lightImage: #imageLiteral(resourceName: "CircleLight"))
            roundArray.append(round)
            addSubview(round)
        }
        
        roundArray[targetItem].light()          //点亮第一个
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //when touches begin, get the round that you touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let t = touch as! UITouch
            let point = t.location(in: self)
            let selectRoundOriginX = roundArray[targetItem].frame.origin.x
            let selectRoundOriginY = roundArray[targetItem].frame.origin.y
            let distance = (point.x - selectRoundOriginX) * (point.x - selectRoundOriginX) + (point.y - selectRoundOriginY) * (point.y - selectRoundOriginY)
            if distance <= self.diameter * self.diameter {
                selectedItem = targetItem       //选中了正确的项目
            } else {
                selectedItem = -1
            }
        }
    }
    
    //change the location of the round
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let t = touch as! UITouch
            let point = t.location(in: self)
            if selectedItem > -1{
                roundArray[selectedItem].frame = CGRect(x: point.x - self.diameter/2 , y: point.y - self.diameter/2 , width: self.diameter , height: self.diameter)
            }
        }
    }
    
    //judge the location when touch end
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let t = touch as! UITouch
            let point = t.location(in: self)
            let pointInStack = getPositionInStackView()
            if isDragIntoStackView(point) && selectedItem > -1 {
                roundArray[selectedItem].frame = CGRect(x: pointInStack.x, y: pointInStack.y, width: self.diameter, height: self.diameter)
                stack.append(roundArray[selectedItem])
                
                roundArray[targetItem].extinguish()     //熄灭上一个
                if targetItem < roundArray.count - 1{
                    targetItem = targetItem + 1
                    roundArray[targetItem].light()          //点亮下一个
                }
        
            } else if isDragIntoOutputView(point) && selectedItem > -1 {
                roundArray[selectedItem].frame = CGRect(x: 0, y: 0, width: self.diameter, height: self.diameter)
                roundArray[selectedItem].isHidden = true
                nowText.text = nowText.text + "\t\(roundArray[selectedItem].getText())"
                if nowText.text == targetText.text {
                    self.win = true
                } else {
                    roundArray[targetItem].extinguish()     //熄灭上一个
                    if targetItem < roundArray.count - 1 {
                        targetItem = targetItem + 1
                        roundArray[targetItem].light()          //点亮下一个
                    } else if stack.count == 0 && targetItem >= roundArray.count - 1{
                        self.lose = true
                    }
                }
            }
        }
    }
    
    func isDragIntoStackView(_ point: CGPoint) -> Bool {
        if point.x > UIScreen.main.bounds.width - 200 && point.x < UIScreen.main.bounds.width - 90 && point.y > 100 && point.y < UIScreen.main.bounds.height - 200 {
            return true
        } else {
            return false
        }
    }
    
    func isDragIntoOutputView(_ point: CGPoint) -> Bool {
        if point.x > 50 && point.x < UIScreen.main.bounds.width - 250 && point.y > UIScreen.main.bounds.height - 150 && point.y < UIScreen.main.bounds.height - 50 {
            return true
        } else {
            return false
        }
    }
    
    func getPositionInStackView() -> CGPoint{
        let point = CGPoint(x: UIScreen.main.bounds.width - 200 + CGFloat(110 - self.diameter)/2 , y: UIScreen.main.bounds.height - 320 - CGFloat(stack.count - 1) * self.diameter)
        return point
    }
    
    @objc func pop() {
        stack[stack.count - 1].frame = CGRect(x: 0 , y: 0 , width: self.diameter , height: self.diameter)
        stack[stack.count - 1].isHidden = true
        nowText.text = nowText.text + "\t\(stack[stack.count - 1].getText())"
        stack.remove(at: stack.count - 1)
        if nowText.text == targetText.text {
            self.win = true
        }else if nowText.text != targetText.text && nowText.text.count == targetText.text.count {
            self.lose = true
        }
    }
}
