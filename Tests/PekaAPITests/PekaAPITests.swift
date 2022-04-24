//
//  PekaAPITests.swift
//  PekaAPI
//
//  Created by Przemysław Ambroży on 09.03.2022.
//  Copyright © 2022 Przemysław Ambroży
//

@testable import PekaAPI
import XCTest

final class PekaAPITests: XCTestCase {
    private enum Constants {
        static let nonExisting = "Non-existing"
        static let stopPointName = "Rondo Kaponiera"
        static let streetName = "Fredry"
        static let lineName = "3"
        static let bollardSymbol = "RKAP71"
    }
    let api = PekaAPI()

    func testStopPoints() async throws {
        let existing = try await api.stopPoints(query: Constants.stopPointName)
        XCTAssertFalse(existing.isEmpty)

        let nonExisting = try await api.stopPoints(query: Constants.nonExisting)
        XCTAssertTrue(nonExisting.isEmpty)
    }

    func testBollardsByStopPoint() async throws {
        let existing = try await api.bollardsByStopPoint(name: Constants.stopPointName)
        XCTAssertFalse(existing.isEmpty)

        do {
            _ = try await api.bollardsByStopPoint(name: Constants.nonExisting)
            XCTFail("Found bollards on non-existing stop point")
        } catch {
            XCTAssert(error is DecodingError)
        }
    }

    func testBollardsByStreet() async throws {
        let existing = try await api.bollardsByStreet(name: Constants.streetName)
        XCTAssertFalse(existing.isEmpty)

        do {
            _ = try await api.bollardsByStreet(name: Constants.nonExisting)
            XCTFail("Found bollards on non-existing street")
        } catch {
            XCTAssert(error is DecodingError)
        }
    }

    func testLines() async throws {
        let existing = try await api.lines(query: Constants.lineName)
        XCTAssertFalse(existing.isEmpty)

        let nonExisting = try await api.lines(query: Constants.nonExisting)
        XCTAssertTrue(nonExisting.isEmpty)
    }

    func testStreets() async throws {
        let existing = try await api.streets(query: Constants.streetName)
        XCTAssertFalse(existing.isEmpty)

        let nonExisting = try await api.streets(query: Constants.nonExisting)
        XCTAssertTrue(nonExisting.isEmpty)
    }

    func testTimes() async throws {
        _ = try await api.times(symbol: Constants.bollardSymbol)

        do {
            _ = try await api.times(symbol: Constants.nonExisting)
            XCTFail("Found times for non-existing bollard")
        } catch {
            XCTAssert(error is DecodingError)
        }
    }

    func testTimesStopName() async throws {
        let existing = try await api.times(stopName: Constants.stopPointName)
        XCTAssertFalse(existing.bollardsWithTimes.isEmpty)

        let nonExisting = try await api.times(stopName: Constants.nonExisting)
        XCTAssertTrue(nonExisting.bollardsWithTimes.isEmpty)
    }
}
