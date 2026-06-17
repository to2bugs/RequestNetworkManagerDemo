//
//  CreateUserSheetView.swift
//  RequestNetworkManagerDemo
//
//  Created by to2bage zero on 2026/6/16.
//

import SwiftUI

struct CreateUserSheetView: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(UserViewModel.self) private var viewModel
	
	// 是一个Optional<User>类型
	// 意味着如果不提供的话就是新增用户，提供的话就是编辑用户
	let user: User?
	
	// 这一组是API所需要的数据
	@State private var name = ""
	@State private var email = ""
	@State private var gender: User.Gender = .male
	@State private var status: User.Status = .active
	
	@State private var isSubmiting = false
	// 用于确定是否需要显示alert
	@State private var errorMessage: String?
	@State private var hasInitializedForm = false
	
	// 计算属性: 用于区分是新增用户，还是编辑用户
	private var isEdting: Bool {
		user != nil
	}
	private var navigationTitle: String {
		isEdting ? "Update User" : "Create User"
	}
	private var submitTitle: String {
		isEdting ? "Update" : "Add"
	}
	private var alertTitle: String {
		isEdting ? "Unable to update user" : "Unable to create user"
	}
	private var canSubmit: Bool {
		!name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
		!email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
		!isSubmiting
	}
	
	init(user: User? = nil) {
		self.user = user
	}
	
    var body: some View {
		NavigationStack {
			formSection
				.navigationTitle(navigationTitle)
				.toolbarTitleDisplayMode(.inline)
				.toolbar {
					ToolbarItem(placement: .topBarLeading) {
						Button("Cancel") {
							dismiss()
						}
						.disabled(isSubmiting)
					}
					
					ToolbarItem(placement: .topBarTrailing) {
						Button(submitTitle) {
							Task {
								await submit()
							}
						}
						.disabled(!canSubmit)
					}
				}
				.onAppear {
					guard !hasInitializedForm else { return }
					if let user {
						name = user.name
						email = user.email
						gender = user.gender
						status = user.status
					}
					hasInitializedForm = true // ？？？
				}
				.alert(
					alertTitle,
					isPresented: Binding(get: {
						errorMessage != nil
					}, set: { value in
						if !value {
							errorMessage = nil
						}
					})) {
						Button("OK", role: .cancel) {
							// TODO:
						}
					} message: {
						Text(errorMessage ?? "")
					}

		}
    }
	
	private var formSection: some View {
		Form {
			TextField("Name", text: $name)
				.textFieldStyle(.roundedBorder)
				.textInputAutocapitalization(.never)
			
			TextField("Email", text: $email)
				.textFieldStyle(.roundedBorder)
				.textInputAutocapitalization(.never) // 不要自动的首字母大写
				.keyboardType(.emailAddress) // 键盘的类型
			
			Picker("Gender", selection: $gender) {
				Text("Male")
					.tag(User.Gender.male) // tag的值会赋值给$gender
				Text("FeMale")
					.tag(User.Gender.female)
			}
			.pickerStyle(.segmented)
			
			Picker("Status", selection: $status) {
				Text("Active")
					.tag(User.Status.active)
				Text("Inactive")
					.tag(User.Status.inactive)
			}
			.pickerStyle(.segmented)
			
			if isSubmiting {
				HStack {
					Spacer()
					ProgressView()
					Spacer()
				}
			}
			
		}
	}
	
	private func submit() async {
		guard canSubmit else {
			return
		}
		self.isSubmiting = true
		defer {
			self.isSubmiting = false
		}
		
		do {
			if let user {
				// 编辑用户
			} else {
				// 新增用户
				try await viewModel
					.createUser(
						name: name,
						email: email,
						gender: gender,
						status: status
					)
			}
			// 不论是新建用户还是编辑用户，在这之后关闭窗口
			dismiss()
		} catch let networkError {
			// 赋值错误消息
			errorMessage = networkError.userMessage
		}
	}
}

#Preview {
	NavigationStack {
		CreateUserSheetView(user: nil)
			.environment(UserViewModel())
	}
}
