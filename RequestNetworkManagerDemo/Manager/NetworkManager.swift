//
//  NetworkManager.swift
//  RequestNetworkManagerDemo
//
//  Created by to2bage zero on 2026/6/15.
//  获取数据的方法类

import Foundation

class NetworkManager {
	// 单例模式
	static let shared = NetworkManager()
	private init() {}
	
	// 获取数据，需传入Endpoint、以及设置JSONDecoder的方法
	// 数据必须符合Decodable协议
	// 抛出NetworkError异常
	func fetchAndDecodeJSON<T: Decodable>(
		from endpoint: Endpoint,
		configureDecoder: ((JSONDecoder) -> Void)? = nil
	) async throws(NetworkError) -> T {
		let request = try endpoint.buildRequest()
		return try await executedAndDecodeJSON(
			request: request,
			configureDecoder: configureDecoder
		)
	}
	
	
	// 共用的获取数据的部分
	// 这里需要传入针对不同的请求的URLRequest对象，以及设置JSONDecoder的方法
	// 抛出NetworkError异常
	func executedAndDecodeJSON<T: Decodable>(
		request: URLRequest,
		configureDecoder: ((JSONDecoder) -> Void)? = nil
	) async throws(NetworkError) -> T {
		do {
			let (data, response) = try await URLSession.shared.data(
				for: request
			)
			
			guard let httpUrlResponse = response as? HTTPURLResponse else {
				throw NetworkError.httpResponse
			}
			guard (200...299).contains(httpUrlResponse.statusCode) else {
				throw NetworkError.httpStatusCode(httpUrlResponse.statusCode)
			}
			
			// 解码
			do {
				let decoder = JSONDecoder() // class JSONDecoder
				configureDecoder?(decoder) // 配置解码器，比如日期，蛇形key解析
				return try decoder.decode(T.self, from: data)
			} catch let error as DecodingError {
				print(decodingError(error: error))
				throw NetworkError.decoding
			} catch {
				print("Decoding error: \(error.localizedDescription)")
				print("Data as string: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to String")")
				throw NetworkError.decoding
			}
			
		} catch let networkError as NetworkError {
			throw networkError
		} catch let urlError as URLError {
			throw NetworkError.transport(TransportError(urlError: urlError))
		} catch {
			print("Request error \(error.localizedDescription)")
			throw NetworkError.transport(.unknown)
		}
	}
	
	// 显示DecodingError的详细信息
	func decodingError(error: DecodingError) -> String {
		switch error {
		case .typeMismatch(let type, let context):
			"""
			Decoding Error: Type mismatch for type \(type)
			Context: \(context.debugDescription)
			Coding path: \(context.codingPath.map { $0.stringValue}.joined(separator: " -> "))
			"""
		case .valueNotFound(let type, let context):
			"""
			Decoding Error: Value of type \(type) not found
			Context: \(context.debugDescription)
			Coding path: \(context.codingPath.map { $0.stringValue}.joined(separator: " -> "))
			"""
		case .keyNotFound(let codingKey, let context):
			"""
			Decoding Error: Key '\(codingKey.stringValue)' not found
			Context: \(context.debugDescription)
			Coding path: \(context.codingPath.map { $0.stringValue}.joined(separator: " -> "))
			"""
		case .dataCorrupted(let context):
			"""
			Decoding Error: Data corrupted
			Context: \(context.debugDescription)
				Coding path: \(context.codingPath.map { $0.stringValue}.joined(separator: " -> "))
			"""
		@unknown default:
			"""
			Unknown error: \(error.localizedDescription)
			"""
		}
	}
}
