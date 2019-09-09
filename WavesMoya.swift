import Foundation
import Moya

enum WavesRPC {
    case balance(String, String)

    case transaction(String)

    case broadcast(Data)

    case nodeInfo
}

extension WavesRPC: TargetType {
    var baseURL: URL {
        return URL(string: "https://waves-url.com")!
    }

    var path: String {
        switch self {
        case let .balance(address, test):
            return "/addresses/balance/\(address)/0"

        case let .transaction(hash):
            return "/transactions/info/\(hash)"

        case let .broadcast(data):
            return "/transactions/broadcast"

        case .nodeInfo:
            return "/node/status"
        }
    }

    var method: Moya.Method {
        switch self {
        case .balance:
            return .get

        case .transaction:
            return .get

        case .broadcast:
            return .post

        case .nodeInfo:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case let .balance(address, test):

            let dict = ["test": test]
            return .requestParameters(parameters: dict, encoding: URLEncoding.queryString)

        case let .transaction(hash):

            return .requestPlain

        case let .broadcast(data):

            let dict = ["data": data]
            return .requestParameters(parameters: dict, encoding: JSONEncoding.default)

        case .nodeInfo:

            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return [
            "content-type": "application/json",
        ]
    }
}
