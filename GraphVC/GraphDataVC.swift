//
//  GraphDataVC.swift
//  GraphVC
//
//  Created by Tsukasa Hasegawa on 2016/08/24.
//  Copyright © 2016年 Tsukasa Hasegawa. All rights reserved.
//

import UIKit

class GraphDataVC:UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var percent = ["0","1","2","3","4","5","6","7","8","9"
        ,"10","11","12","13","14","15","16","17","18","19",
         "20","21","22","23","24","25","26","27","28","29",
         "30","31","32","33","34","35","36","37","38","39",
         "40","41","42","43","44","45","46","47","48","49",
         "50","51","52","53","54","55","56","57","58","59",
         "60","61","62","63","64","65","66","67","68","69",
         "70","71","72","73","74","75","76","77","78","79",
         "80","81","82","83","84","85","86","87","88","89",
         "90","91","92","93","94","95","96","97","98","99",
         "100"]
    
    var textField: UITextField!
    
    @IBOutlet weak var dataTableView: UITableView!
    
    var pickerView: UIPickerView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        
        pickerView = UIPickerView()
        pickerView.selectRow(0, inComponent: 0, animated: true) // 初期値
        pickerView.frame = CGRectMake(0, 50, view.bounds.width * 0.85, 150) // 配置、サイズ
        pickerView.dataSource = self
        pickerView.delegate = self
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
    }
    /*
     override func didMoveToParentViewController(parent: UIViewController?) {
     super.willMoveToParentViewController(parent)
     if parent == nil {
     print("戻るボタン is tapped")
     self.view.addSubview(graphview)
     graphview.drawLineGraph()
     }
     }
     */
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int)->Int {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.graphPoints.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)->UITableViewCell {
        
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        cell.textLabel?.text = "\(appDelegate.graphDatas[indexPath.row])"
        cell.detailTextLabel?.text = appDelegate.graphPoints[indexPath.row]
        
        return cell
    }
    
    @IBAction func addDataButtonTapped(sender: AnyObject) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        
        let alertController = UIAlertController(title: "新しくデータを追加", message: "数値を入力して下さい。", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default){
            action in print("Cancelが押された！")
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        let otherAction = UIAlertAction(title: "Done", style: .Default){
            action in print("Doneが押された！")
            
            let textToNum = NSNumberFormatter().numberFromString(self.textField.text!)
            
            //入力されたデータをgraphDatasに入力
            appDelegate.graphDatas.append(textToNum as! CGFloat)
            
            //現在の日付をgraphPointsに追加
            let now = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy年MM月dd日"
            let dateString = dateFormatter.stringFromDate(now)
            
            appDelegate.graphPoints.append(dateString)
            
            //label用の配列にStringデータを
            let dateFormatter2 = NSDateFormatter()
            dateFormatter2.locale = NSLocale(localeIdentifier: "ja_JP")
            dateFormatter2.dateFormat = "MM/dd"
            let dateString2 = dateFormatter2.stringFromDate(now)
            
            appDelegate.labelDates.append(dateString2)
            
            print("graphDatasの内容:\(appDelegate.graphDatas)")
            print("graphPointsの内容:\(appDelegate.graphPoints)")
            
            
            self.dataTableView.reloadData()
            
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(otherAction)
        
        //textFieldの追加
        alertController.addTextFieldWithConfigurationHandler({(textField: UITextField!) -> Void in
            
            self.textField = textField
            self.textField!.tag = 1
            self.textField!.placeholder = "達成率を入力"
            self.textField!.inputView = self.pickerView
            self.textField!.addTarget(self, action: #selector(GraphDataVC.textFieldEditing(_:)), forControlEvents: UIControlEvents.EditingDidBegin)
            let toolbar = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
            let doneItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(GraphDataVC.pickerdone))
            let cancelItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(GraphDataVC.pickercancel))
            toolbar.setItems([cancelItem, doneItem], animated: true)
            self.textField.inputAccessoryView = toolbar
        })
        
        
        
        presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    func textFieldEditing(sender: UITextField){
        
    }
    
    //表示列
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //表示個数
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return percent.count
    }
    
    //表示内容
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return percent[row] as String
    }
    
    //選択時
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("列: \(row)")
        print("値: \(percent[row])")
        textField.text = percent[row]
    }
    
    func pickercancel() {
        textField.text = ""
        textField.endEditing(true)
    }
    
    func pickerdone() {
        textField.endEditing(true)
    }
}