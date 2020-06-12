
/// =====================================================

///  Progressable.swift
///  HelloFresh
///
///  Created by Danijel Kecman on 25/5/19.
///  Copyright © 2017 Danijel Kecman. All rights reserved.

/// https://github.com/danijelkecman/hello-fresh/blob/ad7a00e268eb7e049460afcf255191733bc554d1/HelloFresh/Common/Protocols/Progressable.swift
///
/// ====================================================

import MBProgressHUD

protocol Progressable {
    func showLoading()
    func showLoading(withMessage message: String)
    func hideLoading()
    func hideLoaderWithSuccess(withMessage message: String?)
    func hideLoaderWithError(withMessage message: String?)
}

extension Progressable where Self: UIViewController {
    
    func showLoading() {
        showLoading(withMessage: "")
    }
    
    func showLoading(withMessage message: String) {
        showHUD(withMessage: message)
    }
    
    func hideLoading() {
        if self is UITableViewController {
            MBProgressHUD.hide(for: self.navigationController?.view ?? self.view, animated: true)
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func hideLoaderWithSuccess(withMessage message: String?) {
        hideLoading()
        showHUD(withMessage: message)
    }
    
    func hideLoaderWithError(withMessage message: String?) {
        hideLoading()
        let imageView = UIImageView(image: UIImage(named: "warning_icon"))
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        showHUD(withMessage: message, customView: imageView, hideAfter: 3)
    }
    
    fileprivate func showHUD(withMessage message: String? = nil, customView: UIView? = nil, hideAfter: TimeInterval? = nil) {
        let progressHUD: MBProgressHUD
        
        if self is UITableViewController {
            progressHUD = MBProgressHUD.showAdded(to: self.navigationController?.view ?? self.view, animated: true)
        } else {
            progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        progressHUD.label.text = message
        progressHUD.animationType = .zoom
        
        if let customView = customView {
            progressHUD.mode = .customView
            progressHUD.customView = customView
        }
        
        if let hideAfter = hideAfter {
            progressHUD.hide(animated: true, afterDelay: hideAfter)
        }
    }
}
