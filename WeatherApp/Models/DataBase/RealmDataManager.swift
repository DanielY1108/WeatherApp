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
    
    func writeLocation(_ location: CLLocationCoordinate2D, cityName: String) {
        let Weather = RealmDataModel()
        Weather.lat = location.latitude
        Weather.lon = location.longitude
        Weather.city = cityName
        Weather.mainLoad = false
        self.write(Weather)
    }
    
    func checkLoadMainView(_ models: Results<RealmDataModel>, display model: RealmDataModel) {
        models.forEach { model in
            self.update(model) { model in
                model.mainLoad = false
            }
        }
        self.update(model) { model in
            model.mainLoad = true
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



