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
    
    var timeOutErrorHappened: Bool = false
    var foundDevices: Array<MBLMetaWear>?
    var centralManager: CBCentralManager = CBCentralManager()
    static var currentlySelectedDevice: MBLMetaWear = MBLMetaWear()
    
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
        self.view.layer.removeAllAnimations()
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
            self.metawearStateLabel.text = connectionState.getState().lowercaseString
            
        default:
            self.connectionBtn.hidden = true
            self.bluetoothImageView.image = UIImage(named: "BT-Orange")
            self.metawearStateLabel.textColor = Constants.themeOrangeColour
            self.metawearStateLabel.text = connectionState.getState().lowercaseString
        }
    }
    
    // POST: animates only during the connection establishment phase
    func animateConnectionLogo()
    {
        if Constants.isDeviceConnected() || timeOutErrorHappened
        {
            self.view.layer.removeAllAnimations()
        }
        else
        {
            UIView.animateWithDuration(1.0, animations: {
                self.bluetoothImageView.alpha = 0
            }) { (completed: Bool) in
                UIView.animateWithDuration(1.0, delay: 0, options: [.CurveLinear, .AllowUserInteraction], animations: {
                    self.bluetoothImageView.alpha = 1.0
                    }, completion: { (completed: Bool) in
                        
                        self.animateConnectionLogo()
                })
            }
        }
    }
    
    func connectToMetaWear()
    {
        self.connectionBtn.userInteractionEnabled = false
        // get the discovered metawear
        if let selectedDevice = foundDevices?[0]
        {
            self.animateConnectionLogo()
            self.metawearStateLabel.text = "connecting..."
            
            ConnectionVC.currentlySelectedDevice = selectedDevice
            
            // makes multiple connection attempts to metawear under Constants.defaultTimeOut time
            ConnectionVC.currentlySelectedDevice.connectWithTimeout(Constants.defaultTimeOut, handler: { (error: NSError?) in
                
                // a connection timeout error
                if let connectionError = error
                {
                    print("Connection Timeout")
                    
                    self.timeOutErrorHappened = true
                    
                    Constants.defaultErrorAlert(self, errorTitle: "Error", errorMessage: connectionError.localizedDescription, buttonText: "dismiss")
                    self.centralManager.stopScan()
                    self.viewWillAppear(true)
                    self.setupUI(basedOnConnection: MBLConnectionState.Disconnected)
                }
                else
                {
                    // flash the Metawear LED Green just to confirm its the right device
                    ConnectionVC.currentlySelectedDevice.led?.flashLEDColorAsync(Constants.themeGreenColour, withIntensity: 1.0, numberOfFlashes: 3)
                    
                    // erase all non-volatile memory data and results into a disconnection
                    //                        ConnectionVC.currentlySelectedDevice.setConfiguration(nil, handler: nil)
                    self.setupUI(basedOnConnection: MBLConnectionState.Connected)
                    self.connectionBtn.setTitle("disconnect", forState: .Normal)
                    self.connectionBtn.userInteractionEnabled = true
                }
            })
        }
    }
    
    func disconnectFromMetaWear()
    {
        print("user wants to disconnect device")
        
        ConnectionVC.currentlySelectedDevice.disconnectWithHandler(nil)
        self.setupUI(basedOnConnection: MBLConnectionState.Disconnected)
        self.viewWillAppear(true)
    }
    
    @IBAction func connectionAction(sender: UIButton)
    {
        if Constants.isDeviceConnected()
        {
            let userAlert = JSSAlertView().show(
                self,
                title: "Confirm",
                text: "Are you sure you want to disconnect the eyewear?",
                buttonText: "Yep",
                cancelButtonText: "Nope"
            )
            
            userAlert.setTitleFont("AvenirNext-Regular")
            userAlert.setTextFont("AvenirNext-Regular")
            userAlert.setButtonFont("AvenirNext-Regular")
            userAlert.addAction(disconnectFromMetaWear)
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
            
            Constants.defaultErrorAlert(self, errorTitle: "Bluetooth Error", errorMessage: "Please turn on your bluetooth to connect to the Uvex Eyewear.", buttonText: "dismiss")
            
            MBLMetaWearManager.sharedManager().stopScanForMetaWears()
            //            Constants.displayBackgroundImageOnError(self.view, typeOfError: ErrorState.NoBLEConnection)
            break
            
        case .Resetting:
            print("BLE Resetting")
            MBLMetaWearManager.sharedManager().stopScanForMetaWears()
            break
            
        case .Unauthorized:
            print("BLE Unauthorized")
            Constants.defaultErrorAlert(self, errorTitle: "Authorization Error", errorMessage: "Uvex Eyewear requires access to Bluetooth.", buttonText: "dismiss")
            MBLMetaWearManager.sharedManager().stopScanForMetaWears()
            break
            
        case .Unknown:
            print("BLE Unknown")
            MBLMetaWearManager.sharedManager().stopScanForMetaWears()
            break
            
        case .Unsupported:
            print("BLE Unsupported")
            Constants.defaultErrorAlert(self, errorTitle: "Error", errorMessage: "Device does not support Bluetooth Low Energy technology.", buttonText: "dismiss")
            MBLMetaWearManager.sharedManager().stopScanForMetaWears()
            break
        }
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?)
    {
        Constants.defaultErrorAlert(self, errorTitle: "Connection Error", errorMessage: (error?.localizedDescription)!, buttonText: "dismiss")
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