import Foundation

struct WavesBalance: Codable {
    let balance: Int64
}

struct WavesSentTransaction: Codable {
    let id: String
}

struct WavesRPCError: Codable {
    let error: Int?

    let message: String
}

struct WavesTransactionInfo: Codable {
    let height: Int64
}
