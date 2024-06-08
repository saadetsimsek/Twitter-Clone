//
//  ProfileDataFormViewViewModel.swift
//  Twitter Clone
//
//  Created by Saadet Şimşek on 08/06/2024.
//

import Foundation
import Combine

final class ProfileDataFormViewViewModel: ObservableObject {
    @Published var displayName: String?
    @Published var username: String?
    @Published var bio: String?
    @Published var avatarPath: String?
}
