//
//  MainViewControllerWrapper.swift
//  CartoonWheelApp
//
//  Created by liupeng on 2025/11/21.
//

import SwiftUI

struct MainViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return UINavigationController(rootViewController: MainViewController())
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
