//
//  QueueView.swift
//  PlayWithDS
//
//  Created by zy on 2018/7/22.
//  Copyright © 2018年 shadowings. All rights reserved.
//

import UIKit

class QueueView: UIView {

    let target = ["6","7","1","2","3","10","11","4","12","5","8","9"]
    
    var now = [String]()
    var queue = [RoundView]()
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
        
        let queueView = UIImageView(frame : CGRect(x: UIScreen.main.bounds.width - 200 , y: 100 , width: 110 , height: UIScreen.main.bounds.height - 300))
        queueView.image = #imageLiteral(resourceName: "Queue")
        queueView.contentMode = .scaleToFill
        addSubview(queueView)
        
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
        nowText.backgroundColor = UIColor.clear
        nowText.isEditable = false
        nowText.isSelectable = false
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
            let round = RoundView.init(position: position, diameter: self.diameter, labelText: "\(i + 1)", backgroundImage:#imageLiteral(resourceName: "Circle"), lightImage: #imageLiteral(resourceName: "CircleLight"))
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
                let flagX = point.x > 50 && point.x < (UIScreen.main.bounds.width - 100)
                let flagY = point.y > 50 && point.y < (UIScreen.main.bounds.height - 100)
                let flagButton = point.x < 200 && point.y < 130
                if flagX && flagY && !flagButton {
                    roundArray[selectedItem].frame = CGRect(x: point.x - self.diameter/2 , y: point.y - self.diameter/2 , width: self.diameter , height: self.diameter)
                }
            }
        }
    }
    
    //judge the location when touch end
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let t = touch as! UITouch
            let point = t.location(in: self)
            let pointInQueue = getPositionInQueueView()
            if isDragIntoQueueView(point) && selectedItem > -1 && queue.count < 9 {
                roundArray[selectedItem].frame = CGRect(x: pointInQueue.x, y: pointInQueue.y, width: self.diameter, height: self.diameter)
                queue.append(roundArray[selectedItem])
                
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
                    }  else if queue.count == 0 && targetItem >= roundArray.count - 1{
                        self.lose = true
                    }
                }
            }
        }
    }
    
    func isDragIntoQueueView(_ point: CGPoint) -> Bool {
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
    
    func getPositionInQueueView() -> CGPoint{
        let point = CGPoint(x: UIScreen.main.bounds.width - 200 + CGFloat(110 - self.diameter)/2 , y: UIScreen.main.bounds.height - 310 - CGFloat(queue.count - 1) * self.diameter)
        return point
    }
    
    @objc func pop() {
        if queue.count > 0 {
            queue[0].frame = CGRect(x: 0 , y: 0 , width: self.diameter , height: self.diameter)
            queue[0].isHidden = true
            nowText.text = nowText.text + "\t\(queue[0].getText())"
            queue.remove(at: 0)
            for item in queue {
                item.frame = CGRect(x: item.frame.origin.x , y: item.frame.origin.y + self.diameter , width: self.diameter , height: self.diameter)
            }
            if nowText.text == targetText.text {
                self.win = true
            }else if nowText.text != targetText.text && nowText.text.count == targetText.text.count {
                self.lose = true
            }
        }
    }
}

