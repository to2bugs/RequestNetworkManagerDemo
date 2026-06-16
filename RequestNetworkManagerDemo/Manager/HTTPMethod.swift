//
//  HTTPMethod.swift
//  RequestNetworkManagerDemo
//
//  Created by to2bage zero on 2026/6/15.
//  定义HTTP请求的方法名称，并使用大写的名字来表示请求的方法

import Foundation

enum HTTPMethod {
	case get, post, put, patch, delete
	
	var rawValue: String {
		String(describing: self).uppercased()
	}
}
