//
//  ViewController.swift
//  PlayWithDS
//
//  Created by shadowings on 2018/7/16.
//  Copyright © 2018年 shadowings. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    let location = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let background = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        background.image = #imageLiteral(resourceName: "MainBackground")
        self.view.addSubview(background)
        
        let stackGameButton = generateRightButton( CGRect(x: UIScreen.main.bounds.width * 0.75 - 65, y: UIScreen.main.bounds.height * 0.5 - 75, width: 150, height: 50), image: #imageLiteral(resourceName: "StackButton"))
        stackGameButton.addTarget(self, action:#selector(stackGame), for:.touchUpInside)
        self.view.addSubview(stackGameButton)
        
        let queueGameButton = generateRightButton( CGRect(x: UIScreen.main.bounds.width * 0.75 - 65, y: UIScreen.main.bounds.height * 0.5 + 25, width: 150, height: 50), image: #imageLiteral(resourceName: "QueueButton"))
        queueGameButton.addTarget(self, action:#selector(queueGame), for:.touchUpInside)
        self.view.addSubview(queueGameButton)
        
        let sortShowButton = generateButton( CGRect(x: UIScreen.main.bounds.width * 0.25 - 75, y: UIScreen.main.bounds.height * 0.5 - 100, width: 150, height: 50), title: "排序演示", color: UIColor.blue, backgroundColor: UIColor.white)
        sortShowButton .addTarget(self, action: #selector(openSort), for: .touchUpInside)
        self.view.addSubview(sortShowButton)
        
        let treeShowButton = generateButton( CGRect(x: UIScreen.main.bounds.width * 0.25 - 75, y: UIScreen.main.bounds.height * 0.5 - 25, width: 150, height: 50), title: "二叉树遍历", color: UIColor.blue, backgroundColor: UIColor.white)
        treeShowButton .addTarget(self, action: #selector(openTree), for: .touchUpInside)

        self.view.addSubview(treeShowButton)
        
        let graphShowButton = generateButton( CGRect(x: UIScreen.main.bounds.width * 0.25 - 75, y: UIScreen.main.bounds.height * 0.5 + 50, width: 150, height: 50), title: "图的演示", color: UIColor.blue, backgroundColor: UIColor.white)
        graphShowButton .addTarget(self, action: #selector(openGraph), for: .touchUpInside)

        self.view.addSubview(graphShowButton)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func generateButton(_ frame: CGRect, title:String, color:UIColor, backgroundColor:UIColor) -> UIButton{
        let button = UIButton(frame: frame)
        button.setTitle(title, for: .normal)
        button.backgroundColor = backgroundColor
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }
    
    func generateRightButton(_ frame: CGRect, image: UIImage) -> UIButton{
        let button = UIButton(frame: frame)
        button.setBackgroundImage(image, for: .normal)
        return button
    }
    
    @objc func stackGame(_ sender: UIButton){
        self.present(StackViewController(), animated: true , completion: nil)
    }
    
    @objc func queueGame(_ sender: UIButton){
        self.present(QueueViewController(), animated: true , completion: nil)
    }
    
    @objc func openTree() {
        let stc = SelectTravesalController()
        stc.setValue(view.window?.rootViewController, forKey: "_lastRootVC")
        let nav = UINavigationController(rootViewController: stc)
        self.showSplit(withMaster: nav, detail: TravesingController.self, delegate: stc)
    }
    
    @objc func openGraph() {
        self.present(GraphMainController(), animated: true, completion: nil)

    }
    @objc func openSort() {
        self.present(SortMainController(), animated: true, completion: nil)
    }
    
    
}

