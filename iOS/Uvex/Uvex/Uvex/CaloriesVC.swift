//
//  CaloriesVC.swift
//  Uvex
//
//  Created by Alphamicron on 8/23/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit
import Charts

class CaloriesVC: UIViewController
{
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var barChartView: BarChartView!
    
    var unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
    
    var months: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var daysOfTheWeek: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var monthlyWeeks: [String] = ["Week I", "Week II", "Week III", "Week IV"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        dateLabel.text = NSDate().todaysDate
        
        // GUI Stuff
        barChartView.descriptionText = ""
        barChartView.legend.enabled = false
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.labelPosition = .Bottom
        barChartView.drawGridBackgroundEnabled = false
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
        
        drawChart(xAxisValues: &months, yAxisValues: &unitsSold)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func timePeriodAction(sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex
        {
        case 0: prepDataForTheDay()
        case 1: prepDataForTheWeek()
        case 2: prepDataForTheMonth()
        default: break
        }
    }
    
    func drawChart(inout xAxisValues dataPoints: [String], inout yAxisValues values: [Double])
    {
        var dataEntries: [BarChartDataEntry] = [BarChartDataEntry]()
        
        for i in 0..<dataPoints.count
        {
            dataEntries.append(BarChartDataEntry(value: values[i], xIndex: i))
        }
        
        var dataSet: BarChartDataSet = BarChartDataSet()
        
        if barChartView.data?.dataSetCount > 0
        {
            dataSet = barChartView.data?.dataSets[0] as! BarChartDataSet
            dataSet.yVals = dataEntries
            barChartView.data?.xValsObjc = dataPoints
            barChartView.data?.notifyDataChanged()
            barChartView.notifyDataSetChanged()
        }
        else
        {
            dataSet = BarChartDataSet(yVals: dataEntries, label: "Units Sold")
            let chartData = BarChartData(xVals: months, dataSet: dataSet)
            
            dataSet.drawValuesEnabled = false
            dataSet.colors = [UIColor(red: 0.918, green: 0.471, blue: 0.196, alpha: 1.00)]
            
            barChartView.data = chartData
        }
    }
    
    func prepDataForTheDay()
    {
        caloriesLabel.text = ""
        drawChart(xAxisValues: &self.months, yAxisValues: &self.unitsSold)
    }
    
    func prepDataForTheWeek()
    {
        caloriesLabel.text = ""
        var daysOfTheWeek: Int = 7
        var first: Int = 10, second: Int = 10000
        var numberOfSteps: [Double] = [Double]()
        
        while daysOfTheWeek != 0
        {
            numberOfSteps.append(Double(FitnessTVC.randomNumber(from: &first, to: &second)))
            
            daysOfTheWeek -= 1
        }
        
        drawChart(xAxisValues: &self.daysOfTheWeek, yAxisValues: &numberOfSteps)
    }
    
    func prepDataForTheMonth()
    {
        caloriesLabel.text = ""
        var weeksOfTheMonth: Int = 4
        var first: Int = 200, second: Int = 100000
        var numberOfSteps: [Double] = [Double]()
        
        while weeksOfTheMonth != 0
        {
            numberOfSteps.append(Double(FitnessTVC.randomNumber(from: &first, to: &second)))
            
            weeksOfTheMonth -= 1
        }
        
        drawChart(xAxisValues: &self.monthlyWeeks, yAxisValues: &numberOfSteps)
    }
}

extension CaloriesVC: ChartViewDelegate
{
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight)
    {
        caloriesLabel.text = String(Int(entry.value))
        print("User tapped on \(entry.value)")
    }
}