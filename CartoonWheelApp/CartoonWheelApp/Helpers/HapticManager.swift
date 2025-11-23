//
//  HapticManager.swift
//  CartoonWheelApp
//
//  Created by liupeng on 2025/11/20.
//

import UIKit

class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    func tick() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
