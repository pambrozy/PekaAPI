//
//  PekaAPI.swift
//  PekaAPI
//
//  Created by Przemysław Ambroży on 09.03.2022.
//  Copyright © 2022 Przemysław Ambroży
//

import Foundation

/// A class responsible for fetching information from the PEKA API endpoints.
public class PekaAPI {
    /// Represents an error that may occur when creating the request.
    public enum RequestMakingError: Error {
        /// Indicates that the parameters of the request can not be encoded.
        case encodingParameters
        /// Indicates that the body of the request can not be encoded.
        case encodingBody
    }

    /// The URL of the endpoint.
    public let url: URL

    /// The URLSession used to make the calls to the endpoint.
    public let session: URLSession

    private let decoder = JSONDecoder()

    /// Creates a new instance of the class.
    /// - Parameters:
    ///   - url: The URL of the endpoint.
    ///   - session: The URLSession to use to make the calls to the endpoint.
    public init(
        url: URL = URL(string: "http://www.peka.poznan.pl/vm/method.vm")!,
        session: URLSession = .shared
    ) {
        self.url = url
        self.session = session
    }

    private func makeRequest(_ method: String, parameters: [String: Any]) throws -> URLRequest {
        let parametersData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        guard let parametersString = String(data: parametersData, encoding: .utf8) else {
            throw RequestMakingError.encodingParameters
        }
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "method", value: method),
            URLQueryItem(name: "p0", value: parametersString)
        ]
        guard let bodyData = components.percentEncodedQuery?.data(using: .utf8) else {
            throw RequestMakingError.encodingBody
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(
            "application/x-www-form-urlencoded; charset=UTF-8",
            forHTTPHeaderField: "Content-Type"
        )
        request.httpBody = bodyData
        return request
    }

    private func runRequest<T: Decodable>(
        method: String,
        parameters: [String: Any],
        type: T.Type
    ) async throws -> T {
        let request = try makeRequest(method, parameters: parameters)
        let (data, _ ) = try await session.data(for: request)
        return try decoder.decode(T.self, from: data)
    }
}

extension PekaAPI {
    /// Searches of the stop points whose names match the query.
    /// - Parameter query: Part of the stop point's name.
    /// - Returns: A list of stop points matching the query.
    public func stopPoints(query: String) async throws -> [StopPoint] {
        try await runRequest(
            method: "getStopPoints",
            parameters: ["pattern": query],
            type: StopPointSuccess.self
        ).success
    }

    /// Returns a list of bollards and directions for a given stop point.
    /// - Parameter name: The name of the stop point.
    /// - Returns: A list of bollards and directions.
    public func bollardsByStopPoint(name: String) async throws -> [BollardDirections] {
        try await runRequest(
            method: "getBollardsByStopPoint",
            parameters: ["name": name],
            type: BollardSuccess.self
        ).success.bollards
    }

    /// Returns a list of bollards and directions for a given street name.
    /// - Parameter name: The name of the street.
    /// - Returns: A list of bollards and directions.
    public func bollardsByStreet(name: String) async throws -> [BollardDirections] {
        try await runRequest(
            method: "getBollardsByStreet",
            parameters: ["name": name],
            type: BollardSuccess.self
        ).success.bollards
    }

    /// Searches for lines matching the query.
    /// - Parameter query: Part of the line's name.
    /// - Returns: A list of lines matching the query.
    public func lines(query: String) async throws -> [Line] {
        try await runRequest(
            method: "getLines",
            parameters: ["pattern": query],
            type: LineSuccess.self
        ).success
    }

    /// Searches for streets matching the query.
    /// - Parameter query: Part of the line's name.
    /// - Returns: A list of streets matching the query.
    public func streets(query: String) async throws -> [Street] {
        try await runRequest(
            method: "getStreets",
            parameters: ["pattern": query],
            type: StreetSuccess.self
        ).success
    }

    /// Returns the departure times for a given bollard.
    /// - Parameter symbol: The symbol of the bollard.
    /// - Returns: The deparrture times.
    public func times(symbol: String) async throws -> BollardWithTimes {
        try await runRequest(
            method: "getTimes",
            parameters: ["symbol": symbol],
            type: TimesSuccess.self
        ).success
    }

    /// Returns the departure times for bollards for a given stop.
    /// - Parameter stopName: The name of the stop point.
    /// - Returns: The deparrture times for bollards.
    public func times(stopName: String) async throws -> TimesForAllBollards {
        try await runRequest(
            method: "getTimesForAllBollards",
            parameters: ["name": stopName],
            type: TimesForAllBollardsSuccess.self
        ).success
    }
}

@available(iOS, deprecated: 15.0, message: "Use the built-in API instead")
extension URLSession {
    fileprivate func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }

                continuation.resume(returning: (data, response))
            }

            task.resume()
        }
    }
}
