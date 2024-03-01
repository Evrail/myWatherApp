import UIKit
import Then
import SnapKit

class SearchTableView: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Раскомментируйте следующую строку для сохранения выбора между представлениями
        // self.clearsSelectionOnViewWillAppear = false

        // Раскомментируйте следующую строку, чтобы отобразить кнопку редактирования в панели навигации для этого контроллера представления.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Настройте ограничения, если необходимо
    }

    // MARK: - Источник данных таблицы

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Неполная реализация, вернуть количество секций
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Неполная реализация, вернуть количество строк
        return Cities.allCities().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell else {
            fatalError()
        }

        cell.configure()

        return cell
    }
/*
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Создайте новый экземпляр соответствующего класса, вставьте его в массив и добавьте новую строку в таблицу
        }
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        // Реализуйте перемещение строки в таблице
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
*/
    /*
    // MARK: - Навигация

    // В приложении, созданном на основе интерфейса, вы часто захотите выполнить некоторую подготовку перед переходом.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Получите новый контроллер представления, используя segue.destination.
        // Передайте выбранный объект новому контроллеру представления.
    }
    */

}

