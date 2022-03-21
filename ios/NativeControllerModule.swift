
import Foundation
import UIKit
import AVFoundation


@available(iOS 12.0, *)
@available(iOS 12.0, *)
@objc(NativeControllerModule)

class NativeControllerModule: NSObject, MMLANScannerDelegate {
  
  var lanScanner : MMLANScanner!
//  var socket: WebSocket!
  var callback: RCTResponseSenderBlock!
  var socketCallback: RCTResponseSenderBlock!
  var isConnected = false
//  let server = WebSocketServer()
  dynamic var connectedDevices : [MMDevice]!

  func lanScanDidFindNewDevice(_ device: MMDevice!) {
    if(!self.connectedDevices.contains(device)) {
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
  
//  func didReceive(event: WebSocketEvent, client: WebSocket) {
////    switch event {
////      case .connected(let headers):
////          isConnected = true
////          let resultsDict = [
////              "success" : true
////          ];
////          self.socketCallback([NSNull(), resultsDict])
////          print("websocket is connected: \(headers)")
////      case .disconnected(let reason, let code):
////          isConnected = false
////          print("websocket is disconnected: \(reason) with code: \(code)")
////      case .text(let string):
////          print("Received text: \(string)")
////      case .binary(let data):
////          print("Received data: \(data.count)")
////      case .ping(_):
////          break
////      case .pong(_):
////          break
////      case .viabilityChanged(_):
////          break
////      case .reconnectSuggested(_):
////          break
////      case .cancelled:
////          isConnected = false
////      case .error(let error):
////          isConnected = false
////          print(error);
////    }
//  }
  
  @objc func socketConnect(_ ipaddress: String, callback: @escaping RCTResponseSenderBlock) -> Void {
//      print(ipaddress)
//      var request = URLRequest(url: URL(string: "wss://"+ipaddress)!)
//      request.timeoutInterval = 10
//      let pinner = FoundationSecurity(allowSelfSigned: true)
//      socket = WebSocket(request: request, certPinner: pinner)
//      socket?.delegate = self
//      socket?.connect()
//      self.socketCallback=callback;
   }
  
  @objc func makesslcall(_ ipaddress: String, callback: @escaping RCTResponseSenderBlock) -> Void {
    print(ipaddress)
    let url = URL(string: ipaddress)!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.timeoutInterval=4;
   
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data {
            print("SUCCESS")
        } else if let error = error {
            print("HTTP Request Failed \(error)")
            print("-------------------");
            if error.localizedDescription.contains("SSL") || error.localizedDescription.contains("ssl") {
              let resultsDict: [Any]  = [
                  [
                    "success" : true,
                    "error": error.localizedDescription,
                    "ip":ipaddress
                  ]
              ]
              print("exists")
              callback([NSNull() ,resultsDict])
              return
            }else{
              let resultsDict: [Any]  = [
                  [
                    "success" : false,
                    "error": error.localizedDescription,
                    "ip":ipaddress
                  ]
              ]
              print("not exists")
              callback([NSNull() ,resultsDict])
              return
            }
            
          let resultsDict: [Any]  = [
                [
                  "success" : false,
                  "error": error.localizedDescription,
                  "ip":ipaddress
                ]
            ]
            callback([NSNull() ,resultsDict])
        }
    }
    task.resume()
   }
  

  @objc func localDevices(_ message: String, callback: @escaping RCTResponseSenderBlock) -> Void {
      let resultsDict = [
        "success" : true
      ];
      print(message);
      self.callback=callback;
      self.connectedDevices = [MMDevice]();
      self.lanScanner = MMLANScanner(delegate:self);
      self.lanScanner.start()
   }
}
