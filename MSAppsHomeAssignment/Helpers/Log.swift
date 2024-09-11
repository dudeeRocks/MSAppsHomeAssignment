// Abstract: Object to manager logs and performance measurement.

import os

class Log {
    
    static let main = Log()
    
    private let logger: Logger
    private let signposter: OSSignposter
    
    private init() {
        logger = Logger(subsystem: "MSAppsNotes", category: "PointsOfInterest")
        signposter = OSSignposter(logger: logger)
    }
    
    func log(message: String) {
        logger.log("\(message)")
    }
    
    func log(error: String) {
        logger.error("\(error)")
    }
    
    func beginInterval(_ name: StaticString, id: OSSignpostID) -> OSSignpostIntervalState {
        return signposter.beginInterval(name, id: id)
    }
    
    func endInterval(_ name: StaticString, _ state: OSSignpostIntervalState) {
        signposter.endInterval(name, state)
    }
    
    func makeSignpostID() -> OSSignpostID {
        return signposter.makeSignpostID()
    }
}
