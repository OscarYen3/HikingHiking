//
//  WebViewController.swift
//  Hiking
//
//  Created by OscarYen on 2019/1/2.
//  Copyright © 2019 OscarYen. All rights reserved.
//

import UIKit
import WebKit



class WebViewController: UIViewController,WKNavigationDelegate,WKUIDelegate {
    
    @IBOutlet weak var v2: UIView!
    @IBOutlet weak var myActivitylndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    var WebViewController: WKWebView!
    var xmlURL: String!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        
        
        if let url = URL(string:self.xmlURL) {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        myActivitylndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        myActivitylndicator.stopAnimating()
    }
    
}

