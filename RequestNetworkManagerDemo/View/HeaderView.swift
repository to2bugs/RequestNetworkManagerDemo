//
//  HeaderView.swift
//  RequestNetworkManagerDemo
//
//  Created by to2bage zero on 2026/6/16.
//

import SwiftUI

struct User: Identifiable, Codable {
	// User是Codable的前提是Gender也是Codable的
	enum Gender: String, Codable {
		case male, female
		
		var icon: String {
			switch self {
				case .male:
					"🤦🏻‍♂️"
				case .female:
					"🤦🏻‍♀️"
			}
		}
	}
		// User是Codable的前提是Status也是Codable的
	enum Status: String, Codable {
		case active, inactive
	}
	
	let id: Int
	var name: String
	var email: String
	var gender: Gender
	var status: Status
}

struct HeaderView: View {
	// By default, reading an object from the environment returns a non-optional object when
	// using the object type as the key.
	@Environment(UserViewModel.self) var viewModel
	// 也可以写成 @State private var viewModel = UserViewModel()
	
    var body: some View {
		List(viewModel.users) { user in
			VStack(alignment: .leading) {
				HStack {
					Text(user.gender.icon)
						.font(.largeTitle)
					Text(user.name)
						.font(.title.bold())
				}
				
				HStack {
					Text(user.email)
					Spacer()
					Text(verbatim: String(user.id))
						.font(.caption.smallCaps())
				}
			}
			.strikethrough(user.status == .inactive)
		}
		.listStyle(.plain)
		.task {
			do {
				try await viewModel.fetchUsers()
			} catch {
				print(error.localizedDescription)
			}
		}
    }
}

#Preview {
	@Previewable @State var userViewModel = UserViewModel()
    HeaderView()
		.environment(userViewModel)
}
