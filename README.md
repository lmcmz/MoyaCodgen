# MoyaCodgen

## How to run
1. Install denpencies, 
```
swift package update
swift package generate-xcodeproj
open MoyaCodgen.xcodeproj
```

2. To run this project, you need move `blockchain.json` and `*.template` to project document folder, which will show up if the file isn't find.

3.. The generate file will be the folder as well, check `*.swift` file


## TODO

- [ ] Remove manual operation 
- [ ] Cocaopod support
- [ ] More Moya medthod support
- [ ] Format generate code
- [ ] Avoid override file

## Example

**Input**
```json
{
    "name": "Waves",
    "baseURL": "https://waves-url.com",
    "interfaces": [
        {
            "name": "balance",
            "method": "get",
            "path": "/addresses/balance/\\(address)/0",
            "parameters": [
                {
                    "name": "address",
                    "type": "String",
                    "inPath": true
                }
            ]
        }
      ],
      "models": [
        {
            "name": "WavesBalance",
            "attributes": [
                {
                    "name": "balance",
                    "type": "Int64"
                }
            ]
        }
      ]
  }
```

**Output**
- WavesMoya.swift
```swift

enum WavesRPC {
    case balance(String)
}

extension WavesRPC: TargetType {
    var baseURL: URL {
        return URL(string:"https://waves-url.com")!
    }

    var path: String {
        switch self {
        case .balance(let address):
            return "/addresses/balance/\(address)/0"
        }
    }

    var method: Moya.Method {
        switch self {
        case .balance:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .balance(_):
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return [
            "content-type": "application/json",
        ]
    }
}
```

- WavesModel.swift
```swift
import Foundation

struct WavesBalance: Codable {
    let balance: Int64
}
```

