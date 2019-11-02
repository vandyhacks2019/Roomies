//
//  ViewController.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/1/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import UIKit
import Charts

class DashboardViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pieChartUpdate()
    }
    
    var dictionary: [String:Double]
    
    @IBOutlet weak var pieChart: PieChartView!

    @IBOutlet weak var nameInput : UITextField!
    
    @IBOutlet weak var amountInput : UITextField!
    
    //Button pressed, if text field not empty, format the number and empty the text field.
    var i = 0;
    @IBAction func btnAddTapped(_ sender: Any) {
        if let name = nameInput.text , value != "", let amount = amountInput.text , amount != ""  {
    let visitorCount = VisitorCount()
        visitorCount.count = Double((NumberFormatter().number(from: amount)?.intValue)!)
            dictionary[name] = value;
            
            var entryCounter = "entry" + i;
            for (key,value) in dictionary {
                
                var entryCounter = PieChartDataEntry(value: Double(value.value), label: key)
                i++;
            }
            
        var componentArray = Array(dictionary.keys)
            
        var dataSet = PieChartDataSet(values: componentArray, label: "Bills")
            
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
        pieChart.chartDescription?.text = "Share of Widgets by Type"
            
            amountInput.text = ""
            nameInput.text = ""
            
     }
        
    
    }
}

