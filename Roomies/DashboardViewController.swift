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
    func updateChartWithData() {
      var dataEntries: [BarChartDataEntry] = []
      let visitorCounts = getVisitorCountsFromDatabase()
      for i in 0..<visitorCounts.count {
        let dataEntry = BarChartDataEntry(x: Double(i), y: Double(visitorCounts[i].count))
        dataEntries.append(dataEntry)
      }
      let chartDataSet = BarChartDataSet(values: dataEntries, label: "Visitor count")
      let chartData = BarChartData(dataSet: chartDataSet)
      barView.data = chartData
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    

    @IBOutlet weak var textField: UITextField!
    
    @IBAction func btnAddTapped(_ sender: Any) {
    if let value = textField.text , value != "" {
    let visitorCount = VisitorCount()
            visitorCount.count = Double((NumberFormatter().number(from: value)?.intValue)!)
            textField.text = ""
     }
        
    
    }
}

