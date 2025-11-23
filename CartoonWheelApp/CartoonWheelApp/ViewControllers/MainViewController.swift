//
//  MainViewController.swift
//  CartoonWheelApp
//
//  Created by liupeng on 2025/11/20.
//

import UIKit

class MainViewController: UIViewController {
    
    private let wheel = WheelView()
    private let spinButton = UIButton(type: .system)
    private var options: [WheelOption] = [
        WheelOption(title: "🍎", colorHex: "#FF6B6B"),
        WheelOption(title: "🍌", colorHex: "#FFD93D"),
        WheelOption(title: "🥦", colorHex: "#6BCB77"),
        WheelOption(title: "🍇", colorHex: "#4D96FF")
    ]
    private var history: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "卡通转盘"
        
        wheel.options = options
        view.addSubview(wheel)
        
        spinButton.setTitle("旋转", for: .normal)
        spinButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        spinButton.addTarget(self, action: #selector(spinWheel), for: .touchUpInside)
        view.addSubview(spinButton)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "选项", style: .plain, target: self, action: #selector(showOptions)),
            UIBarButtonItem(title: "历史", style: .plain, target: self, action: #selector(showHistory))
        ]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = view.frame.width - 40
        wheel.frame = CGRect(x: 20, y: 150, width: size, height: size)
        spinButton.frame = CGRect(x: 50, y: wheel.frame.maxY + 30, width: view.frame.width-100, height: 50)
    }
    
    @objc private func spinWheel() {
        wheel.spin()
        DispatchQueue.main.asyncAfter(deadline: .now()+3.1) {
            let index = Int.random(in: 0..<self.options.count)
            let result = self.options[index].title
            self.history.insert(result, at: 0)
        }
    }
    
    @objc private func showOptions() {
        let vc = OptionsViewController()
        vc.options = options
        vc.onSave = { [weak self] updated in
            self?.options = updated
            self?.wheel.options = updated
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func showHistory() {
        let vc = HistoryViewController()
        vc.history = history
        navigationController?.pushViewController(vc, animated: true)
    }
}
