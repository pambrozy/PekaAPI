//
//  Model.swift
//  PekaAPI
//
//  Created by Przemysław Ambroży on 09.03.2022.
//  Copyright © 2022 Przemysław Ambroży
//

// MARK: Stop points

struct StopPointSuccess: Codable, Hashable, Sendable {
    let success: [StopPoint]
}

/// A named stop point, which may contain multiple ``BollardBollard``s.
public struct StopPoint: Codable, Hashable, Sendable {
    /// The identifier of the stop point.
    public let symbol: String

    /// The name of the stop point.
    public let name: String
}

// MARK: Bollards and directions

struct BollardSuccess: Codable, Hashable, Sendable {
    let success: BollardSuccessBollards
}

struct BollardSuccessBollards: Codable, Hashable, Sendable {
    let bollards: [BollardDirections]
}

/// A bollard with a list of directions coming out of it.
public struct BollardDirections: Codable, Hashable, Sendable {
    /// The list of directions coming out of a bollard.
    public let directions: [Direction]

    /// The bollard.
    public let bollard: BollardBollard
}

/// A single bollard.
public struct BollardBollard: Codable, Hashable, Sendable {
    /// The identifier of the bollard.
    public let symbol: String

    /// Alternative identifier of the bollard.
    public let tag: String

    /// The name of the bollard.
    public let name: String
}

/// The direction in which the traffic is moving.
public struct Direction: Codable, Hashable, Sendable {
    public let returnVariant: Bool

    /// The name of the direction.
    public let direction: String

    /// The name of the line.
    public let lineName: String
}

// MARK: Lines

struct LineSuccess: Codable, Hashable, Sendable {
    let success: [Line]
}

/// A single line.
public struct Line: Codable, Hashable, Sendable {
    /// The name of the line.
    public let name: String
}

// MARK: Streets

/// Successful response containing the list of streets.
public struct StreetSuccess: Codable, Hashable, Sendable {
    /// The list of streets.
    public let success: [Street]
}

/// A street.
public struct Street: Codable, Hashable, Sendable {
    /// An identifier of the street.
    public let id: Int

    /// The name of the street.
    public let name: String
}

// MARK: Times

struct TimesSuccess: Codable, Hashable, Sendable {
    let success: BollardWithTimes
}

/// A bollard with a list of departure times.
public struct BollardWithTimes: Codable, Hashable, Sendable {
    /// A bollard.
    public let bollard: BollardBollard

    /// The list of departure times for the bollard.
    public let times: [Time]
}

/// A departure time for a bollard.
public struct Time: Codable, Hashable, Sendable {
    /// The amount of minutes until the vehicle arrives at the bollard.
    public let minutes: Int

    /// Whether the vehicle contains a USB charger.
    public let charger: Bool?

    /// Whether the vehicle is a low floor bus.
    public let lowFloorBus: Bool?

    /// Name of the direction in which the vehicle goes.
    public let direction: String

    /// Whether the vehicle is already at the bollard.
    public let onStopPoint: Bool

    /// The name of the line.
    public let line: String

    /// The departure time.
    public let departure: String

    /// Whether the departure time is tracked in real time.
    public let realTime: Bool

    /// Whether the vehicle contains air conditioning.
    public let airCnd: Bool?

    public let lfRamp: Bool?

    public let lowEntranceBus: Bool?

    /// Whether the vehicle contains a ticket machine.
    public let ticketMachine: Bool?

    public let bike: Bool?

    public let leRamp: Bool?
}

struct TimesForAllBollardsSuccess: Codable, Hashable, Sendable {
    let success: TimesForAllBollards
}

/// Successful response containing the list of bollards with departure times.
public struct TimesForAllBollards: Codable, Hashable, Sendable {
    /// The list of bollards with departure times.
    public let bollardsWithTimes: [BollardWithTimes]
}
