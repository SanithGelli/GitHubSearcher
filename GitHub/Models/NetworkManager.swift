//
//  NetworkManager.swift
//  GitHub
//
//  Created by Sanith on 5/6/20.
//  Copyright © 2020 Sanith. All rights reserved.
//

import Foundation

typealias networkSuccessHandler = (_ data: Data?, _ error: NSError?) -> Void

class NetworkManager: NSObject {
    static let sharedManager: NetworkManager = NetworkManager()
    
    var url: URL?
    
    /// session object is creates only once
    lazy var session: URLSession = {
        var configuration: URLSessionConfiguration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = true
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        let session = URLSession(configuration: configuration)
        return session
    }()
    
    override init() {
        super.init()
    }
    
    func getRequest(url: URL?, onCompletion: @escaping networkSuccessHandler ) {
        
        if let url = url {
            var request = URLRequest(url: url);
            request.timeoutInterval = 120
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil || data == nil {
                    print("Client error!")
                    onCompletion(nil, error as NSError?)
                }
                
                if let data = data {
                    onCompletion(data, nil)
                    
                }
            }.resume()
        }
    }
}
