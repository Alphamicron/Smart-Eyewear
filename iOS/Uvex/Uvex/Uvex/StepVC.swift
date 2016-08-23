//
//  StepVC.swift
//  Uvex
//
//  Created by Alphamicron on 8/23/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit
import Charts

class StepVC: UIViewController
{
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var barChart: BarChartView!
    
    var months: [String] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        dateLabel.text = NSDate().todaysDate
        
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        barChart.userInteractionEnabled = false
        barChart.xAxis.labelPosition = .Bottom
        barChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
        
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        setChart(months, values: unitsSold)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func timePeriodAction(sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex
        {
        case 0: print("Day is ON")
        case 1: print("Week is ON")
        case 2: print("Month is ON")
        default: break
        }
    }
    
    func setChart(dataPoints: [String], values: [Double])
    {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count
        {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Units Sold")
        let chartData = BarChartData(xVals: months, dataSet: chartDataSet)
        
        chartDataSet.colors = [UIColor(red: 0.918, green: 0.471, blue: 0.196, alpha: 1.00)]
        
        barChart.data = chartData
    }
}
