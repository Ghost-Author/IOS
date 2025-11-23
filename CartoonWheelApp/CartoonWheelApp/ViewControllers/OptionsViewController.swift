//
//  OptionsViewController.swift
//  CartoonWheelApp
//
//  Created by liupeng on 2025/11/20.
//

import UIKit

class OptionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var options: [WheelOption] = []
    var onSave: (([WheelOption]) -> Void)?
    
    private let tableView = UITableView()
    private let addButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "自定义选项"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OptionCell.self, forCellReuseIdentifier: OptionCell.identifier)
        view.addSubview(tableView)
        
        addButton.setTitle("添加选项", for: .normal)
        addButton.addTarget(self, action: #selector(addOption), for: .touchUpInside)
        view.addSubview(addButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addButton.frame = CGRect(x: 0, y: view.frame.height-60, width: view.frame.width, height: 60)
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height-60)
    }
    
    @objc func addOption() {
        let alert = UIAlertController(title: "新选项", message: "输入选项名称", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "选项名称" }
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "添加", style: .default) { [weak self] _ in
            guard let self = self, let text = alert.textFields?.first?.text, !text.isEmpty else { return }
            let newOption = WheelOption(title: text, colorHex: self.randomColor())
            self.options.append(newOption)
            self.tableView.reloadData()
        })
        present(alert, animated: true)
    }
    
    private func randomColor() -> String {
        let colors = ["#FF6B6B", "#FFD93D", "#6BCB77", "#4D96FF", "#9D4EDD"]
        return colors.randomElement() ?? "#FF6B6B"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { options.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OptionCell.identifier, for: indexPath) as! OptionCell
        cell.configure(with: options[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            options.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        onSave?(options)
    }
}
