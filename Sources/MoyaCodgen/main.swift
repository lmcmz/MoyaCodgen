import Foundation
import Stencil
import PathKit
import XcodeEdit
import Commander

// Default values for non-optional Commander Options
struct EnvironmentKeys {
    static let bundleIdentifier = "PRODUCT_BUNDLE_IDENTIFIER"
    static let productModuleName = "PRODUCT_MODULE_NAME"
    static let scriptInputFileCount = "SCRIPT_INPUT_FILE_COUNT"
    static let scriptOutputFileCount = "SCRIPT_OUTPUT_FILE_COUNT"
    static let target = "TARGET_NAME"
    static let tempDir = "TEMP_DIR"
    static let xcodeproj = "PROJECT_FILE_PATH"
    static let buildProductsDir = SourceTreeFolder.buildProductsDir.rawValue
    static let developerDir = SourceTreeFolder.developerDir.rawValue
    static let platformDir = SourceTreeFolder.platformDir.rawValue
    static let sdkRoot = SourceTreeFolder.sdkRoot.rawValue
    static let sourceRoot = SourceTreeFolder.sourceRoot.rawValue
    
    static func scriptInputFile(number: Int) -> String {
        return "SCRIPT_INPUT_FILE_\(number)"
    }
    
    static func scriptOutputFile(number: Int) -> String {
        return "SCRIPT_OUTPUT_FILE_\(number)"
    }
}

struct CommanderOptions {
    static let moyatemplate = Option("moyaTemplate",
                                 default: "moya.moyatemplate",
                                 description: "Using custom moya template to generate code")
    static let modeltemplate = Option("modelTemplate",
                                 default: "model.moyatemplate",
                                 description: "Using custom moya template to generate code")
}

// Options grouped in struct for readability
struct CommanderArguments {
    static let inputPath = Argument<String>("inputPath", description: "Input path for json file")
    static let outputPath = Argument<String>("outputPath", description: "Output path for the generated file")
}

struct Default {
    static let templatePath = "template"
}

let generate = command(
    CommanderArguments.inputPath,
    CommanderArguments.outputPath,
    CommanderOptions.moyatemplate,
    CommanderOptions.modeltemplate
) { inputPath, outputPath, moyatemplate, modeltemplate in
    
    let processInfo = ProcessInfo()
    
    // TODO Cache last run, if not change, avoid generate again
    
    let xcodeprojPath = try processInfo.environmentVariable(name: EnvironmentKeys.xcodeproj)
    let targetName = try processInfo.environmentVariable(name: EnvironmentKeys.target)
    let bundleIdentifier = try processInfo.environmentVariable(name: EnvironmentKeys.bundleIdentifier)
    let productModuleName = try processInfo.environmentVariable(name: EnvironmentKeys.productModuleName)
    let buildProductsDirPath = try processInfo.environmentVariable(name: EnvironmentKeys.buildProductsDir)
    let developerDirPath = try processInfo.environmentVariable(name: EnvironmentKeys.developerDir)
    let sourceRootPath = try processInfo.environmentVariable(name: EnvironmentKeys.sourceRoot)
    let sdkRootPath = try processInfo.environmentVariable(name: EnvironmentKeys.sdkRoot)
    let tempDir = try processInfo.environmentVariable(name: EnvironmentKeys.tempDir)
    let platformPath = try processInfo.environmentVariable(name: EnvironmentKeys.platformDir)
//
//    print(targetName)
//    print(productModuleName)
//    print(buildProductsDirPath)
//    print(sourceRootPath)
//    print(tempDir)
    
//    let scriptInputFileCountString = try processInfo.environmentVariable(name: EnvironmentKeys.scriptInputFileCount)
//    guard let scriptInputFileCount = Int(scriptInputFileCountString) else {
//        throw ArgumentError.invalidType(value: scriptInputFileCountString, type: "Int", argument: EnvironmentKeys.scriptInputFileCount)
//    }
//
//    let scriptInputFiles = try (0..<scriptInputFileCount)
//        .map(EnvironmentKeys.scriptInputFile)
//        .map(processInfo.environmentVariable)
//
//    let scriptOutputFileCountString = try processInfo.environmentVariable(name: EnvironmentKeys.scriptOutputFileCount)
//    guard let scriptOutputFileCount = Int(scriptOutputFileCountString) else {
//        throw ArgumentError.invalidType(value: scriptOutputFileCountString, type: "Int", argument: EnvironmentKeys.scriptOutputFileCount)
//    }
//    let scriptOutputFiles = try (0..<scriptOutputFileCount)
//        .map(EnvironmentKeys.scriptOutputFile)
//        .map(processInfo.environmentVariable)
 
    let inputURL = URL(fileURLWithPath: inputPath)
    let outputURL = URL(fileURLWithPath: outputPath)
    
    let templateURL = URL(fileURLWithPath: "\(sourceRootPath)/\(productModuleName)/\(Default.templatePath)")
    
    do {
        try MoyaCodgen().generate(input: inputURL, output: outputURL, template: templateURL)
    } catch {
        print(error.localizedDescription)
    }
    
}

// Start parsing the launch arguments
let group = Group()
group.addCommand("generate", "Generates Moya file", generate)
group.run()
