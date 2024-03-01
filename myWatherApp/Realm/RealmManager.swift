//
//  RealmManager.swift
//  myWatherApp
//
//  Created by Yegor Podduba on 06/02/2024.
//


import Foundation
import RealmSwift

// MARK: - класс для сохранения данных в долгую память
class RealmManager {
    
    //синглтон для обращения к классу
    static let shared = RealmManager()

    // ячейка долгой памяти
    private let realm: Realm

    // инициализатор с попыткой инициализации ячейки для хранения долгой памяти или ошибкой, если вдруг это невозможно
    private init() {
        do {
            self.realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }

    // сохраняет данные в долгую память Realm
    func saveCities(_ cities: [City]) {
        do {
            try realm.write {
                for city in cities {
                    let cityObject = CityObject()
                    cityObject.cityName = city.cityName
                    cityObject.latitude = city.LATitude
                    cityObject.longitude = city.LONgitude
                    realm.add(cityObject)
                }
            }
        } catch {
            print("Failed to save cities to Realm: \(error)")
        }
    }

    // выгружает данные из долгой памяти Realm в коллекцию cities, которая потом сопрягается с структурой City
    func loadCities() -> [City] {
        let cityObjects = realm.objects(CityObject.self)
        var cities: [City] = []
        for cityObject in cityObjects {
            let city = City(cityName: cityObject.cityName, LATitude: cityObject.latitude, LONgitude: cityObject.longitude)
            cities.append(city)
        }
        return cities
    }

    // удаляет конкретный город из долгой памяти Realm (необходима для редактирования главного экрана)
    func deleteCity(_ city: City) {
        let predicate = NSPredicate(format: "cityName == %@", city.cityName)
        if let cityObject = realm.objects(CityObject.self).filter(predicate).first {
            do {
                try realm.write {
                    realm.delete(cityObject)
                }
            } catch {
                print("Failed to delete city from Realm: \(error)")
            }
        }
    }

    // функция позволяет полностью отчистить долгую память Realm
    func clearAllData() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("Failed to clear all data from Realm: \(error)")
        }
    }
}

// MARK: - класс сохраняемых данных (все данные имеют расширение под Objective-C - @objc), соответствует струкутре City для их взаимодействия
class CityObject: Object {
    @objc dynamic var cityName: String = ""
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
}
