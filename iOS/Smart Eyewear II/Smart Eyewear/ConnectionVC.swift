//
//  ConnectionVC.swift
//  Smart Eyewear
//
//  Created by Alphamicron on 6/8/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit
import JSSAlertView
import CoreBluetooth

class ConnectionVC: UIViewController
{
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var tapToConnectLabel: UILabel!
    @IBOutlet weak var noDeviceDetectedLabel: UILabel!
    @IBOutlet weak var neutralLabel: UILabel!
    
    var foundDevices: Array<MBLMetaWear>?
    var scanOptions = [CBCentralManagerScanOptionAllowDuplicatesKey : Int(false)]
    var centralManager: CBCentralManager = CBCentralManager()
    static var currentlySelectedDevice: MBLMetaWear = MBLMetaWear()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupTheViewInitially()
        
        MBLMetaWearManager.sharedManager().startScanForMetaWearsAllowDuplicates(false, handler: { (array: [AnyObject]?) -> Void in
            self.foundDevices = array as? [MBLMetaWear]
        })
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barTintColor = Constants.themeRedColour
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "NavBluetoothWhite"))
        
        centralManager = CBCentralManager(delegate: self, queue: dispatch_get_main_queue())
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        
        // if the device is already connected, just continue with the animation
        if Constants.isDeviceConnected()
        {
            self.logoImageView.hidden = false
            self.logoImageView.image = UIImage(named: "LogoRed")
            self.animateConnectionLogo()
            
            neutralLabel.hidden = false
            neutralLabel.text = ConnectionVC.currentlySelectedDevice.state.getState().lowercaseString
        }
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        if centralManager.isScanning
        {
            centralManager.stopScan()
        }
        
        MBLMetaWearManager.sharedManager().stopScanForMetaWears()
        
        view.layer.removeAllAnimations()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // POST: animates only during the connection establishment phase
    func animateConnectionLogo()
    {
        if Constants.isDeviceConnected()
        {
            self.view.layer.removeAllAnimations()
        }
        else
        {
            UIView.animateWithDuration(1.0, animations: {
                self.logoImageView.alpha = 0
            }) { (completed: Bool) in
                UIView.animateWithDuration(1.0, delay: 0, options: [.CurveLinear, .AllowUserInteraction], animations: {
                    self.logoImageView.alpha = 1.0
                    }, completion: { (completed: Bool) in
                        
                        self.animateConnectionLogo()
                })
            }
        }
    }
    
    // POST: hides connection-dependent outlets
    func setupTheViewInitially()
    {
        neutralLabel.hidden = false
        logoImageView.hidden = true
        tapToConnectLabel.hidden = true
        noDeviceDetectedLabel.hidden = true
        logoImageView.image = UIImage(named: "LogoGrey")
        
        //        neutralLabel.hidden = false
        neutralLabel.text = "scanning..."
        
        let imageTapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ConnectionVC.connectToMetaWear(_:)))
        imageTapRecognizer.delegate = self
        
        logoImageView.addGestureRecognizer(imageTapRecognizer)
    }
    
    func connectToMetaWear(sender: UITapGestureRecognizer)
    {
        // get the discovered metawear
        if let selectedDevice = foundDevices?[0]
        {
            neutralLabel.hidden = false
            // disconnect the device
            if Constants.isDeviceConnected()
            {
                // TODO: Uncomment this to disconnect the device
                
                //                let disconnectConfirmationAlert: UIAlertController = UIAlertController(title: "Confirm", message: "Are you sure you want to disconnect device?", preferredStyle: .Alert)
                //                
                //                disconnectConfirmationAlert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
                //                
                //                disconnectConfirmationAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction) in
                //                    print("user wants to disconnect device")
                //                    
                //                    Constants.disconnectDevice()
                //                    self.tapToConnectLabel.hidden = false
                //                    self.logoImageView.image = UIImage(named: "LogoGrey")
                //                    self.viewWillAppear(true)
                //                }))
                //                
                //                presentViewController(disconnectConfirmationAlert, animated: true, completion: nil)
            }
            else
            {
                logoImageView.userInteractionEnabled = false
                animateConnectionLogo()
                neutralLabel.text = "connecting..."
                
                ConnectionVC.currentlySelectedDevice = selectedDevice
                
                // makes multiple connection attempts to metawear under Constants.defaultTimeOut time
                ConnectionVC.currentlySelectedDevice.connectWithTimeout(Constants.defaultTimeOut, handler: { (error: NSError?) in
                    
                    // a connection timeout error
                    if error != nil
                    {
                        self.view.layer.removeAllAnimations()
                        self.noDeviceDetectedLabel.hidden = false
                        self.noDeviceDetectedLabel.text = "connection error"
                        self.neutralLabel.hidden = false
                        self.neutralLabel.text = "try again"
                    }
                    else
                    {
                        // flash the Metawear LED Green just to confirm its the right device
                        ConnectionVC.currentlySelectedDevice.led?.flashLEDColorAsync(Constants.themeGreenColour, withIntensity: 1.0, numberOfFlashes: 3)
                        
                        // erase all non-volatile memory data and results into a disconnection
                        //                        ConnectionVC.currentlySelectedDevice.setConfiguration(nil, handler: nil)
                        
                        ActivationVC.turnPhotoSensor(SwitchState.Off)
                        
                        self.tapToConnectLabel.hidden = true
                        self.neutralLabel.hidden = false
                        self.neutralLabel.text = selectedDevice.state.getState().lowercaseString
                        self.logoImageView.image = UIImage(named: "LogoRed")
                        self.logoImageView.userInteractionEnabled = true
                    }
                })
            }
        }
    }
}

// MARK: Central Manager Delegate
extension ConnectionVC: CBCentralManagerDelegate
{
    func centralManagerDidUpdateState(central: CBCentralManager)
    {
        switch central.state
        {
        case .PoweredOn:
            print("BLE ON")
            self.centralManager.scanForPeripheralsWithServices(nil, options: nil)
            //            self.viewDidLoad()
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
            logoImageView.hidden = false
            tapToConnectLabel.hidden = false
            neutralLabel.text = "device found"
        }
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral)
    {
        print("CBManager connection established")
    }
}

extension ConnectionVC: UIGestureRecognizerDelegate
{
    
}
