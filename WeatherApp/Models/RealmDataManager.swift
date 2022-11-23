//
//  RealmManager.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/23.
//

import UIKit
import RealmSwift

protocol RealmData {
    func read<T: Object>(_ object: T.Type) -> Results<T>
    func write<T: Object>(_ object: T)
    func delete<T: Object>(_ object: T)
}

final class RealmDataManager: RealmData {
    
    static let shared = RealmDataManager()
    
    private let realmData: Realm
    
    private init() {
        self.realmData = try! Realm()
    }
    
    func getLocationOfDefaultRealm() {
         print("Realm is located at:", realmData.configuration.fileURL!)
     }
    
    func read<T: Object>(_ object: T.Type) -> Results<T>  {
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



