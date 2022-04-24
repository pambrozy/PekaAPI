//
//  Model.swift
//  PekaAPI
//
//  Created by Przemysław Ambroży on 09.03.2022.
//  Copyright © 2022 Przemysław Ambroży
//

import Foundation

// MARK: Stop points

struct StopPointSuccess: Codable {
    let success: [StopPoint]
}

public struct StopPoint: Codable {
    public let symbol, name: String
}

// MARK: Bollards and directions

struct BollardSuccess: Codable {
    let success: BollardSuccessBollards
}

struct BollardSuccessBollards: Codable {
    let bollards: [BollardDirections]
}

public struct BollardDirections: Codable {
    public let directions: [Direction]
    public let bollard: BollardBollard
}

public struct BollardBollard: Hashable, Codable {
    public let symbol, tag, name: String
}

public struct Direction: Codable {
    public let returnVariant: Bool
    public let direction, lineName: String
}

// MARK: Lines

struct LineSuccess: Codable {
    let success: [Line]
}

public struct Line: Codable {
    public let name: String
}

// MARK: Streets

public struct StreetSuccess: Codable {
    public let success: [Street]
}

public struct Street: Codable {
    public let id: Int
    public let name: String
}

// MARK: Times

struct TimesSuccess: Codable {
    let success: BollardWithTimes
}

public struct BollardWithTimes: Hashable, Codable {
    public let bollard: BollardBollard
    public let times: [Time]
}

public struct Time: Hashable, Codable {
    public let minutes: Int
    public let charger, lowFloorBus: Bool?
    public let direction: String
    public let onStopPoint: Bool
    public let line, departure: String
    public let realTime: Bool
    public let airCnd, lfRamp, lowEntranceBus, ticketMachine, bike, leRamp: Bool?
}

struct TimesForAllBollardsSuccess: Codable {
    let success: TimesForAllBollards
}

public struct TimesForAllBollards: Codable {
    public let bollardsWithTimes: [BollardWithTimes]
}
