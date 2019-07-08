//
//  HttpServerBridger.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2019/09/29.
//  Copyright © 2019 WataruSuzuki. All rights reserved.
//

import UIKit
import Swifter

class HttpServerBridger: NSObject
    //, HttpServerIODelegate
{
    private let portNumber = 8081
    private let server = HttpServer()
    
    var url: URL {
        get { return URL(string: "http://localhost:\(portNumber)/index.html")! }
    }

    func startCocoaHTTPServer() {
        let path = UtilFileManager.getProfilesAppGroupPath()
        print(path)
        server["/:path"] = shareFilesFromDirectory(
            path,
            defaults: [
                "index.html",
                "configrationProfile.html",
                "set-to-device.mobileconfig"]
        )
        //server.delegate = self
        do {
            try server.start(in_port_t(portNumber))
        } catch {
            //(・A・)!!
            // fatalError("Swifter could not start!!")
        }
    }
    
    // MARK: HttpServerIODelegate
    /*
    func socketConnectionReceived(_ socket: Socket) {
        
    }
    */
}
