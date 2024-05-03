
import UIKit

//MARK: App Delegate
/*
 
 var bluetooth : BabyBluetooth? = BabyBluetooth.share()

 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
   
     bluetooth?.cancelAllPeripheralsConnection()
     RYBlueToothTool.sharedInstance().cancelScan()
 
     if (UserDefaults.standard.string(forKey: "BluetoothUUID") != nil){
         UserDefaults.standard.removeObject(forKey: "BluetoothUUID")
     }
     
 */

//MARK: On the screen where bluetooth device is selected and to be paired
/*
 
 class BluetoothDevices: UIViewController {
 
 var bluetooth: BabyBluetooth = BabyBluetooth.share()
 var centralManager: CBCentralManager?
 var centralPeripheralManager: CBPeripheralManager?
 
 override func viewDidLoad() {
 super.viewDidLoad()

 RYBlueToothTool.sharedInstance().setupBluetooth()
 RYBlueToothTool.sharedInstance()?.scanBluetooth() //Added
 RYBlueToothTool.sharedInstance().delegate = self
 centralManager?.delegate = self
 
 }
 
 THIS IS A TABLE THAT WILL SHOW THE LIST OF DEVICES TO CONNECT VIA BLUETOOTH
 
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    selectedIndex = indexPath.row
    
    if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
    tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    else {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    RYBlueToothTool.sharedInstance().delegate = self
    RYBlueToothTool.sharedInstance().cancelScan()
    let peripheral = deviceArray[indexPath.row]
    RYBlueToothTool.sharedInstance().uuidString = peripheral.identifier.uuidString
    RYBlueToothTool.sharedInstance().scanBluetooth()
    
    DispatchQueue.main.async { [self] in
        tableView.reloadData()
    }
    UserDefaults.standard.set(peripheral.identifier.uuidString, forKey: "BluetoothUUID")//Added
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
        self.navigationController?.popViewController(animated: true)
    }
}
 }
 
 extension BluetoothDevices: RYBlueToothToolDelegate, CBCentralManagerDelegate {
     
     func centralManagerDidUpdateState(_ central: CBCentralManager) {
         switch central.state {
         case .poweredOn:
             //print("\n\n\n\nBluetooth is On.\n\n\n\n")
             break
         case .poweredOff:
             //print("\n\n\n\nBluetooth is Off.\n\n\n\n")
             break
         case .resetting:
             //print("\n\n\n\nBluetooth is Resseting.\n\n\n\n")
             break
         case .unauthorized:
             //print("Bluetooth is Unauthorized.\n\n\n\n")
             break
         case .unsupported:
             //print("\n\n\n\nBluetooth is Unsupported.\n\n\n\n")
             break
         case .unknown:
             //print("\n\n\n\nBluetooth is Unknown.\n\n\n\n")
             break
         default:
             break
         }
     }
     
     func peripheralState(peripheralState : CBPeripheralState){
         switch peripheralState {
         case CBPeripheralState.connected:
             //print("\n\n\nperipheral is connected.\n\n\n\n")
             if UserDefaults.standard.string(forKey: "BluetoothUUID") != nil{
                 isDeviceConnected = true
             }
             break
         case CBPeripheralState.connecting:
             //print("\n\n\nperipheral is connecting.\n\n\n\n")
             break
         case CBPeripheralState.disconnected:
             //print("\n\n\nperipheral is disconnected.\n\n\n\n")
             break
         case CBPeripheralState.disconnecting:
             //print("\n\n\nperipheral is disconnecting.\n\n\n\n")
             break
         default:
             break
         }
     }
     
     func matchSuccess(_ peripheral: CBPeripheral!) {
         if !deviceArray.contains(peripheral) {
             deviceArray.append(peripheral)
             DispatchQueue.main.async {
                 self.tableDevices.reloadData()
             }
         }
         else {
             Toast.toast(message: "No Device Found", controller: self)
         }
     }
     
     func connectionSuccess(_ peripheral: CBPeripheral!, characteristic: CBCharacteristic!) {
         if !deviceArray.contains(peripheral) {
             deviceArray.append(peripheral)
         }
         
         self.peripheralState(peripheralState: peripheral.state)
         
         DispatchQueue.main.async {
             self.tableDevices.reloadData()
         }
     }
     
     func blueToothState(_ open: Bool) {
         if open {
             deviceArray.removeAll()
             RYBlueToothTool.sharedInstance().scanBluetooth()
         }
         else {
             deviceArray.removeAll()
             DispatchQueue.main.async { [self] in
                 tableDevices.reloadData()
                 labelNoDevices.text = "Please turn on bluetooth"
                 labelNoDevices.isHidden = false
             }
         }
     }
     
     func onDisconnect(_ peripheral: CBPeripheral!) {
         labelNoDevices.text = "Device Disconnected"
         labelNoDevices.isHidden = false
     }
 }
 }
 */


//MARK: On the screen where temperature has to be added

/*
 extension TeacherPortfolio: RYBlueToothToolDelegate {
     
     func getReturnValue(_ data: String!) {
         
         let dataArray = data.components(separatedBy: " ")
         if (dataArray.count < 2) {
             return;
         }
         if let count = Int(dataArray[1])  {
             if count == 16{
                 if (dataArray.count != 13) {
                     return;
                 }
                 var temperature : Float = 0.0;
                 if let count9Variable = Int(dataArray[9]){
                     
                     if count9Variable == 0{
                         
                         RYBlueToothTool.sharedInstance().setMode(1, unit: "℃")
                         self.selectedMode = 2
                     }
                 }
                 if let count10Variable = Int(dataArray[10]){
                     if count10Variable == 0{
                         //print("℃")
                     }else if count10Variable == 1{
                         //print("℃")
                     }
                 }
                 if self.selectedMode == 2 {
                     temperature = Float((Float(dataArray[6])! * 256.0 + Float(dataArray[5])!) / 10.0);
                     
                 //    Toast.toast(message: "Temperature = \(String(temperature))", controller: self)
                     
                   //AFTER THIS WE SHOW THE SYNC BUTTON AND THE TEACHER CAN UPLOAD THE TEMPERATURE AND MARK THE ATTENDANCE.
 
                     }
                 }
             }
         }
     }

 */
