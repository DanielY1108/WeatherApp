//
//  Bundle.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/14.
//

import Foundation

extension Bundle {
    
    var apiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "SecretKey", ofType: "plist") else {
                fatalError("Couldn't find file 'SecretKey.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "API_KEY") as? String else {
                fatalError("Couldn't find key 'API_Key' in 'SecretKey.plist'.")
            }
            return value
        }
    }
    
    func readTxtFile(_ name: String) -> String? {
        // [텍스트 파일 내용을 저장할 변수]
        var result = ""
        // [저장된 텍스트 파일 경로 지정 실시]
        let paths = Bundle.main.path(forResource: "\(name)", ofType: nil)
        guard paths != nil else { return nil }
        // [텍스트 파일 내용 확인 실시]
        do {
            result = try String(contentsOfFile: paths!, encoding: .utf8)
        }
        catch let error as NSError {
            return error.localizedDescription
        }
        return result
    }
}
