//
//  DailyTableViewCell.swift
//  myWatherApp
//
//  Created by Yegor Podduba on 01/02/2024.
//

//MARK: - Самая нижняя таблица с днями недели

import UIKit
import Then
import SnapKit

class DailyTableViewCell: UITableViewCell {

    static let identifer = "DailyTableViewCell"
    
    let networkManager: NetworkManager = NetworkManager(with: .default)
    
    let weekDay = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .white
    }
    
    let icon = UIImageView()
    
    let minTemp = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = UIColor(white: 1, alpha: 0.5)
    }
    let maxTemp = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .white
    }
    
    public func configure() {
        
        contentView.backgroundColor = .systemCyan
        contentView.addSubview(weekDay)
        contentView.addSubview(icon)
        contentView.addSubview(minTemp)
        contentView.addSubview(maxTemp)
        
        weekDay.text = "ПН"
        icon.image = UIImage(systemName: "sun.max")
        icon.tintColor = .yellow
        minTemp.text = "25˚"
        maxTemp.text = "37˚"
        
    }
    
//    func fetchWeatherData(with city: City) {
//        networkManager.fetchTimezoneData(for: city) { city in
//            DispatchQueue.main.async {
//                if let temperature = self.networkManager.temperature {
//                    self.temperature.text = "\(temperature)˚"
//                }
//                if let description = self.networkManager.description {
//                    self.skyStatus.text = "\(description)"
//                }
//                if let minTemp = self.networkManager.dailyMinTemp, let maxTemp = self.networkManager.dailyMaxTemp {
//                    self.tempLimits.text = "Max.: \(maxTemp)˚, min.:\(minTemp)˚"
//                }
//            }
//        }
  //  }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        weekDay.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(10)
            $0.width.greaterThanOrEqualTo(150)
        }
        icon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(weekDay.snp.right).offset(10)
        }
        minTemp.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(icon.snp.right).offset(10)
        }
        maxTemp.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(10)
        }
    }
}
