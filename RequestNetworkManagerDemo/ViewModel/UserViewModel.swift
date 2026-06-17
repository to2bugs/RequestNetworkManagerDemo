//
//  UserViewModel.swift
//  RequestNetworkManagerDemo
//
//  Created by to2bage zero on 2026/6/16.
//

import SwiftUI

@Observable
class UserViewModel {
	var users: [User] = []
	// let manager = NetworkManager.shared
	
	func fetchUsers() async throws(NetworkError) {
		var endpoint = Endpoint(urlString: TestURL.gorestURL, httpMethod: .get)
		endpoint.addHeader("application/json", forHTTPHeaderField: "Content-Type")
		endpoint.addHeader("Bearer \(token)", forHTTPHeaderField: "Authorization")
		
		self.users = try await NetworkManager.shared.fetchAndDecodeJSON(from: endpoint)
	}
	
	func createUser(
		name: String,
		email: String,
		gender: User.Gender,
		status: User.Status
	) async throws(NetworkError) {
		
		struct NewUserRequest: Encodable {
			let name: String
			let email: String
			let gender: User.Gender
			let status: User.Status
		}
		
		let payload = NewUserRequest(
			name: name,
			email: email,
			gender: gender,
			status: status
		)
		
		var endpoint = TestEndpoint.createUser
		endpoint.addHeader("application/json", forHTTPHeaderField: "Content-Type")
		endpoint.addHeader("Bearer \(token)", forHTTPHeaderField: "Authorization")
		endpoint.addHeader("application/json", forHTTPHeaderField: "Accept")
		
		let _: User = try await NetworkManager.shared.sendJSONAndDecodeResponse(
			from: endpoint,
			payload: payload
		)
		
		try await fetchUsers()
	}
}
