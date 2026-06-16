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
	
	func fetchUser() async throws(NetworkError) {
		var endpoint = Endpoint(urlString: TestURL.gorestURL, httpMethod: .get)
		endpoint.addHeader("application/json", forHTTPHeaderField: "Content-Type")
		endpoint.addHeader("Bearer \(token)", forHTTPHeaderField: "Authorization")
		
		self.users = try await NetworkManager.shared.fetchAndDecodeJSON(from: endpoint)
	}
}
