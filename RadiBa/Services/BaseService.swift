//
//  BaseService.swift
//  RadiBa
//
//  Created by Dino Pelic on 5/11/18.
//  Copyright © 2018 Ant Colony. All rights reserved.
//

import Foundation
import ObjectMapper

protocol ServiceOutput {
    func resultForCall(object: [String: AnyObject]?, error: Error?)
}

class BaseService {
    
    var isJSONApi: Bool = true
    
    func getFromLocalJson(jsonPath: String) -> [String: AnyObject]? {
        if let path = Bundle.main.path(forResource: jsonPath, ofType: "json") {
            let jsonData = try! NSData(contentsOfFile: path, options: .mappedIfSafe)
            let jsonResult: NSDictionary = try! JSONSerialization.jsonObject(with: jsonData as Data, options: .mutableContainers) as! NSDictionary
            return jsonResult as? [String: AnyObject]
        }
        return nil
    }
}
