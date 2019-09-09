//
//  Model.swift
//  MoyaCodgen
//
//  Created by lmcmz on 7/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

class MCodgenParameterModel: Codable {
    let name: String
    let type: String
    let urlQuery: Bool?
}

class MCodgenAPIModel: Codable {
    let name: String
    let method: String
    let path: String
    let parameters: [MCodgenParameterModel]?
}

class MCodgenAttributeModel: Codable {
    let name: String
    let type: String
    let optional: Bool?
}

class MCodgenSubModel: Codable {
    let name: String
    let attributes: [MCodgenAttributeModel]?
}

class MCodgenModel: Codable {
    let name: String
    let baseURL: String
    let interfaces: [MCodgenAPIModel]?
    let models: [MCodgenSubModel]?
}
