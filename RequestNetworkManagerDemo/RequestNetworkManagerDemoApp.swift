//
//  RequestNetworkManagerDemoApp.swift
//  RequestNetworkManagerDemo
//
//  Created by to2bage zero on 2026/6/15.
//

import SwiftUI

@main
struct RequestNetworkManagerDemoApp: App {
	@State private var userViewModel = UserViewModel()
	
    var body: some Scene {
        WindowGroup {
			StartView()
				// 将UserViewModel对象放入到环境变量中
				.environment(userViewModel)
        }
    }
}
