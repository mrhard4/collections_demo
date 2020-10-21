//
//  PlainTableViewController.swift
//  CollectionsDemo
//
//  Created by a.dirsha on 19.10.2020.
//

import UIKit

final class TableViewController: BaseTableViewController {
    private var hasDeletableSection = true
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.hasDeletableSection ? 3 : 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 4
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let style = UITableViewCell.CellStyle(rawValue: indexPath.row) ?? .subtitle
        let reuseId = "default \(style.rawValue)"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) ?? UITableViewCell(style: style, reuseIdentifier: reuseId)
        
        var configurration = cell.defaultContentConfiguration()
        configurration.text = "text"
        configurration.secondaryText = "Secondary Text"
        
        if indexPath.row == 1 {
            configurration.textProperties.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        }
        
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                cell.accessoryType = .checkmark
            case 1:
                cell.accessoryType = .disclosureIndicator
            case 2:
                cell.accessoryType = .detailButton
            case 3:
                cell.accessoryType = .detailDisclosureButton
                cell.backgroundView = UIView()
                cell.selectedBackgroundView = UIView()
                cell.backgroundView?.backgroundColor = .lightGray
                cell.selectedBackgroundView?.backgroundColor = .darkGray
            default:
                break
            }
        }
        
        configurration.image = UIImage(systemName: "figure.walk")
        cell.contentConfiguration = configurration
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 3 {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Header title \(section)"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        "Footer title \(section)"
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 2 {
            return UISwipeActionsConfiguration(actions: [
                .init(style: .destructive, title: "Delete", handler: { [weak self] (_, _, handler) in
                    self?.hasDeletableSection = false
                    self?.tableView.reloadData()
                    self?.tableView.deleteSections(.init(integer: 2), with: .automatic)
                    handler(true)
                })
            ])
        }
        return nil
    }
}
