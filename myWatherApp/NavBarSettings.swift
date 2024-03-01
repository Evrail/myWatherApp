//
//  NavBarSettings.swift
//  myWatherApp
//
//  Created by Yegor Podduba on 31/01/2024.
//

import UIKit
import Then

// Расширение навигационного контролера
extension UINavigationController {
    
    // Устанавливаем навигационный бар
    func setupNavBarColor(with color: UIColor) {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = color
        appearance.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
        self.navigationBar.compactAppearance = appearance
        self.navigationBar.compactScrollEdgeAppearance = appearance
        
        
        self.navigationBar.tintColor = .white
        UIBarButtonItem.appearance().tintColor = .white
        
    }
}

// устанавливаем и настраиваем Хэдэр, чтоб в нем было слово "Погода"
class TableHeader: UITableViewHeaderFooterView {

    static let identifer = "TableHeader"
    
    private let label = UILabel().then {
        $0.text = "Погода"
    }
    
    override init(reuseIdentifier reuseIdentifer: String?) {
        super.init(reuseIdentifier: reuseIdentifer)
        contentView.addSubview(label)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}


