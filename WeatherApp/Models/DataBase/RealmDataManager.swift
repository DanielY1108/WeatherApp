//
//  RealmManager.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/23.
//

import UIKit
import RealmSwift
import CoreLocation

protocol RealmData {
    func read<T: Object>(_ object: T.Type) -> Results<T>
    func write<T: Object>(_ object: T)
    func delete<T: Object>(_ object: T)
}

final class RealmManager: RealmData {
    
    static let shared = RealmManager()
    
    private let realmData: Realm
    
    private init() {
        self.realmData = try! Realm()
    }
    func writeDefualtLocation(_ location: CLLocationCoordinate2D, mainLoad: Bool) {
        let defaultModel = RealmDataModel()
        defaultModel.lat = location.latitude
        defaultModel.lon = location.longitude
        defaultModel.city = "Current Location"
        defaultModel.loadMain = mainLoad
        self.write(defaultModel)
    }
    func writeLocation(_ location: CLLocationCoordinate2D, cityName: String, mainLoad: Bool) {
        let dataModel = RealmDataModel()
        dataModel.lat = location.latitude
        dataModel.lon = location.longitude
        dataModel.city = cityName
        dataModel.loadMain = mainLoad
        self.write(dataModel)
    }
    func checkLoadMainView(display model: RealmDataModel) {
        let models = read(RealmDataModel.self)
        models.forEach { model in
            self.update(model) { model in
                model.loadMain = false
            }
        }
        self.update(model) { model in
            model.loadMain = true
        }
    }
    
    func getLocationOfDefaultRealm() {
        print("Realm is located at:", realmData.configuration.fileURL!)
    }
    
    func read<T: Object>(_ object: T.Type) -> Results<T> {
        return realmData.objects(object)
    }
    
    func write<T: Object>(_ object: T) {
        do {
            try realmData.write {
                realmData.add(object)
                print("Added New Item")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func update<T: Object>(_ object: T, completion: @escaping ((T) -> ())) {
        do {
            try realmData.write {
                completion(object)
            }
            
        } catch let error {
            print(error)
        }
    }
    
    func delete<T: Object>(_ object: T) {
        do {
            try realmData.write {
                realmData.delete(object)
                print("Delete Success")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}


