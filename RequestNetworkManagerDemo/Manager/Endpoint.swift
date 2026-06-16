//
//  Endpoint.swift
//  RequestNetworkManagerDemo
//
//  Created by to2bage zero on 2026/6/15.
//  设置请求的路径、方法、头部携带的信息、以及携带的数据data
//  最终生成一个针对某个服务端的Endpoint的URLRequest对象

import Foundation

struct Endpoint {
	// 请求地址
	var urlString: String
	// 请求的方法: get、post、patch、put、delete
	var httpMethod: HTTPMethod
	// 请求的头部信息，字典类型
	private(set) var headers: [String: String] = [:]
	
	init(
		urlString: String,
		httpMethod: HTTPMethod = .get,
		headers: [String : String] = [:]
	) {
		self.urlString = urlString
		self.httpMethod = httpMethod
		self.headers = headers
	}
	
	// 添加头部信息
	mutating func addHeader(_ value: String, forHTTPHeaderField: String) {
		self.headers[forHTTPHeaderField] = value
	}
	
	// 生产请求的URLRequest
	func buildRequest() throws(NetworkError) -> URLRequest {
		guard let url = URL(string: self.urlString) else {
			throw .badURL
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = self.httpMethod.rawValue
		request.setValue("application/json", forHTTPHeaderField: "Accept")
		for (key, value) in self.headers {
			request.setValue(value, forHTTPHeaderField: key)
		}
		
		return request
	}
}
