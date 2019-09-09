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
    
    func generate(input: URL, output: URL) throws {
        
        var data: Data
        do {
            data = try Data(contentsOf: input)
        } catch {
            print("You might need to place json file under: \(FileManager.default.currentDirectoryPath)")
            throw MCError.jsonNotFound
        }
        
        do {
            let res = try JSONDecoder().decode(MCodgenModel.self, from: data)
            
            let environment = Environment(loader: FileSystemLoader(paths: [Path("\(FileManager.default.currentDirectoryPath)/Example/template")]))
            
            print("CCCC")
            print(environment)
            
            let modelRender = try environment.renderTemplate(name: "model_template.stencil", context: res.dictionary)
            let moyaRender = try environment.renderTemplate(name: "moya_template.stencil", context: res.dictionary)
            
            print("DDDD")
            
            let modelPath = URL(fileURLWithPath: "\(res.name.capitalized)Model.swift")
            try writeIfChanged(contents: modelRender, toURL:  modelPath)
            try writeIfChanged(contents: moyaRender, toURL: URL(fileURLWithPath: "\(res.name.capitalized)Moya.swift"))
            
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
