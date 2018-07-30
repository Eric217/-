//
//  TSViewController.swift
//  PlayWithDS
//
//  Created by shadowings on 2018/7/18.
//  Copyright © 2018年 shadowings. All rights reserved.
//

import UIKit

class StackViewController: UIViewController {

    var gameView:StackView! = nil
    var timer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewWidth = view.bounds.size.width
        let viewHeight = view.bounds.size.height
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(isWin), userInfo:nil, repeats:true)
        
        gameView = StackView.init(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight), roundCount: 12)
        self.view.addSubview(gameView)
        
        let backButton = UIButton(frame: CGRect(x: 80, y: 60, width: 100, height: 50))
        backButton.setTitle("back", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        backButton.addTarget(self, action:#selector(back), for:.touchUpInside)
        backButton.setTitleColor(UIColor(red: 119/255, green: 202/255, blue: 223/255, alpha: 1), for: .normal)
        self.view.addSubview(backButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func isWin(){
        if gameView.win {
            self.timer.invalidate()
            let alertController = UIAlertController(title: "您赢了！", message: "", preferredStyle: UIAlertController.Style.alert)
            let alertView = UIAlertAction(title: "确定", style: UIAlertAction.Style.default) { (UIAlertAction) -> Void in
                self.dismiss(animated: true, completion:nil)
            }
            alertController.addAction(alertView)
            self.present(alertController, animated: true, completion: nil)
        } else if gameView.lose {
            self.timer.invalidate()
            let alertController = UIAlertController(title: "您失败了！", message: "", preferredStyle: UIAlertController.Style.alert)
            let alertView = UIAlertAction(title: "确定", style: UIAlertAction.Style.default) { (UIAlertAction) -> Void in
                self.dismiss(animated: true, completion:nil)
            }
            alertController.addAction(alertView)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func back(){
        self.dismiss(animated: true, completion:nil)
    }
}
