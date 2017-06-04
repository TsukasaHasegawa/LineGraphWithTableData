//
//  GraphView.swift
//  GraphVC
//
//  Created by Tsukasa Hasegawa on 2016/08/24.
//  Copyright © 2016年 Tsukasa Hasegawa. All rights reserved.
//
import UIKit

class Graph: UIView {
    
    var lineWidth:CGFloat = 3.0 //グラフ線の太さ
    var lineColor:UIColor = UIColor(red:0.088,  green:0.501,  blue:0.979, alpha:1) //グラフ線の色
    var circleWidth:CGFloat = 4.0 //円の半径
    var circleColor:UIColor = UIColor(red:0.088,  green:0.501,  blue:0.979, alpha:1) //円の色
    
    
    var memoriMargin: CGFloat! //横目盛の感覚
    var graphHeight: CGFloat = screenHeight-120 //グラフの高さ
    var numOfGD: CGFloat!
    
    
    func drawLineGraph(){
        GraphFrame()
        MemoriGraphDraw()
    }
    
    //グラフを描画するviewの大きさ
    func GraphFrame(){
        self.backgroundColor = UIColor(red:0.7,  green:0.7,  blue:0.7, alpha:0.5)
        self.frame = CGRectMake(20 , 80, viewWidth - 40, viewHeight - 120)
    }
    
    
    
    //===================================
    //横目盛・グラフを描画する
    //===================================
    
    
    func MemoriGraphDraw() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        numOfGD = CGFloat(appDelegate.graphDatas.count)
        memoriMargin = (viewWidth-40)/numOfGD
        
        var count:CGFloat = 0
        for _ in appDelegate.graphPoints {
        
            let label = UILabel()
            label.text = appDelegate.labelDates[0]
            label.font = UIFont.systemFontOfSize(9)
            //ラベルのサイズを取得
            let frame = CGSizeMake(250, CGFloat.max)
            let rect = label.sizeThatFits(frame)
            
            //ラベルの位置
            var labelX = viewWidth-20
            //(count * memoriMargin)-rect.width/2
            //最後のラベル
            if Int(count+1) == appDelegate.graphPoints.count{
                labelX = viewWidth-20
            }
            
            label.frame = CGRectMake(labelX , graphHeight, rect.width, rect.height)
            self.addSubview(label)
            
            count += 1
        
            self.addSubview(label)
        }
    }
    
    
    
    
    
    //=========================================
    //グラフのデータストロークの線を描画
    //=========================================
    
    
    override func drawRect(rect: CGRect) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var count:CGFloat = 0
        let linePath = UIBezierPath()
        var myCircle = UIBezierPath()
        numOfGD = CGFloat(appDelegate.graphDatas.count)
        memoriMargin = (viewWidth-40)/numOfGD
        
        linePath.lineWidth = lineWidth
        lineColor.setStroke()
        
        for datapoint in appDelegate.graphDatas {
            // もともとは"count+1"
            if Int(count
                ) < appDelegate.graphDatas.count {
                
                //datapoint[10]/100*(viewHeight-circleWidth)
                var nowY: CGFloat = datapoint/yAxisMax
                //* (graphHeight - circleWidth)
                
                nowY = graphHeight - nowY
                
                if(appDelegate.graphDatas.minElement()!<0){
                    nowY = (datapoint - appDelegate.graphDatas.minElement()!)/yAxisMax * (graphHeight - circleWidth)
                    nowY = graphHeight - nowY
                }
                
                //次のポイントを計算
                var nextY: CGFloat = 0
                nextY = appDelegate.graphDatas[Int(count)]/yAxisMax * (graphHeight - circleWidth)
                print("nextY1:\(nextY)")
                nextY = graphHeight - nextY
                print("nextY2:\(nextY)")
                
                if(appDelegate.graphDatas.minElement()!<0){
                    nextY = (appDelegate.graphDatas[Int(count+1)] - appDelegate.graphDatas.minElement()!)/yAxisMax * (graphHeight - circleWidth)
                    nextY = graphHeight - nextY - circleWidth
                }
                
                //最初の開始地点を指定
                var circlePoint:CGPoint = CGPoint()
                if Int(count) == 0 {
                    linePath.moveToPoint(CGPoint(x: count * memoriMargin + circleWidth, y: nowY))
                    circlePoint = CGPoint(x: count * memoriMargin + circleWidth, y: nowY)
                    myCircle = UIBezierPath(arcCenter: circlePoint,radius: circleWidth,startAngle: 0.0,endAngle: CGFloat(M_PI*2),clockwise: false)
                    circleColor.setFill()
                    myCircle.fill()
                    myCircle.stroke()
                }
                
                //描画ポイントを指定
                linePath.addLineToPoint(CGPoint(x: (count+1) * memoriMargin, y: nextY))
                
                //円をつくる
                circlePoint = CGPoint(x: (count+1) * memoriMargin, y: nextY)
                myCircle = UIBezierPath(arcCenter: circlePoint,
                                        // 半径
                    radius: circleWidth,
                    // 初角度
                    startAngle: 0.0,
                    // 最終角度
                    endAngle: CGFloat(M_PI*2),
                    // 反時計回り
                    clockwise: false)
                circleColor.setFill()
                myCircle.fill()
                myCircle.stroke()
                
                print("drawRect\(count)回目")
            }
            
            count += 1
            
        }
        
        linePath.stroke()
        
        drawTopLine()
        drawBottomLine()
        drawLeadingLine()
        drawTrailingLine()
        drawHorizontalLines()
        
    }
    
    func drawLine(from: CGPoint, to: CGPoint){
        let linePath = UIBezierPath()
        
        linePath.moveToPoint(from)
        linePath.addLineToPoint(to)
        
        linePath.lineWidth = 0.5
        
        let color = UIColor.blackColor()
        color.setStroke()
        linePath.stroke()
        linePath.closePath()
    }
    
    func drawTopLine(){
        drawLine(CGPoint(x: 0, y: 0), to: CGPoint(x: viewWidth-20, y: 0))
    }
    
    func drawBottomLine(){
        drawLine(CGPoint(x: 0, y: viewHeight-120), to: CGPoint(x: viewWidth-20, y: viewHeight-120))
    }
    
    func drawLeadingLine(){
        drawLine(CGPoint(x: 0, y: 0), to: CGPoint(x: 0, y: viewHeight))
    }
    
    func drawTrailingLine(){
        drawLine(CGPoint(x: viewWidth-40, y: 0), to: CGPoint(x: viewWidth-40, y: viewHeight-120))
    }
    
    func drawHorizontalLines(){
        for i in 1..<4{
            let y = (viewHeight-120)/4 * CGFloat(i)
            drawLine(CGPoint(x: 0, y: y), to: CGPoint(x: viewWidth-20, y: y))
        }
    }

    
    // 保持しているDataの中で最大値と最低値の差を求める
    var yAxisMax: CGFloat {
        return 100
            //graphDatas.maxElement()! - graphDatas.minElement()!
    }
    
    //グラフ横幅を算出
    func checkWidth() -> CGFloat{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        return CGFloat(appDelegate.graphPoints.count-1) * memoriMargin + (circleWidth * 2)
    }
    
    //グラフ縦幅を算出
    func checkHeight() -> CGFloat{
        return viewHeight-120
    }
    
    
}
