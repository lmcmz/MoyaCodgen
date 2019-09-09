import Foundation
import Moya

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
        
        case .balance(let address):
            
                
                    return .requestPlain
                
            
        
        }
    }

    var headers: [String: String]? {
        return [
            "content-type": "application/json",
        ]
    }
}
