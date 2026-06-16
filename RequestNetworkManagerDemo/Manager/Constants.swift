//
//  Constants.swift
//  RequestNetworkManagerDemo
//
//  Created by to2bage zero on 2026/6/16.
//

import Foundation

enum TestURL {
	static let jokesURL = "https://stewartlynch.github.io/Samples/jokes.json"
	static let gorestURL = "https://gorest.co.in/public/v2/users"
}

enum TestEndpoint {
	static var jokesEndpoint = Endpoint(
		urlString: TestURL.jokesURL,
		httpMethod: .get
	)
}
