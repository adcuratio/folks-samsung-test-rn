
import Foundation
import UIKit
import AVFoundation
import Starscream

@available(iOS 12.0, *)
@available(iOS 12.0, *)
@objc(NativeControllerModule)

class NativeControllerModule: NSObject, WebSocketDelegate,MMLANScannerDelegate {
  
  var lanScanner : MMLANScanner!
  var socket: WebSocket!
  var callback: RCTResponseSenderBlock!
  var socketCallback: RCTResponseSenderBlock!
  var isConnected = false
  let server = WebSocketServer()
  dynamic var connectedDevices : [MMDevice]!

  func lanScanDidFindNewDevice(_ device: MMDevice!) {
    if(!self.connectedDevices .contains(device)) {
        self.connectedDevices?.append(device)
    }
  }
  
  func lanScanDidFinishScanning(with status: MMLanScannerStatus) {
    print("FINISHED SCANNING");
    print(self.connectedDevices);
    var ipArray:[String] = [];
    for dev in self.connectedDevices {
      print(dev.ipAddress);
      ipArray.append(dev.ipAddress)
    }
    
    self.callback([NSNull(), ipArray])
  }
  
  func lanScanDidFailedToScan() {
  
  }
  
  
  func didReceive(event: WebSocketEvent, client: WebSocket) {
    switch event {
      case .connected(let headers):
          isConnected = true
          let resultsDict = [
              "success" : true
          ];
          self.socketCallback([NSNull(), resultsDict])
          print("websocket is connected: \(headers)")
      case .disconnected(let reason, let code):
          isConnected = false
          print("websocket is disconnected: \(reason) with code: \(code)")
      case .text(let string):
          print("Received text: \(string)")
      case .binary(let data):
          print("Received data: \(data.count)")
      case .ping(_):
          break
      case .pong(_):
          break
      case .viabilityChanged(_):
          break
      case .reconnectSuggested(_):
          break
      case .cancelled:
          isConnected = false
      case .error(let error):
          isConnected = false
          print(error);
    }
  }
  
  @objc func socketConnect(_ ipaddress: String, callback: @escaping RCTResponseSenderBlock) -> Void {
      print(ipaddress)
      var request = URLRequest(url: URL(string: "wss://"+ipaddress)!)
      request.timeoutInterval = 10
      let pinner = FoundationSecurity(allowSelfSigned: true)
      socket = WebSocket(request: request, certPinner: pinner)
      socket?.delegate = self
      socket?.connect()
      self.socketCallback=callback;
   }
  

  @objc func localDevices(_ message: String, callback: @escaping RCTResponseSenderBlock) -> Void {
//      let resultsDict = [
//        "success" : true
//      ];
      print(message);
      self.callback=callback;
      self.connectedDevices = [MMDevice]();
      self.lanScanner = MMLANScanner(delegate:self);
      self.lanScanner.start()
      //callback([NSNull() ,resultsDict])
   }
}
