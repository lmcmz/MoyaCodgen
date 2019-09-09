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
    
    func generate(input: URL, output: URL, template: URL) throws {
        
        var data: Data
        do {
            data = try Data(contentsOf: input)
        } catch {
            print("You might need to place json file under: \(FileManager.default.currentDirectoryPath)")
            throw MCError.jsonNotFound
        }
        
        do {
            let interfaces = try JSONDecoder().decode([MCodgenModel].self, from: data)
            
            let environment = Environment(loader: FileSystemLoader(paths: [Path(template.absoluteString.replacingOccurrences(of: "file://", with: ""))]))
            
            var context = ""
            
            for (index, interface) in interfaces.enumerated() {
                var dict = interface.dictionary
                dict["addHeader"] = index == 0
                let moyaRender = try environment.renderTemplate(name: "moya_template.stencil", context: dict)
                dict["addHeader"] = false
                let modelRender = try environment.renderTemplate(name: "model_template.stencil", context: dict)
                context.append("\(moyaRender)\(modelRender)")
                context.append("/* -------------------------- */\n")
                context.append("// MARK: - \(interface.name)")
                context.append("/* -------------------------- */\n")
            }
            
            // Generate in single file
            try writeIfChanged(contents: context, toURL: output)
            
            // Generate in split file
            //            let modelPath = URL(fileURLWithPath: "\(res.name.capitalized)Model.swift")
            //            try writeIfChanged(contents: modelRender, toURL:  modelPath)
            //            let moyaPath = URL(fileURLWithPath: "\(res.name.capitalized)Moya.swift")
            //            try writeIfChanged(contents: moyaRender, toURL: )
            
            // TODO Format code
//            shell("swiftformat", "./\(res.name.capitalized)Model.swift")
            print("Code generate complete, under the path: \(output.absoluteString)")
            
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
