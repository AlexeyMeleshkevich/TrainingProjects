//
//  ViewController.swift
//  Browser
//
//  Created by Alexey Meleshkevich on 06.04.2020.
//  Copyright © 2020 Alexey Meleshkevich. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    var webView: WKWebView!
    let searchBar = UISearchBar()
    let progressView = UIProgressView(progressViewStyle: .default)
    var websites = ["google.com", "apple.com","bsu.by"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startSession()
        
        searchBar.delegate = self
        self.navigationController?.navigationBar.addSubview(searchBar)
        setSearchBarConstraints()
        searchBar.placeholder = "Search or enter website name"
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    override func loadView() {
        let webConfiguretion = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguretion)
        webView.navigationDelegate = self
        view = webView
        setToolbar()
        setNavigationItem()
    }
    
    fileprivate func startSession() {
        guard let url = URL(string: "https://www.google.com") else { return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
    }
    
    func loadPage1(action: UIAlertAction) {
        guard let title = action.title else { return }
        guard let url = URL(string: "https://" + title) else { return }
        webView.load(URLRequest(url: url))
        
//        searchBar.text = try! String(contentsOf: url)
        searchBar.text = title
    }
    
    func setNavigationItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showAlert))
    }
    
    @objc func showAlert() {
        let alert = UIAlertController(title: "Choose website", message: nil, preferredStyle: .actionSheet)
        
        for website in websites {
            alert.addAction(UIAlertAction(title: website, style: .default, handler: loadPage1))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func setSearchBarConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.leftAnchor.constraint(equalTo: (self.navigationController?.navigationBar.leftAnchor)!, constant: 5),
            searchBar.rightAnchor.constraint(equalTo: (self.navigationController?.navigationBar.rightAnchor)!, constant: -50),
            searchBar.topAnchor.constraint(equalTo: (self.navigationController?.navigationBar.topAnchor)!, constant: -5)
        ])
    }
    
    func setToolbar() {
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        let forwardItem = UIBarButtonItem(barButtonSystemItem: .fastForward, target: webView, action: #selector(webView.goForward))
        let backItem = UIBarButtonItem(barButtonSystemItem: .rewind, target: webView, action: #selector(webView.goBack))
        toolbarItems = [progressButton, space, backItem, refreshButton, forwardItem]
        self.navigationController?.isToolbarHidden = false
    }
    
    func loadPage2(page: String) {
        guard let url = URL(string: page) else { return }
        webView.load(URLRequest(url: url))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
}


extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        decisionHandler(.cancel)
        
        if url != URL(string: "www.apple.com") {
            let alert = UIAlertController(title: "Error", message: "Not allowed website", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        loadPage2(page: "https://" + text)
    }
    
}

