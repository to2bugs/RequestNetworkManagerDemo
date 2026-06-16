//
//  Loading.swift
//  RequestNetworkManagerDemo
//
//  Created by to2bage zero on 2026/6/16.
//  定义是否显示ProgressView的扩展

import SwiftUI

struct LoadingViewModifier: ViewModifier {
	let isLoading: Bool
	
	func body(content: Content) -> some View {
		if !isLoading {
			content
		} else {
			ProgressView()
		}
	}
}

extension View {
	func withLoading(isLoading: Bool = false) -> some View {
		modifier(LoadingViewModifier(isLoading: isLoading))
	}
}

