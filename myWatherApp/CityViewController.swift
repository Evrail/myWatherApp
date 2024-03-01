//
//  CityViewController.swift
//  myWatherApp
//
//  Created by Yegor Podduba on 31/01/2024.
//

import UIKit
import Then
import SnapKit

// ВьюКонтроллер развернутого представления погоды города

class CityViewController: UIViewController {

    //мэнеджер работы с сетью для подгрузки данных из АПИ
    let networkManager: NetworkManager = NetworkManager(with: .default)
    
    var city: City? // значение этой переменной задается в функции didSelectRowAt в HomeViewController
    
    //Визуальные представления в верхней половине экрана (Название города, температура, погодные условия, лимиты температуры сегодня)
    private let cityName = UILabel().then {
        $0.font = .systemFont(ofSize: 40, weight: .regular)
        $0.textColor = .white
    }
    private let temperature = UILabel().then {
        $0.font = .systemFont(ofSize: 80, weight: .regular)
        $0.textColor = .white
    }
    
    private var skyStatus = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .regular)
        $0.textColor = .white
    }
    private let tempLimits = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .regular)
        $0.textColor = .white
    }

    //Табличное представление в нижней половине экрана: ячейка с текстовым описанием погоды, ячейка с горизонтальной каруселью, таблица с вертикальной таблицей и температурой на 10 дней
    private let tableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.backgroundColor = .clear
        $0.register(WordlyCollectionViewCell.self, forCellReuseIdentifier: WordlyCollectionViewCell.identifer)
        $0.register(HourlyTableViewCell.self, forCellReuseIdentifier: HourlyTableViewCell.identifier)
        $0.register(DailyTableViewCell.self, forCellReuseIdentifier: DailyTableViewCell.identifer)
        $0.separatorColor = UIColor.white
    }
    
     override func viewDidLoad() {
         
         super.viewDidLoad()
         configure(with: city!)
        
         tableView.delegate = self
         tableView.dataSource = self
         
     }

    // конфигруратор - сюда передается переменная из выбранного choosenCity согласно выбранной ячейки на главном экране
    func configure(with city: City) {
        view.backgroundColor = .systemBlue
        view.addSubview(cityName)
        view.addSubview(temperature)
        view.addSubview(skyStatus)
        view.addSubview(tempLimits)
        view.addSubview(tableView)
        fetchWeatherData(with: city)
    }
    
    // выдает данные из сети по выбранному городу - сюда передается переменная из выбранного choosenCity согласно выбранной ячейки на главном экране
    func fetchWeatherData(with city: City) {
        networkManager.fetchTimezoneData(for: city) { city in
            DispatchQueue.main.async { [self] in
                self.cityName.text = city.cityName
                if let temperature = self.networkManager.temperature {
                    self.temperature.text = "\(temperature)˚"
                }
                if let description = self.networkManager.description {
                    self.skyStatus.text = "\(description)"
                }
                if let minTemp = self.networkManager.dailyMinTemp, let maxTemp = self.networkManager.dailyMaxTemp {
                    self.tempLimits.text = "Max.: \(maxTemp)˚, min.:\(minTemp)˚"
                }
            }
        }
    }
   
    // Настройка всех Лэйаутов
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
       cityName.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(150)
        }
        temperature.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(15)
            $0.top.equalTo(cityName.snp.bottom).offset(10)
        }
        skyStatus.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(temperature.snp.bottom).offset(10)
        }
        tempLimits.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(skyStatus.snp.bottom).offset(10)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.snp.centerY)
            $0.left.right.bottom.equalToSuperview()
        }
        
    }

}

// MARK: - Делегаты и Источники данных для этого ВьюКонтроллера

extension CityViewController: UITableViewDelegate, UITableViewDataSource {
    
    // задаем две секции
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // задаем количество ячеек в секции, если секция первая (с номером 0), то две ячейки, если вторая, то 10 ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 10
        }
    }
    
    // настройка ячеек каждой секции
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //если секция №0 и ячейка №0, то используем конфигуратор текстового описания
        if indexPath.section == 0 && indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WordlyCollectionViewCell.identifer, for: indexPath) as? WordlyCollectionViewCell
            else { fatalError() }
            cell.configureWordly()

            return cell
        }
        
        // если секция №0, а ячейка №1, то используем горизонтальную карусель почасовой погоды
        if indexPath.section == 0 && indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as? HourlyTableViewCell
            else { fatalError() }
           // cell.configure()

            return cell
        }
        
        // Во всех остальных случаях просто добавляем стандартное табличное представление
        let cell = tableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.identifer, for: indexPath) as! DailyTableViewCell
        cell.configure() // сюда скорее всего тоже надо передать данные из Сити
        
        return cell
    }
    
    // задаем высоту ячеек: если это вторая ячейка первой секции, то высота = 100, во всех прочих случаях высота ячейки = 50
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 && indexPath.row == 1 ? 100 : 50
    }
    
}
