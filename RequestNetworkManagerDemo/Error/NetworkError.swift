//
//  NetworkError.swift
//  RequestNetworkManagerDemo
//
//  Created by to2bage zero on 2026/6/15.
//  通用的错误定义

import Foundation

enum NetworkError: Error {
	case badURL
	case httpResponse
	case httpStatusCode(Int)
	case decoding
	case transport(TransportError)
	
	var userMessage: String {
		switch self {
			case .transport(let error):
				error.userMessage
			case .httpStatusCode(let code):
				switch code {
					case 401:
						"Your session has expired.  Please sign in again."
					case 403:
						"You don't have permission to do that."
					case 404:
						"We coudn't find what you were looking for."
					case 429:
						"Too many requests, Please wait a moment and try again."
					case 500...599:
						"The server is having trouble, Please try again."
					default:
						"Something went wrong. Please try again."
				}
			default:
				"Something went wrong. Please try again."
		}
	}
}


// 专门用来处理URLError传输错误
enum TransportError: Error {
	case offline, timedOut, dnsFailure, cannotConnect, cancelled, tlsFailure, unknown
	
	init(urlError: URLError) {
		switch urlError.code {
		case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
			self = .offline
		case .timedOut:
			self = .timedOut
		case .dnsLookupFailed, .cannotFindHost:
			self = .dnsFailure
		case .cannotConnectToHost:
			self = .cannotConnect
		case .cancelled:
			self = .cancelled
		case .secureConnectionFailed, .serverCertificateHasBadDate, .serverCertificateUntrusted, .serverCertificateHasUnknownRoot, .serverCertificateHasBadDate:
			self = .tlsFailure
		default:
			self = .unknown
		}
	}
	
	var userMessage: String {
		switch self {
			case .offline:
				"You appear to be offline, Check your internet connection and try again."
			case .timedOut:
				"The request time out. Please try again"
			case .dnsFailure, .cannotConnect:
				"We can't reach the server right now, Please try again."
			case .cancelled:
				"The request was cancelled"
			case .tlsFailure:
				"A secure connection could not be established"
			case .unknown:
				"A network error occurred, Please try again"
		}
	}
}
