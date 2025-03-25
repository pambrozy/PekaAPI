//
//  PekaAPITests.swift
//  PekaAPI
//
//  Created by Przemysław Ambroży on 09.03.2022.
//  Copyright © 2022 Przemysław Ambroży
//

@testable import PekaAPI
import Testing

@Suite
struct PekaAPITests {
    private enum Constants {
        static let nonExisting = "Non-existing"
        static let stopPointName = "Rondo Kaponiera"
        static let streetName = "Grunwaldzka"
        static let lineName = "3"
        static let bollardSymbol = "RKAP71"
    }
    private let api = PekaAPI()

    @Test
    func stopPoints() async throws {
        let existing = try await api.stopPoints(query: Constants.stopPointName)
        #expect(!existing.isEmpty)

        let nonExisting = try await api.stopPoints(query: Constants.nonExisting)
        #expect(nonExisting.isEmpty)
    }

    @Test
    func bollardsByStopPoint() async throws {
        let existing = try await api.bollardsByStopPoint(name: Constants.stopPointName)
        #expect(!existing.isEmpty)

        await #expect(throws: DecodingError.self) {
            _ = try await api.bollardsByStopPoint(name: Constants.nonExisting)
        }
    }

    @Test
    func bollardsByStreet() async throws {
        let existing = try await api.bollardsByStreet(name: Constants.streetName)
        #expect(!existing.isEmpty)

        await #expect(throws: DecodingError.self) {
            _ = try await api.bollardsByStreet(name: Constants.nonExisting)
        }
    }

    @Test
    func lines() async throws {
        let existing = try await api.lines(query: Constants.lineName)
        #expect(!existing.isEmpty)

        let nonExisting = try await api.lines(query: Constants.nonExisting)
        #expect(nonExisting.isEmpty)
    }

    @Test
    func streets() async throws {
        let existing = try await api.streets(query: Constants.streetName)
        #expect(!existing.isEmpty)

        let nonExisting = try await api.streets(query: Constants.nonExisting)
        #expect(nonExisting.isEmpty)
    }

    @Test
    func times() async throws {
        let bollardWithTimes = try await api.times(symbol: Constants.bollardSymbol)
        #expect(bollardWithTimes.bollard.symbol == Constants.bollardSymbol)

        await #expect(throws: DecodingError.self) {
            _ = try await api.times(symbol: Constants.nonExisting)
        }
    }

    @Test
    func timesStopName() async throws {
        let existing = try await api.times(stopName: Constants.stopPointName)
        #expect(!existing.bollardsWithTimes.isEmpty)

        let nonExisting = try await api.times(stopName: Constants.nonExisting)
        #expect(nonExisting.bollardsWithTimes.isEmpty)
    }
}
