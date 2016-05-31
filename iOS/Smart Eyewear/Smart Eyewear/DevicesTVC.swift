//
//  DevicesTVC.swift
//  Smart Eyewear
//
//  Created by Emil Shirima on 5/24/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreBluetooth

class DeviceTVCell: UITableViewCell
{
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var deviceState: UILabel!
    @IBOutlet weak var deviceUUID: UILabel!
}

class DevicesTVC: UITableViewController
{
    var foundDevices: Array<MBLMetaWear>?
    var centralManager: CBCentralManager = CBCentralManager()
    static var currentlySelectedDevice: MBLMetaWear = MBLMetaWear()
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        print("Devices TVC view will appear was called")
        centralManager = CBCentralManager(delegate: self, queue: dispatch_get_main_queue())
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        print("Devices TVC view did disappear was called")
        if centralManager.isScanning
        {
            centralManager.stopScan()
        }
        
        MBLMetaWearManager.sharedManager().stopScanForMetaWears()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        MBLMetaWearManager.sharedManager().startScanForMetaWearsAllowDuplicates(false, handler: { (array: [AnyObject]?) -> Void in
            self.foundDevices = array as? [MBLMetaWear]
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let numberOfDiscoveredDevices = foundDevices?.count
        {
            return numberOfDiscoveredDevices
        }
        
        return 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! DeviceTVCell
        
        if let currentDevice = foundDevices?[indexPath.row]
        {
            cell.deviceName.text = currentDevice.name
            cell.deviceUUID.text = currentDevice.identifier.UUIDString
            cell.deviceState.text = currentDevice.state.getState()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if let selectedDevice = foundDevices?[indexPath.row]
        {
            let confirmationHUD: MBProgressHUD = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
            
            confirmationHUD.labelText = "Connecting to device..."
            DevicesTVC.currentlySelectedDevice = selectedDevice
            
            DevicesTVC.currentlySelectedDevice.connectWithTimeout(Constants.defaultTimeOut, handler: { (error: NSError?) in
                if let generatedError = error
                {
                    confirmationHUD.labelText = generatedError.localizedDescription
                    confirmationHUD.hide(true, afterDelay: Constants.defaultDelayTime)
                }
                else
                {
                    confirmationHUD.hide(true)
                    DevicesTVC.currentlySelectedDevice.led?.flashLEDColorAsync(UIColor.greenColor(), withIntensity: 1.0)
                    
                    let confirmationAlert = UIAlertController(title: "Confirm Device", message: "Do you see a blinking green LED light?", preferredStyle: .Alert)
                    
                    confirmationAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction) in
                        print("The user confirmed the LED")
                        
                        Constants.turnOffAllLEDs()
                        
                        Constants.delayFor(Constants.defaultDelayTime)
                        {
                            
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                    }))
                    
                    confirmationAlert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: { (action: UIAlertAction) in
                        print("The user did not confirm the LED")
                        Constants.turnOffAllLEDs()
                        Constants.disconnectDevice()
                        self.viewDidLoad()
                    }))
                    
                    self.presentViewController(confirmationAlert, animated: true, completion: nil)
                }
            })
        }
    }
}

// MARK: Central Manager Delegate
extension DevicesTVC: CBCentralManagerDelegate
{
    func centralManagerDidUpdateState(central: CBCentralManager)
    {
        switch central.state
        {
        case .PoweredOn:
            print("BLE ON")
            self.centralManager.scanForPeripheralsWithServices(nil, options: nil)
            self.viewDidLoad()
            break
            
        case .PoweredOff:
            print("BLE OFF")
            presentViewController(Constants.defaultErrorAlert("Connection Error", errorMessage: "Please turn on your bluetooth."), animated: true, completion: nil)
            MBLMetaWearManager.sharedManager().stopScanForMetaWears()
            break
            
        case .Resetting:
            print("BLE Resetting")
            MBLMetaWearManager.sharedManager().stopScanForMetaWears()
            break
            
        case .Unauthorized:
            print("BLE Unauthorized")
            presentViewController(Constants.defaultErrorAlert("Authorisation Error", errorMessage: "Smart Eyewear requires access to your Bluetooth."), animated: true, completion: nil)
            MBLMetaWearManager.sharedManager().stopScanForMetaWears()
            break
            
        case .Unknown:
            print("BLE Unknown")
            MBLMetaWearManager.sharedManager().stopScanForMetaWears()
            break
            
        case .Unsupported:
            print("BLE Unsupported")
            presentViewController(Constants.defaultErrorAlert("Error", errorMessage: "Device does not support Bluetooth Low Energy technology."), animated: true, completion: nil)
            MBLMetaWearManager.sharedManager().stopScanForMetaWears()
            break
        }
        
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?)
    {
        presentViewController(Constants.defaultErrorAlert("Connection Error", errorMessage: (error?.localizedDescription)!), animated: true, completion: nil)
    }
}
