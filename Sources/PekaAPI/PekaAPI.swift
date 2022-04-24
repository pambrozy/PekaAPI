//
//  PekaAPI.swift
//  PekaAPI
//
//  Created by Przemysław Ambroży on 09.03.2022.
//  Copyright © 2022 Przemysław Ambroży
//

import Foundation

public class PekaAPI {
    public enum ApiError: Error {
        case encodingParameters
        case encodingBody
    }

    public let url: URL
    public let session: URLSession

    private let decoder = JSONDecoder()

    public init(
        url: URL = URL(string: "http://www.peka.poznan.pl/vm/method.vm")!,
        session: URLSession = .shared
    ) {
        self.url = url
        self.session = session
    }

    func makeRequest(_ method: String, parameters: [String: Any]) throws -> URLRequest {
        let parametersData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        guard let parametersString = String(data: parametersData, encoding: .utf8) else {
            throw ApiError.encodingParameters
        }
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "method", value: method),
            URLQueryItem(name: "p0", value: parametersString)
        ]
        guard let bodyData = components.percentEncodedQuery?.data(using: .utf8) else {
            throw ApiError.encodingBody
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
    public func stopPoints(query: String) async throws -> [StopPoint] {
        try await runRequest(
            method: "getStopPoints",
            parameters: ["pattern": query],
            type: StopPointSuccess.self
        ).success
    }

    public func bollardsByStopPoint(name: String) async throws -> [BollardDirections] {
        try await runRequest(
            method: "getBollardsByStopPoint",
            parameters: ["name": name],
            type: BollardSuccess.self
        ).success.bollards
    }

    public func bollardsByStreet(name: String) async throws -> [BollardDirections] {
        try await runRequest(
            method: "getBollardsByStreet",
            parameters: ["name": name],
            type: BollardSuccess.self
        ).success.bollards
    }

    public func lines(query: String) async throws -> [Line] {
        try await runRequest(
            method: "getLines",
            parameters: ["pattern": query],
            type: LineSuccess.self
        ).success
    }

    public func streets(query: String) async throws -> [Street] {
        try await runRequest(
            method: "getStreets",
            parameters: ["pattern": query],
            type: StreetSuccess.self
        ).success
    }

    public func times(symbol: String) async throws -> BollardWithTimes {
        try await runRequest(
            method: "getTimes",
            parameters: ["symbol": symbol],
            type: TimesSuccess.self
        ).success
    }

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
