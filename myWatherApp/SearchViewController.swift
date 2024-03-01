// SearchViewController.swift

import UIKit
import Then
import SnapKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITextFieldDelegate {
    
    // в эту переменную добавляются отфильтрованные города для отображения во время фильтрации
    private var filteredCities = [City]()
    
    // эта переменная подтягивает выбранные города с главного экрана
    var choosenCities = HomeViewController().chosenCities
    // проверяет пустое ли окно поиска для того чтоб отображать или не отображать список городов
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    //возвращает "истина" если поисковое окно активировано и не пустое
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    //задаем поисковый Контроллер и для отображения результатов используем этот же контроллер
   public let searchController = UISearchController(searchResultsController: nil)

    //табличное представление списка городов
    private let tableView = UITableView().then {
        $0.backgroundColor = .black
        $0.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        $0.separatorColor = UIColor.darkGray
    }

    // конфигуратор как самого представления, так и поискового контроллера с настройкой встроенного текста и прочих атрибутов
    func configure() {
        view.backgroundColor = .black
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск города"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = false
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.textColor = .white
        
        if let searchTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
                searchTextField.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1)
    
        if let placeholderLabel = searchTextField.value(forKey: "placeholderLabel") as? UILabel {
            let placeholderText = "Поиск города"
            let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
                    placeholderLabel.attributedText = attributedPlaceholder
        }
    
        if let leftView = searchTextField.leftView as? UIImageView {
            leftView.tintColor = UIColor.lightGray
        }
        if let clearButton = searchTextField.value(forKey: "clearButton") as? UIButton {
            clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
            clearButton.tintColor = UIColor.lightGray
        }
        searchTextField.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        configure()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    //настройка Лэйаутов 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalToSuperview().inset(150)
        }
    }
}

// MARK: - Делегаты и Источники данных для этого ВьюКонтроллера
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    // возвращает на экран количество отфильтрованных городов, если поиск активирован (isFiltering = True), или показывает все города списком
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCities.count
        }
        return allCities.count
    }

    //настройка ячейки поискового города (если поиск активирован, то проходимся по коллекции фильтрованных городов и выводим их на экран, если поиск не активен или пуст, то показываем все города)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell else {
            fatalError("Unable to dequeue SearchCell")
        }
        var city: City
        if isFiltering {
            city = filteredCities[indexPath.row]
        } else {
            city = allCities[indexPath.row]
        }
        cell.cityName.text = city.cityName
        //cell.configure(with: city)
        cell.configure()

        return cell
    }

    //высота ячейки равна 50
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //если ячейка с городом выбирается, то в коллекцию выбранных городов choosenCities, добавляется выбранный город, сохраняется в долгую память Realm и экран автоматически выходит из режима поиска на главный ВьюКонтроллер.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedCity: City

        //проверка if нужна для того, чтобы корректно добавлять город в память согласно его актуальному порядковуму номеру иначе везде будет тянуться порядковый номер из allCities и будет несовпадение выранного и отображаемого в итоге города
        if isFiltering {
            selectedCity = filteredCities[indexPath.row]
        } else {
            selectedCity = allCities[indexPath.row]
        }
        choosenCities.append(selectedCity)
        RealmManager.shared.saveCities([selectedCity])
        navigationController?.popViewController(animated: true)
    }
}

// расширение в реальном времени отображает отфильтрованные города в зависимости от того, какие буквы указываются в окно поиска
extension SearchViewController:  UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredCities = allCities.filter { $0.cityName.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }
    
}

// MARK: - класс настройки ячейки для отображения коллекции городов
class SearchCell: UITableViewCell {

    //идентификатор класса
    static let identifier = "SearchCell"

    // визуальные данные "название города" в ячейке
    let cityName = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .regular)
        $0.textColor = .white
    }

    //конфигуратор с добавлением настрек на экран
    //public func configure(with city: City) {
        public func configure() {
        contentView.backgroundColor = .black
        contentView.addSubview(cityName)
    }

    // настройки Лэйаутов ячейки
    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20

        cityName.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview().inset(5)
        }
    }
}
