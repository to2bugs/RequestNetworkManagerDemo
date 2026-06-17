//
//  PostView.swift
//  RequestNetworkManagerDemo
//
//  Created by to2bage zero on 2026/6/16.
//

import SwiftUI

struct PostView: View {
	@State private var isPresentingCreateSheet = false
	
    var body: some View {
		HeaderView()
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						isPresentingCreateSheet = true
					} label: {
						Label("Create New User", systemImage: "plus")
					}

				}
			}
			.sheet(isPresented: $isPresentingCreateSheet) {
				CreateUserSheetView()
			}
    }
}

#Preview {
	@Previewable @State var userViewModel = UserViewModel()
	NavigationStack {
		PostView()
			.navigationTitle("Post")
			.environment(userViewModel)
	}
}
