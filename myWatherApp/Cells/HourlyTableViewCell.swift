

//
//  HourlyTableViewCell.swift
//  myWeatherApp
//
//  Created by Yegor Podduba on 01/02/2024.
//

//MARK: - Настройка карусели в таблице

import UIKit

class HourlyTableViewCell: UITableViewCell {
    
    static let identifier = "HourlyTableViewCell"

    var layout: UICollectionViewFlowLayout!
    
    weak var navigationController: UINavigationController?
    
    let networkManager = NetworkManager(with: .default)

    private lazy var collectionView: UICollectionView = {
        layout = setupFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        collection.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)
        
        collection.dataSource = self
        collection.delegate = self
        
        collection.isUserInteractionEnabled = true
        
        return collection
    }()
    
//        public func configure() {
//        self.backgroundColor = .systemCyan
//    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
        
    private func commonInit() {
        collectionView.reloadData()
        contentView.addSubview(collectionView)
        self.backgroundColor = .systemCyan
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 70, height: 100)
        layout.minimumLineSpacing = 1
        
        return layout
    }
    
}

extension HourlyTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath) as! HourlyCollectionViewCell

        cell.configure()
        
        
        return cell
        
        
    }
}
