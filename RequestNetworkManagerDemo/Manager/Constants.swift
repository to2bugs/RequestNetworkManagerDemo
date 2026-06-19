//
//  Constants.swift
//  RequestNetworkManagerDemo
//
//  Created by to2bage zero on 2026/6/16.
//

import Foundation

enum TestURL {
	static let jokesURL = "https://stewartlynch.github.io/Samples/jokes.json"
	static let gorestURL = "https://gorest.in/public/v2/users"
}

enum TestEndpoint {
	static var jokesEndpoint = Endpoint(
		urlString: TestURL.jokesURL,
		httpMethod: .get
	)
	
	static var userWithHeader = Endpoint(
		urlString: TestURL.gorestURL,
		httpMethod: .get
	)
	
	static var createUser = Endpoint(
		urlString: TestURL.gorestURL,
		httpMethod: .post
	)
}

// GoRest的token
let token = "f96fa55a0a1a18928d0fc7e342a79789de3d8fba4696494b72438a0754bb90c8"
