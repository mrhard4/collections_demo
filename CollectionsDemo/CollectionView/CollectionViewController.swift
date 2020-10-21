//
//  CollectionViewController.swift
//  CollectionsDemo
//
//  Created by a.dirsha on 19.10.2020.
//

import UIKit

final class CollectionViewController: BaseCollectionViewController, UICollectionViewDelegateFlowLayout {
    private final class Cell: UICollectionViewCell {
        let label = UILabel()
        
        override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
            layoutAttributes.frame.size = self.contentView.systemLayoutSizeFitting(layoutAttributes.size, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            return layoutAttributes
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.label.numberOfLines = 0
            self.label.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(self.label)
            self.label.pins(UIEdgeInsets(top: 16.0, left: 24.0, bottom: -16.0, right: -24.0))
            
            self.backgroundView = UIView()
            self.backgroundView?.backgroundColor = .systemBackground
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    private let layout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(Cell.self, forCellWithReuseIdentifier: "cell")
    }
    
    override func makeLayout() -> UICollectionViewLayout {
        return self.layout
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.layout.estimatedItemSize = CGSize(width: self.collectionView.frame.width, height: 50.0)
        self.layout.itemSize = CGSize(width: self.collectionView.frame.width, height: UICollectionViewFlowLayout.automaticSize.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? Cell else {
            fatalError()
        }
        
        var text = "UICollectionViewCell"
        for _ in (0...indexPath.item) {
            text += "\nUICollectionViewCell"
        }
        cell.label.text = text
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        CGSize(width: collectionView.frame.width, height: UICollectionViewFlowLayout.automaticSize.height)
//    }
}
