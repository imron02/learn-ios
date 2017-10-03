//
//  Overlay.swift
//  Flutterasia
//
//  Created by Imron Rosdiana on 30/09/17.
//  Copyright © 2017 Imron Rosdiana. All rights reserved.
//

import UIKit

extension UIViewController {
    func showOverlay(_ text: String) -> Void {
        let alert = LoadingOverlay.showLoadingOverlay(message: text);
        self.present(alert, animated: true, completion: nil)
    }
    
    func dismissOverlay() -> Void {
        LoadingOverlay.dismissLoadingOverlay()
    }
}

open class LoadingOverlay: NSObject {
    static var alert: UIAlertController?
    static var loading: UIActivityIndicatorView?
    
    open class func showLoadingOverlay(message: String?) -> UIAlertController {
        alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        loading = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loading?.activityIndicatorViewStyle = .gray
        loading?.hidesWhenStopped = true
        loading?.startAnimating()
        
        alert?.view.addSubview(loading!)
        return alert!
    }
    
    open class func dismissLoadingOverlay() -> Void {
        loading?.stopAnimating()
        alert?.dismiss(animated: true, completion: nil)
    }
}
