//
//  ViewController.swift
//  WebKitSnapshotTest
//
//  Created by Developer Dude on 10/19/17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var imageView: UIImageView!
    let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.frame = CGRect(x: view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        view.addSubview(webView)
        webView.load(URLRequest(url: URL(string: "https://www.apple.com")!))
        webView.navigationDelegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateWith(_ image: UIImage?) {
        if let image = image {
            imageView.image = image
            webView.removeFromSuperview()
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: WKNavigationDelegate

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // webView.frame.size == .zero initially, so put in a delay.
        // It still may be .zero, though. In that case we'll just call the
        // delegate method again.
        let deadlineTime = DispatchTime.now() + .milliseconds(300)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            guard webView.scrollView.contentSize.height > 0 else {
                self.webView(webView, didFinish: navigation)
                return
            }
            webView.snapshotWebView(completionHandler: { (image, _) in
                self.updateWith(image)
            })
        }
    }

}

