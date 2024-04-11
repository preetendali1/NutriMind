//
//  Utilities.swift
//  NutriMind
//
//  Created by Preeten Dali on 14/01/24.
//

import Foundation
import UIKit

final class Utilities {
    static let shared = Utilities()
    private init() {}
    
    @MainActor
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        
        let currentController = controller ?? UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = currentController as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = currentController as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = currentController?.presentedViewController {
            return topViewController(controller: presented)
        }
        return currentController
    }
}
