//
//  MoyaCodgen.swift
//  MoyaCodgen
//
//  Created by lmcmz on 7/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//
import Foundation
import Stencil
import PathKit

open class MoyaCodgen: NSObject {
    
    func generate(input: String, output: String) throws {
        
        guard let jsonPath = Bundle.main.url(forResource: "blockchain", withExtension: "json") else {
            throw MCError.jsonNotFound
        }
        
        do {
            let data = try Data(contentsOf: jsonPath)
//            let jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            let res = try JSONDecoder().decode(MCodgenModel.self, from: data)
            
            let environment = Environment(loader: FileSystemLoader(bundle: [Bundle.main]))
            let modelRender = try environment.renderTemplate(name: "model_template.stencil", context: res.dictionary)
            let moyaRender = try environment.renderTemplate(name: "moya_template.stencil", context: res.dictionary)
            
            let modelPath = URL(fileURLWithPath: "\(res.name.capitalized)Model.swift")
            try writeIfChanged(contents: modelRender, toURL:  modelPath)
            try writeIfChanged(contents: moyaRender, toURL: URL(fileURLWithPath: "\(res.name.capitalized)moya.swift"))
            
            // TODO Format code
//            shell("swiftformat", "./\(res.name.capitalized)Model.swift")
            
            print("Code generate complete, under the path: \(URL(fileURLWithPath: "").absoluteString)")
        } catch {
            throw MCError.parseFail
        }
    }
    
    func writeIfChanged(contents: String, toURL outputURL: URL) throws {
        let currentFileContents = try? String(contentsOf: outputURL, encoding: .utf8)
        guard currentFileContents != contents else { return }
        do {
            try contents.write(to: outputURL, atomically: true, encoding: .utf8)
        } catch {
            throw MCError.writeFail
        }
    }

}
