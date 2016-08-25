//
//  ViewController.swift
//  GraphVC
//
//  Created by Tsukasa Hasegawa on 2016/08/24.
//  Copyright © 2016年 Tsukasa Hasegawa. All rights reserved.
//
import UIKit

var viewWidth:CGFloat!
var viewHeight:CGFloat!

let screenWidth:CGFloat = UIScreen.mainScreen().bounds.size.width
let screenHeight:CGFloat = UIScreen.mainScreen().bounds.size.height

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        viewWidth = self.view.frame.width
        viewHeight = self.view.frame.height
        
        let graphview = Graph() //グラフを表示するクラス
        graphview.drawLineGraph() //グラフ描画開始
        
        _ = appDelegate.graphDatas
        _ = appDelegate.labelDates
        
        self.view.addSubview(graphview)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let graphview = Graph()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        _ = appDelegate.graphDatas
        _ = appDelegate.labelDates
        graphview.setNeedsDisplay()
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
}
