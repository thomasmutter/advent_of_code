//
//  16.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 16/12/2021.
//  Copyright © 2021 thomas. All rights reserved.
//

import Foundation

let bitsPacketDecoder = BitsPacketDecoder()

struct BitsPacketDecoder {
    func hexToBinaryString(hex: String) -> String {
        hex.map { String($0.hexDigitValue!, radix: 2) }.map {
            if $0.count < 4 {
                return String(repeating: "0", count: 4 - $0.count) + $0
            } else {
                return $0
            }
        }.joined()
    }
    
    func sumVersionNumbers(for packet: Packet) -> Int {
        if let literal = packet as? LiteralPacket {
            return literal.version
        } else if let operatorPacket = packet as? OperatorPacket {
            var sum = operatorPacket.version
            for packet in operatorPacket.subpackets {
                sum += sumVersionNumbers(for: packet)
            }
            return sum
        }
        return 0
    }
        
    func buildPacketHierarchy(for data: String) -> Packet {
        let (version, type) = readVersionAndType(binaryString: data)
        if type == 4 {
            let (value, bitSize) = decodeLiteralPacket(binaryString: data)
            return LiteralPacket(version: version, value: value, bitSize: bitSize)
        } else {
            let operation = OperatorPacket.getOperation(for: type)
            if Int(charAt(word: data, at: 6))! == 0 {
                let totalLength = Int(data.substring(from: 7, to: 22), radix: 2)!
                let packets = findPackets(withTotalLength: totalLength, data: data.substring(from: 22, to: data.count))
                return OperatorPacket(version: version, bitSize: 7 + 15 + packets.map { $0.bitSize }.reduce(0, +), subpackets: packets, operation: operation)
            } else {
                let numberOfPackets = Int(data.substring(from: 7, to: 18), radix: 2)!
                let packets = findPackets(amount: numberOfPackets, data: data.substring(from: 18, to: data.count))
                return OperatorPacket(version: version, bitSize: 7 + 11 + packets.map { $0.bitSize }.reduce(0, +), subpackets: packets, operation: operation)
            }
        }
    }
    
    private func readVersionAndType(binaryString: String) -> (version: Int, type: Int) {
        let version = Int(binaryString.substring(from: 0, to: 3), radix: 2)!
        let type = Int(binaryString.substring(from: 3, to: 6), radix: 2)!
        return (version, type)
    }
    
    private func findPackets(withTotalLength totalLength: Int, data: String) -> [Packet] {
        var bitsHandled = 0
        var packets = [Packet]()
        while bitsHandled < totalLength {
            let packet = buildPacketHierarchy(for: data.substring(from: bitsHandled, to: data.count))
            bitsHandled += packet.bitSize
            packets.append(packet)
        }

        return packets
    }

    private func findPackets(amount: Int, data: String) -> [Packet] {
        var bitsHandled = 0
        var packets = [Packet]()
        while packets.count < amount {
            let packet = buildPacketHierarchy(for: data.substring(from: bitsHandled, to: data.count))
            bitsHandled += packet.bitSize
            packets.append(packet)
        }

        return packets
    }
    
    private func decodeLiteralPacket(binaryString: String) -> (value: Int, bitSize: Int) {
        var result = ""
        let data = binaryString.substring(from: 6, to: binaryString.count)
        var groupMarkerIndex = 0
        while Int(charAt(word: data, at: groupMarkerIndex))! != 0 {
            result += data.substring(from: groupMarkerIndex + 1, to: groupMarkerIndex + 5)
            groupMarkerIndex += 5
        }
        result += data.substring(from: groupMarkerIndex + 1, to: groupMarkerIndex + 5)
        let (value, bitSize) = (Int(result, radix: 2)!, result.count + 6 + result.count / 4)
        return (value, bitSize)
    }
    
    struct LiteralPacket: Packet {
        let version: Int
        private let value: Int
        let bitSize: Int
        
        init(version: Int, value: Int, bitSize: Int) {
            self.version = version
            self.value = value
            self.bitSize = bitSize
        }
        
        func computeValue() -> Int {
            value
        }
    }
    
    struct OperatorPacket: Packet {
        let version: Int
        var bitSize: Int
        let subpackets: [Packet]
        private let operation: ([Packet]) -> Int
        
        init(version: Int, bitSize: Int, subpackets: [Packet], operation: @escaping ([Packet]) -> Int) {
            self.version = version
            self.bitSize = bitSize
            self.subpackets = subpackets
            self.operation = operation
        }
        
        func computeValue() -> Int {
            operation(subpackets)
        }
        
        static func getOperation(for type: Int) -> (([Packet]) -> Int) {
            switch type {
            case 0:
                return { packets in packets.map { $0.computeValue() }.reduce(0, +) }
            case 1:
                return { packets in packets.map { $0.computeValue() }.reduce(1, *) }
            case 2:
                return { packets in packets.map { $0.computeValue() }.min()! }
            case 3:
                return { packets in packets.map { $0.computeValue() }.max()! }
            case 5:
                return { packets in packets[0].computeValue() > packets[1].computeValue() ? 1 : 0 }
            case 6:
                return { packets in packets[0].computeValue() < packets[1].computeValue() ? 1 : 0 }
            case 7:
                return { packets in packets[0].computeValue() == packets[1].computeValue() ? 1 : 0 }
            default:
                fatalError("Invalid type ID")
            }
        }
    }
}

protocol Packet {
    var version: Int { get }
    var bitSize: Int { get }
    
    func computeValue() -> Int
}
