//
//  StartView.swift
//  RequestNetworkManagerDemo
//
//  Created by to2bage zero on 2026/6/17.
//

import SwiftUI

struct StartView: View {
	@State private var viewOption: ViewOption = .first
	
    var body: some View {
		NavigationStack {
			viewOption
				.navigationTitle(viewOption.title)
				.toolbarTitleDisplayMode(.inlineLarge)
		}
		.safeAreaInset(edge: .bottom) {
			Picker("View Option", selection: $viewOption) {
				ForEach(ViewOption.allCases) { viewCase in
					Text(viewCase.picker)
				}
			}
			.background(.thinMaterial, in: Capsule())
			.shadow(color: .black.opacity(0.5), radius: 8, x: 5, y: 5)
			.frame(maxWidth: .infinity, alignment: .trailing)
			.padding(.horizontal)
		}
    }
}

#Preview {
    StartView()
		.environment(UserViewModel())
}
