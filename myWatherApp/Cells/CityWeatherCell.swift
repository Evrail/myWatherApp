//
//  CityWeatherCell.swift
//  myWatherApp
//
//  Created by Yegor Podduba on 31/01/2024.
//

import UIKit
import Then
import SnapKit

//MARK: - Ячейка для HomeViewController
class CityWeatherCell: UITableViewCell {

  static let identifier = "CityWeatherCell"
    
    let networkManager: NetworkManager = NetworkManager(with: .default)
    
    
    let cityName = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .white
    }
    
    let time = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .white
    }
    
    let skyStatus = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .white
        $0.numberOfLines = 0
    }

    let temperature = UILabel().then {
        $0.font = .systemFont(ofSize: 40, weight: .bold)
        $0.textColor = .white
    }
    
    let tempLimits = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .white
    }
    
    public func configure(with city: City) {

        contentView.backgroundColor = .systemCyan
        contentView.addSubview(cityName)
        contentView.addSubview(time)
        contentView.addSubview(skyStatus)
        contentView.addSubview(temperature)
        contentView.addSubview(tempLimits)
        cityName.text = city.cityName
        fetchWeatherData(with: city)
    }
    
    func fetchWeatherData(with city: City) {
        networkManager.fetchTimezoneData(for: city) {city in
                // Обновите UI или выполните другие действия после получения данных
                DispatchQueue.main.async {
                    self.cityName.text = city.cityName
                    if let temperature = self.networkManager.temperature {
                        self.temperature.text = "\(temperature)˚"
                    }
                    if let dt = self.networkManager.dt {
                        self.time.text = "\(unixToTimeOnly(TimeInterval(dt)))"
                    }
                    if let description = self.networkManager.description {
                        self.skyStatus.text = "\(description)"
                    }
                    if let minTemp = self.networkManager.dailyMinTemp, let maxTemp = self.networkManager.dailyMaxTemp {
                        self.tempLimits.text = "Max.: \(maxTemp)˚, min.: \(minTemp)˚"
                    }
                }
            }
        }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20

        cityName.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(10)
        }
        time.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.top.equalTo(cityName.snp.bottom).offset(2)
        }
        skyStatus.snp.makeConstraints {
            $0.left.bottom.equalToSuperview().inset(10)
        }
        temperature.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(10)
        }
        tempLimits.snp.makeConstraints {
            $0.bottom.right.equalToSuperview().inset(10)
        }
    }
}

class WordlyCollectionViewCell: UITableViewCell {
    
    static let identifer = "WordlyCollectionViewCell"
    
    private let text = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .white
        $0.numberOfLines = 2
    }
    
    public func configureWordly() {
        contentView.backgroundColor = .systemCyan
        contentView.addSubview(text)
        text.text = "Солнечно до конца дня. Порывы ветра до 20 км/ч."
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        text.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(5)
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
        }
    }
}
