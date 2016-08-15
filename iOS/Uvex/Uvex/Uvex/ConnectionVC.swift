//
//  ConnectionVC.swift
//  Uvex
//
//  Created by Alphamicron on 8/15/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit
import JSSAlertView
import CoreBluetooth

class ConnectionVC: UIViewController
{
    @IBOutlet weak var bluetoothImageView: UIImageView!
    @IBOutlet weak var metawearStateLabel: UILabel!
    @IBOutlet weak var connectionBtn: UIButton!
    
    var foundDevices: Array<MBLMetaWear>?
    var centralManager: CBCentralManager = CBCentralManager()
    static var currentlySelectedDevice: MBLMetaWear = MBLMetaWear()
    var scanOptions = [CBCentralManagerScanOptionAllowDuplicatesKey : Int(false)]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupBorderLinesOnUI()
        
        MBLMetaWearManager.sharedManager().startScanForMetaWearsAllowDuplicates(false, handler: { (array: [AnyObject]?) -> Void in
            self.foundDevices = array as? [MBLMetaWear]
        })
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        MainPageVC.activateScroll(false)
        
        centralManager = CBCentralManager(delegate: self, queue: dispatch_get_main_queue())
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        setupUI(basedOnConnection: ConnectionVC.currentlySelectedDevice.state)
        self.metawearStateLabel.text = ConnectionVC.currentlySelectedDevice.state.getState().lowercaseString
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        MainPageVC.activateScroll(true)
        
        if centralManager.isScanning
        {
            centralManager.stopScan()
        }
        
        MBLMetaWearManager.sharedManager().stopScanForMetaWears()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func setupBorderLinesOnUI()
    {
        let layer: CALayer = self.metawearStateLabel.layer
        let bottomBorder: CALayer = CALayer(layer: layer)
        
        bottomBorder.borderWidth = 3
        bottomBorder.frame = CGRectMake(-bottomBorder.borderWidth, layer.frame.size.height-bottomBorder.borderWidth, layer.frame.size.width, bottomBorder.borderWidth)
        bottomBorder.borderColor = UIColor(red: 0.282, green: 0.278, blue: 0.278, alpha: 1.00).CGColor
        
        layer.addSublayer(bottomBorder)
    }
    
    func setupUI(basedOnConnection connectionState: MBLConnectionState)
    {
        switch connectionState
        {
        case .Connected:
            self.connectionBtn.hidden = false
            self.bluetoothImageView.image = UIImage(named: "BT-Blue")
            self.metawearStateLabel.textColor = Constants.themeBlueColour
            
        default:
            self.connectionBtn.hidden = true
            self.metawearStateLabel.text = "scanning..."
            self.bluetoothImageView.image = UIImage(named: "BT-Orange")
            self.metawearStateLabel.textColor = Constants.themeOrangeColour
        }
    }
    
    func connectToMetaWear()
    {
        self.connectionBtn.userInteractionEnabled = false
        // get the discovered metawear
        if let selectedDevice = foundDevices?[0]
        {
            self.metawearStateLabel.text = "connecting..."
            
            ConnectionVC.currentlySelectedDevice = selectedDevice
            
            // makes multiple connection attempts to metawear under Constants.defaultTimeOut time
            ConnectionVC.currentlySelectedDevice.connectWithTimeout(Constants.defaultTimeOut, handler: { (error: NSError?) in
                
                // a connection timeout error
                if error != nil
                {
                    print("Connection Timeout")
                    self.connectionBtn.userInteractionEnabled = true
                    //TODO: Alert the user of the timeout
                    //                    self.noDeviceDetectedLabel.hidden = false
                    //                    self.noDeviceDetectedLabel.text = "connection error"
                    //                    self.neutralLabel.hidden = false
                    //                    self.neutralLabel.text = "try again"
                }
                else
                {
                    // flash the Metawear LED Green just to confirm its the right device
                    ConnectionVC.currentlySelectedDevice.led?.flashLEDColorAsync(Constants.themeGreenColour, withIntensity: 1.0, numberOfFlashes: 3)
                    
                    // erase all non-volatile memory data and results into a disconnection
                    //                        ConnectionVC.currentlySelectedDevice.setConfiguration(nil, handler: nil)
                    self.setupUI(basedOnConnection: MBLConnectionState.Connected)
                    self.metawearStateLabel.text = selectedDevice.state.getState().lowercaseString
                    self.connectionBtn.setTitle("disconnect", forState: .Normal)
                    self.connectionBtn.userInteractionEnabled = true
                }
            })
        }
    }
    
    func disconnectFromMetaWear()
    {
        let disconnectConfirmationAlert: UIAlertController = UIAlertController(title: "Confirm", message: "Are you sure you want to disconnect the eyewear?", preferredStyle: .Alert)
        
        disconnectConfirmationAlert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
        
        disconnectConfirmationAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction) in
            print("user wants to disconnect device")
            
            Constants.disconnectDevice()
            self.setupUI(basedOnConnection: MBLConnectionState.Disconnected)
            self.viewWillAppear(true)
        }))
        
        presentViewController(disconnectConfirmationAlert, animated: true, completion: nil)
    }
    
    @IBAction func connectionAction(sender: UIButton)
    {
        if Constants.isDeviceConnected()
        {
            disconnectFromMetaWear()
        }
        else
        {
            connectToMetaWear()
        }
    }
}

extension ConnectionVC: CBCentralManagerDelegate
{
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
            
            Constants.defaultErrorAlert(self, errorTitle: "Bluetooth Error", errorMessage: "Please turn on your bluetooth to connect to the CTRL Eyewear", errorPriority: AlertPriority.High)
            
            MBLMetaWearManager.sharedManager().stopScanForMetaWears()
            Constants.displayBackgroundImageOnError(self.view, typeOfError: ErrorState.NoBLEConnection)
            break
            
        case .Resetting:
            print("BLE Resetting")
            MBLMetaWearManager.sharedManager().stopScanForMetaWears()
            break
            
        case .Unauthorized:
            print("BLE Unauthorized")
            Constants.defaultErrorAlert(self, errorTitle: "Authorisation Error", errorMessage: "Smart Eyewear requires access to Bluetooth", errorPriority: AlertPriority.High)
            MBLMetaWearManager.sharedManager().stopScanForMetaWears()
            break
            
        case .Unknown:
            print("BLE Unknown")
            MBLMetaWearManager.sharedManager().stopScanForMetaWears()
            break
            
        case .Unsupported:
            print("BLE Unsupported")
            Constants.defaultErrorAlert(self, errorTitle: "Error", errorMessage: "Device does not support Bluetooth Low Energy technology", errorPriority: AlertPriority.High)
            MBLMetaWearManager.sharedManager().stopScanForMetaWears()
            break
        }
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?)
    {
        Constants.defaultErrorAlert(self, errorTitle: "Connection Error", errorMessage: (error?.localizedDescription)!, errorPriority: AlertPriority.High)
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber)
    {
        // just discover this particular metawear device
        if peripheral.name == Constants.metaWearName
        {
            self.metawearStateLabel.text = "device found"
            self.connectionBtn.setTitle("connect", forState: .Normal)
            self.connectionBtn.userInteractionEnabled = true
            self.connectionBtn.hidden = false
        }
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral)
    {
        print("CBManager connection established")
    }
}