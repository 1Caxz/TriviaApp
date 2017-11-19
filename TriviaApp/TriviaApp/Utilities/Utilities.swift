//
//  Utilities.swift
//  TriviaApp
//
//  Created by Saiful I. Wicaksana on 18/11/17.
//  Copyright © 2017 icaksama. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

class Utilities {
    
    func winxColorAnimation(view: UIView, colorOne: UIColor, colorTwo: UIColor, duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: {
            view.backgroundColor = colorOne
        }) { (_) in
            UIView.animate(withDuration: duration, animations: {
                view.backgroundColor = colorTwo
            }) { (_) in
                UIView.animate(withDuration: duration, animations: {
                    view.backgroundColor = colorOne
                }) { (_) in
                    UIView.animate(withDuration: duration, animations: {
                        view.backgroundColor = colorTwo
                    }) { (_) in
                        UIView.animate(withDuration: duration, animations: {
                            view.backgroundColor = colorOne
                        }) { (_) in
                            
                        }
                        
                    }
                }
            }
        }
    }
    
    /** Get color from hex code */
    func colorFromHex (hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            print("Color haven't pager character")
            return UIColor.clear
        }
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0))
    }
    
    /** Add corner radius */
    func radiusCorner(views: UIView..., radius: CGFloat) {
        for view: UIView in views {
            view.layer.cornerRadius = radius
            view.layer.masksToBounds = true
            view.clipsToBounds = true
        }
    }
    
    /** Add border views */
    func borderView(views: UIView..., borderWidth: CGFloat, color: UIColor) {
        for view: UIView in views {
            view.layer.borderWidth = borderWidth
            view.layer.borderColor = color.cgColor
        }
    }
    
    /** Get status internet connection */
    func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    /** Delay for programs */
    internal func delay(second: Double, completion: @escaping() -> ()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + second) {
            completion()
        }
    }
    
    /** Show alert dialog with try again button */
    func showErrorDialog(viewController: UIViewController, title: String, message: String, event: @escaping() -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { (action: UIAlertAction!) in
            event()
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    /** Show alert dialog with 2 event button */
    func showDialogCustomEvent(viewController: UIViewController, title: String, message: String, btnText1: String, event1: @escaping() -> (), btnText2: String, event2: @escaping() -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: btnText1, style: .default, handler: { (action: UIAlertAction!) in
            event1()
        }))
        alert.addAction(UIAlertAction(title: btnText2, style: .default, handler: { (action: UIAlertAction!) in
            event2()
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
}
