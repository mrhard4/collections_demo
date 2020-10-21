//
//  PlainTableViewController.swift
//  CollectionsDemo
//
//  Created by a.dirsha on 19.10.2020.
//

import UIKit

final class SelfSizingTableViewController: BaseTableViewController {
    private final class Cell: UITableViewCell {
        let customLabel = UILabel()
        
        init() {
            super.init(style: .default, reuseIdentifier: "cell")
            
            self.customLabel.numberOfLines = 0
            
            self.customLabel.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(self.customLabel)
            
            self.customLabel.pins(UIEdgeInsets(top: 20.0, left: 20.0, bottom: -20.0, right: -20.0))
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? Cell ?? Cell()
        
        cell.customLabel.text = "Very very \n\n\n long text"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Self-sizing"
        default:
            return "Static"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return 60.0
        default:
            return 0.0
        }
    }
}
