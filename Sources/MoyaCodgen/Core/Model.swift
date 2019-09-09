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
    let inPath: Bool?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        urlQuery = try container.decodeIfPresent(Bool.self, forKey: .urlQuery)
        inPath = try container.decodeIfPresent(Bool.self, forKey: .inPath)
        
        let type = try container.decode(String.self, forKey: .type)
        self.type = type.lowercased().capitalized
    }
}

class MCodgenAPIModel: Codable {
    let name: String
    let method: String
    let path: String
    let parameters: [MCodgenParameterModel]?
    
    // Custom attributes
    let pathParameters: [MCodgenParameterModel]?
    let queryParameters: [MCodgenParameterModel]?
    let bodyParameters: [MCodgenParameterModel]?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        method = try container.decode(String.self, forKey: .method)
        path = try container.decode(String.self, forKey: .path)
        parameters = try container.decodeIfPresent([MCodgenParameterModel].self, forKey: .parameters)
        
        pathParameters = parameters?.filter{ $0.inPath == true }
        queryParameters = parameters?.filter{ $0.urlQuery == true }
        bodyParameters = parameters?.filter{ $0.urlQuery == false }
    }
}

class MCodgenAttributeModel: Codable {
    let name: String
    let type: String
    let optional: Bool?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        optional = try container.decodeIfPresent(Bool.self, forKey: .optional)
        let type = try container.decode(String.self, forKey: .type)
        self.type = type.lowercased().capitalized
    }
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
