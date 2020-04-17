//
//  WikipediaCity.swift
//  CapitalCities
//
//  Created by Alexey Meleshkevich on 17.04.2020.
//  Copyright © 2020 Alexey Meleshkevich. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WikipediaController: UIViewController {
    
    var webView = WKWebView()
    var endPoint = String()
    
    override func loadView() {
        super.loadView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString = "https://en.wikipedia.org/wiki/" + endPoint
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
