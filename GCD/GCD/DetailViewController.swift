//
//  DetailViewController.swift
//  Whitehouse Petitions
//
//  Created by Alexey Meleshkevich on 08.04.2020.
//  Copyright © 2020 Alexey Meleshkevich. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let detail = detailItem else { return }
        
        let html = """
        <html>
        <head>
        <meta name ="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        \(detail.body)
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    
}
