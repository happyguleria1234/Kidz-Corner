import UIKit

class Devices: UIViewController {
    
    var selectedIndex: Int = -1
    var isDeviceConnected: Bool = false
    var bluetooth: BabyBluetooth = BabyBluetooth.share()
    var centralManager: CBCentralManager?
    var centralPeripheralManager: CBPeripheralManager?
    
    var deviceArray: [CBPeripheral] = [] {
        didSet {
            if deviceArray.count == 0 {
                labelNoDevices.isHidden = false
            }
            else {
                labelNoDevices.isHidden = true
            }
        }
    }
    
    @IBOutlet weak var labelNoDevices: UILabel!
    @IBOutlet weak var tableDevices: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupTable()
    }
    
    @IBAction func backFunc(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupViews() {
        RYBlueToothTool.sharedInstance().setupBluetooth()
        RYBlueToothTool.sharedInstance()?.scanBluetooth() //Added
        RYBlueToothTool.sharedInstance().delegate = self
        
        centralManager?.delegate = self
    }
    
    func setupTable() {
        tableDevices.register(UINib(nibName: "DevicesCell", bundle: nil), forCellReuseIdentifier: "DevicesCell")
        tableDevices.register(UINib(nibName: "DevicesHeader", bundle: nil), forCellReuseIdentifier: "DevicesHeader")
        tableDevices.delegate = self
        tableDevices.dataSource = self
    }
}

extension Devices: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceArray.count
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let indx = IndexPath(row: 0, section: section)
//       let cell = tableView.dequeueReusableCell(withIdentifier: "DevicesHeader", for: indx) as! DevicesHeader
//
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DevicesCell", for: indexPath) as! DevicesCell
        
        let data = deviceArray[indexPath.row]
        
        cell.labelName.text = data.name
        
        if indexPath.row == selectedIndex {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
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
//MARK: Bluetooth Connectivity
extension Devices: RYBlueToothToolDelegate, CBCentralManagerDelegate {
    
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
