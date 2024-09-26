//
//  ScannerViewController.swift
//  KidzCorner
//
//  Created by Happy Guleria on 21/09/24.
//

import UIKit
import AudioToolbox
import AVFoundation

class ScannerViewController: UIViewController {

    var captureSession = AVCaptureSession()
    var hasProcessedQRCode = false
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var callBack: ((UserScannedData)->())?
    var qrCodeFrameView: UIView?
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Failed to get the camera device")
            return
        }
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            // Set the input device on the capture session.
            captureSession.addInput(input)
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
//            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        // Start video capture.
        DispatchQueue.global(qos: .background).async { [self] in
            captureSession.startRunning()
        }
        // Move the message label and top bar to the front
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
    }
    
    private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
        layer.videoOrientation = orientation
        videoPreviewLayer?.frame = self.view.bounds
    }
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      if let connection =  self.videoPreviewLayer?.connection  {
        let currentDevice: UIDevice = UIDevice.current
        let orientation: UIDeviceOrientation = currentDevice.orientation
        let previewLayerConnection : AVCaptureConnection = connection
        if previewLayerConnection.isVideoOrientationSupported {
          switch (orientation) {
          case .portrait:
            updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
            break
          case .landscapeRight:
            updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
            break
          case .landscapeLeft:
            updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
            break
          case .portraitUpsideDown:
            updatePreviewLayer(layer: previewLayerConnection, orientation: .portraitUpsideDown)
            break
          default:
            updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
            break
          }
        }
      }
    }
    
}
extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
           // Check if the metadataObjects array is not nil and it contains at least one object.
           if metadataObjects.count == 0 || hasProcessedQRCode {
               qrCodeFrameView?.frame = CGRect.zero
               print("No QR code is detected or already processed")
               return
           }

           let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
           if supportedCodeTypes.contains(metadataObj.type) {
               // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
               let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
               qrCodeFrameView?.frame = barCodeObject!.bounds

               DispatchQueue.main.async { [weak self] in
                   if let strongSelf = self, metadataObj.stringValue != nil {
                       AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                       print("metadataObj.stringValue ********", metadataObj.stringValue)
                       if let jsonData = metadataObj.stringValue?.data(using: .utf8) {
                           do {
                               let user = try JSONDecoder().decode(UserScannedData.self, from: jsonData)
                               print("User ID: \(user.id)")
                               self?.hasProcessedQRCode = true
                               strongSelf.navigationController?.popViewController(animated: true, completion: {
                                   strongSelf.callBack?(user)
                               })
                           } catch {
                               self?.hasProcessedQRCode = true
                               strongSelf.navigationController?.popViewController(animated: true, completion: {
                                   Toast.show(message: "Invalid QR Code.", controller: (UIApplication.shared.keyWindow?.rootViewController)!, color: UIColor.red)
                               })
                           }
                       }
                      
                   }
               }
           }
       }
}


struct UserScannedData: Codable {
    let id: Int
    let name: String
    let classes: [Int]
}
