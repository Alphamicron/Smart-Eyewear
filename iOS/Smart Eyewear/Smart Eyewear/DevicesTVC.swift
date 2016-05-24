//
//  DevicesTVC.swift
//  Smart Eyewear
//
//  Created by Emil Shirima on 5/24/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit
import CoreBluetooth

class DeviceTVCell: UITableViewCell
{
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var deviceState: UILabel!
    @IBOutlet weak var deviceUUID: UILabel!
}

class DevicesTVC: UITableViewController, CBCentralManagerDelegate
 {

    var centralManager: CBCentralManager = CBCentralManager()
    
    var foundDevices: Array<MBLMetaWear>?
    var currentlySelectedDevice: MBLMetaWear = MBLMetaWear()
    
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        
//        cell.deviceName.text = foundDevices[indexPath.row].name
//        cell.deviceUUID.text = foundDevices[indexPath.row].identifier.UUIDString
//        cell.deviceState.text = foundDevices[indexPath.row].state.getState()

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if let selectedDevice = foundDevices?[indexPath.row]
        {
//            let confirmationHUD = MBProgressHUD
        }
//        if foundDevices[indexPath.row].state != .Connected
//        {
//            centralManager.connectPeripheral(foundDevices[indexPath.row], options: [CBConnectPeripheralOptionNotifyOnDisconnectionKey: NSNumber(bool:true)])
//        }
        
        ViewController.delayFor(1.5)
        {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    // MARK: Central Manager Delegate
    func centralManagerDidUpdateState(central: CBCentralManager)
    {
        switch central.state
        {
        case .PoweredOn:
            print("BLE ON")
            self.centralManager.scanForPeripheralsWithServices(nil, options: nil)
            break
            
        case .PoweredOff:
            print("BLE OFF")
            promptErrorToUser("Error", errorMessage: "Please turn on your bluetooth")
            break
            
        case .Resetting:
            print("BLE Resetting")
            break
            
        case .Unauthorized:
            print("BLE Unauthorized")
            promptErrorToUser("Error", errorMessage: "App requires access to BLE")
            break
            
        case .Unknown:
            print("BLE Unknown")
            break
            
        case .Unsupported:
            print("BLE Unsupported")
            promptErrorToUser("Error", errorMessage: "Device does not support BLE")
            break
        }
        
    }
    
//    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber)
//    {
//        if foundDevices!.contains(peripheral) && peripheral.name != nil
//        {
//            print("Peripheral Details")
//            print(advertisementData)
//            foundDevices.append(peripheral)
//            tableView.reloadData()
//        }
//    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral)
    {
        print("Successfully Connected Device")
        centralManager.stopScan()
        
        let selectedCell = tableView.cellForRowAtIndexPath(tableView.indexPathForSelectedRow!)
        selectedCell?.detailTextLabel?.text = foundDevices![tableView.indexPathForSelectedRow!.row].state.getState()
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?)
    {
        promptErrorToUser("Connection Error", errorMessage: (error?.localizedDescription)!)
    }
    
//    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?)
//    {
//        print("Successfully Disconnected Device")
//        
//        let selectedCell = tableView.cellForRowAtIndexPath(locationOfDeselectedCell)
//        selectedCell?.detailTextLabel?.text = foundDevices[locationOfDeselectedCell.row].state.getState()
//    }
    
    func promptErrorToUser(errorTitle: String, errorMessage: String)
    {
        let alertController = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
