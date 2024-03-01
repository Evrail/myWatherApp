import UIKit
import Then
import SnapKit

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    
    // кнопка поиска на главном экране
    private var searchButton: UIBarButtonItem!
    
    //коллекция, куда сохраняются выбранные города, для последующего переноса в память или обображения на главном экране
    var chosenCities: [City] = []
    
    //табличное представление главного экрана выбранных городов
    let tableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.backgroundColor = .black
        $0.separatorColor = .clear
        $0.register(CityWeatherCell.self, forCellReuseIdentifier: CityWeatherCell.identifier)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCities()
        view.addSubview(tableView)
        setupNavBar()
    
        tableView.dataSource = self
        tableView.delegate = self
        
       //RealmManager.shared.clearAllData()
        
        
    }
    
    // функция Realm выгружающая таблицу из долгой памяти при загрузке приложения
    func loadCities() {
        if !RealmManager.shared.loadCities().isEmpty {
            for town in RealmManager.shared.loadCities() {
                chosenCities.append(town)
            }
        }
    }
    
    // функция Realm, если город был выбран в окне поиска, сразу сохранить его в долгую память
    func didSelectCity(_ city: City) {
            // Сохранение данных в Realm при выборе города
            RealmManager.shared.saveCities([city])
        }
    
    
    // функция настройки навигационного бара (кнопка поиска, надпись "Погода")
    private func setupNavBar() {
        searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonЕapped))
        searchButton.tintColor = .cyan
        
        navigationItem.rightBarButtonItem = searchButton
        definesPresentationContext = false
        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Погода"
    }
    
    // функция активации кнопки поиска "лупа"
    @objc func searchButtonЕapped() {
        navigationController?.pushViewController(SearchViewController(), animated: true)

    }
    
    // Перегружаем эту функцию чтобы при каждом возвращении к главному экрану в нем подгружались выбранные города
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        chosenCities = RealmManager.shared.loadCities()
           tableView.reloadData()
       }
    
    // настройка Лэйаутов вида
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(150)
            $0.left.bottom.right.equalToSuperview()
        }
    }
}

// MARK: - Делегаты и Источники данных для этого ВьюКонтроллера
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    
    // возвращает количество секций, согласно количеству элементов коллекции chosenCities
    func numberOfSections(in tableView: UITableView) -> Int {
        return chosenCities.count
    }
    // в каждой секции только по одной ячейке (используем секции вместо ячеек чтобы были отступы между городами)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    // настройки ячейки: указываем, что переменная "Город" - это один из городов из коллекции chosenCities и передаем ее в конфигуратор самой ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityWeatherCell.identifier, for: indexPath) as? CityWeatherCell else {
            fatalError("Unable to dequeue CityWeatherCell")
        }
        let city = chosenCities[indexPath.section]
        cell.configure(with: city)
        
        return cell
    }
    
    // Задаем высоту ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    // Осуществляем переход к развернутому меню погоды Города при нажатии на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = chosenCities[indexPath.section] // говорим, что selectedCity это город из секции
        let cityViewController = CityViewController()
        cityViewController.city  = selectedCity // даем значение переменной city внутри CityViewController равной выбранному городу
        
        // let hourlyCollectionViewCell = HourlyCollectionViewCell()
       // hourlyCollectionViewCell.city = selectedCity
      
        navigationController?.pushViewController(cityViewController, animated: true) // переход на новый вью контроллер
    }
}

//MARK: - Настройки Хэдэра и Футера для уменьшения расстояния между секциями-ячейками
extension HomeViewController {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
}
