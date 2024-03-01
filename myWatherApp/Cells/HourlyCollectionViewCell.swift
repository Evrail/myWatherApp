import UIKit
import Then
import SnapKit

//MARK: - Ячейка в карусели

class HourlyCollectionViewCell: UICollectionViewCell {
    
    // идентификатор класса
    static let identifier = "HourlyCollectionViewCell"
    
    // синглтон обращения к сетевому менеджеру
    private var networkManager = NetworkManager(with: .default)
    
    var city: City?

    // задаем визуальные представления ячейки
    private var hourLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textColor = .white
    }
    
    private let iconImageView = UIImageView()
    
    private let temperatureLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .white
    }
    
    //переменная работы своего сетевого менеджера
    
    // инициализатор, который добавляет визуальные представления на ячейку
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(hourLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(temperatureLabel)
        
        backgroundColor = .systemCyan
    }
    
    // базовый метод нужен если вдруг мы захотим использовать Xib для настройки представления
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Настройка Лэйаутов ячейки
    override func layoutSubviews() {
        super.layoutSubviews()
        
        hourLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(10)
        }
        
        iconImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.greaterThanOrEqualTo(25)
            $0.height.greaterThanOrEqualTo(25)
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(3)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
    // конфигуратор задающий данные визуальным представлениям - нужно вызвать в инициализаторе
    func configure() {
        backgroundColor = .systemCyan
        iconImageView.image = UIImage(systemName: "moon.stars")
        iconImageView.tintColor = .white
        self.hourLabel.text = "19"
        self.temperatureLabel.text = "-0"
        
//        self.hourLabel.text = "\(unixToTimeOnly(TimeInterval(Int(hourly.time ?? 0))))"
//        self.temperatureLabel.text = "\(Int(hourly.temp ?? 0))"

    }
    
}
