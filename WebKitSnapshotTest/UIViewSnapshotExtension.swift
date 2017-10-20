//
//  UIViewSnapshotExtension.swift
//  WebKitSnapshotTest
//
//  Created by Developer Dude on 10/19/17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit
import WebKit

extension UIView {

    /// Create snapshot
    ///
    /// - parameter rect: The `CGRect` of the portion of the view to return. If `nil` (or omitted),
    ///                   return snapshot of the whole view.
    ///
    /// - returns: Returns `UIImage` of the (optionally) specified portion of the view.
    func snapshot(of rect: CGRect? = nil) -> UIImage? {
        // snapshot entire view
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let wholeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // if no `rect` provided, return image of whole view
        guard let image = wholeImage, let rect = rect else {
            return wholeImage
        }

        // otherwise, grab specified `rect` of image
        let scale = image.scale
        let scaledRect = CGRect(x: rect.origin.x * scale, y: rect.origin.y * scale, width: rect.size.width * scale, height: rect.size.height * scale)
        guard let cgImage = image.cgImage?.cropping(to: scaledRect) else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: .up)
    }

}

extension WKWebView {

    func snapshotWebView(completionHandler: ((UIImage?, Error?) -> Void)? = nil) {
        // The below doesn't seem to matter.
        // In Simulator this works well.
        // On a device, the entire image is the right size, but completely blank :/
        /*
        scrollView.setContentOffset(CGPoint.zero, animated: false)
        frame.size = scrollView.contentSize
        self.setNeedsLayout()
        self.layoutIfNeeded()
         */

        if #available(iOS 11.0, *) {
            let configuration = WKSnapshotConfiguration()
            configuration.rect = CGRect(origin: .zero, size: scrollView.contentSize)
            takeSnapshot(with: configuration, completionHandler: { (image, error) in
                completionHandler?(image, error)
            })
        } else {
            let image = snapshot()
            completionHandler?(image, nil)
        }
    }
}
