//
//  RootViewController.swift
//  CollectionsDemo
//
//  Created by a.dirsha on 18.10.2020.
//

import UIKit

final class RootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Root"
    }
    
    override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = .secondarySystemBackground
        
        let scrollView = UIScrollView()
        scrollView.contentInset.top = 16.0
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        
        scrollView.pins()
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        stackView.pins()
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.spacing = 4.0
        
        @discardableResult
        func addAction(_ title: String, vc: @autoclosure @escaping () -> UIViewController) -> UIView {
            let view = self.rowView(title)
            view.addGestureRecognizer(BlockTapGestoreRecoginizer { [weak self] in
                let targetVC = vc()
                targetVC.navigationItem.title = title
                self?.navigationController?.pushViewController(targetVC, animated: true)
            })
            stackView.addArrangedSubview(view)
            return view
        }
        
        addAction("Plain table view", vc: TableViewController(style: .plain))
        addAction("Grouped table view", vc: TableViewController(style: .grouped))
        addAction("Insert Grouped table view", vc: TableViewController(style: .insetGrouped))
        let lastTableViewItem = addAction("Self-sizing cell table view", vc: SelfSizingTableViewController(style: .grouped))
        
        stackView.setCustomSpacing(20.0, after: lastTableViewItem)
        
        addAction("Colletion View", vc: CollectionViewController())
        addAction("Header Footer Colletion View", vc: HeaderFooterCollectionViewController())
        addAction("Animated Colletion View", vc: HeaderFooterAnimatedCollectionViewController())
    }
    
    private func rowView(_ title: String) -> UIView {
        let result = UIView()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        result.addSubview(label)
        
        label.vertical(24.0, bottom: -24.0)
        label.leading(16.0)
        
        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = .gray
        chevron.translatesAutoresizingMaskIntoConstraints = false
        result.addSubview(chevron)
        
        chevron.trailing(-16.0)
        chevron.centerY()
        chevron.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8.0).isActive = true
        chevron.setContentHuggingPriority(.required, for: .horizontal)
        chevron.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return result
    }
}
