//
//  HistoryCell.swift
//  CartoonWheelApp
//
//  Created by liupeng on 2025/11/20.
//

import UIKit

class HistoryCell: UITableViewCell {
    static let identifier = "HistoryCell"
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16)
        lbl.textColor = .darkGray
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 20, y: 0, width: contentView.frame.width-40, height: contentView.frame.height)
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
