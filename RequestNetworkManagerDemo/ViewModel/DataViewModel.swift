//
//  DataViewModel.swift
//  RequestNetworkManagerDemo
//
//  Created by to2bage zero on 2026/6/15.
//  为页面提供数据服务

import SwiftUI

@Observable
class DataViewModel<T> where T: Decodable {
	// 获取到的结果
	var data: T?
	// 1. 会作为参数传递给alert(presenting: 传入的参数)
	// 2. 会作为alert是否显示的条件之一，即 networkError != nil时会显示alert
	var networkError: NetworkError? = nil
	// 是否展示EmptyView()
	var isLoading: Bool = false
	
	// 定义访问的地址、访问的方法、设置头部数据、设置携带的数据
	let endpoint: Endpoint
	// 配置JSONDecoder的方法
	private let configureDecoder: ((JSONDecoder) -> Void)?
	
	// 调用manager
	private let manager = NetworkManager.shared
	
	init(endpoint: Endpoint, configureDecoder: ((JSONDecoder) -> Void)? = nil) {
		self.endpoint = endpoint
		self.configureDecoder = configureDecoder
	}
	
	func fetchData() async {
		self.isLoading = true
		defer {
			isLoading = false
		}
		
		networkError = nil
		#if DEBUG
		try? await Task.sleep(for: .seconds(1))
		#endif
		
		do {
			if let configureDecoder {
				data = try await manager
					.fetchAndDecodeJSON(
						from: self.endpoint,
						configureDecoder: self.configureDecoder
					)
			} else {
				data = try await manager.fetchAndDecodeJSON(from: self.endpoint)
			}
		} catch let error {
			networkError = error
		}
	}
}
