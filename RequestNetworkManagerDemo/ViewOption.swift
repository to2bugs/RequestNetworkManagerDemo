//
//  ViewOption.swift
//  RequestNetworkManagerDemo
//
//  Created by to2bage zero on 2026/6/17.
//

import SwiftUI

enum ViewOption: CaseIterable, Identifiable, View {
	case first, second, third, fourth, fifth
	var id: Self { self }
	
	var title: String {
		switch self {
		case .first:
			"Jokes"
		case .second:
			"Get With Header"
		case .third:
			"Post"
		case .fourth:
			"Put/Patch"
		case .fifth:
			"Delete"
		}
	}
	
	var picker: String {
		switch self {
		case .first:
			"JokesView"
		case .second:
			"GET With HEADER"
		case .third:
			"POST"
		case .fourth:
			"PUT/PATCH"
		case .fifth:
			"DELETE"
		}
	}
	
	var body: some View {
		switch self {
		case .first:
			JokesView()
		case .second:
			HeaderView()
		case .third:
			PostView()
		case .fourth:
			EmptyView() // PutPatchView()
		case .fifth:
			EmptyView() //DeleteView()
		}
	}
	
}
