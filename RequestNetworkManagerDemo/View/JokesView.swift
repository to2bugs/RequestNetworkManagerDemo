//
//  JokesView.swift
//  RequestNetworkManagerDemo
//
//  Created by to2bage zero on 2026/6/16.
//

import SwiftUI

struct Joke2: Identifiable, Codable {
	let id: Int
	let setup: String
	let punchline: String
	let entryDate: Date
}

struct JokesView: View {
	@State private var viewModel = DataViewModel<[Joke2]>(
		endpoint: TestEndpoint.jokesEndpoint) { decoder in
			decoder.dateDecodingStrategy = .iso8601
		}
	
    var body: some View {
		Group {
			if let jokes = viewModel.data, !jokes.isEmpty {
				List(jokes.shuffled()) { joke in
					VStack(alignment: .leading, spacing: 6) {
						Text(joke.setup)
							.font(.headline)
						Text(joke.punchline)
						Text(
							joke.entryDate,
							format: .dateTime.month().day().year()
						)
						.frame(maxWidth: .infinity, alignment: .trailing)
					}
					.padding(.vertical, 4)
				}
				.listStyle(.plain)
			} else {
				ContentUnavailableView("No Jokes available", systemImage: "hand.thumbsdown.fill")
			}
		}
		.withLoading(isLoading: viewModel.isLoading)
		.task {
			await viewModel.fetchData()
		}
		.alert(
			"Unable to load jokes",
			isPresented: Binding(get: {
				viewModel.networkError != nil
			}, set: { value in
				if !value {
					viewModel.networkError = nil
				}
			}),
			// presenting指的是向alert传递的参数，类型必须是Option<?>
			presenting: viewModel.networkError) { _ in
				Button("OK") {
					
				}
			} message: { networkError in
				// networkError就是通过presenting传递进来的参数
				Text(networkError.userMessage)
			}
    }
}

#Preview {
    JokesView()
}
