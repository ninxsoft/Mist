//
//  AuthorizationError+Extension.swift
//  Mist
//
//  Created by Nindi Gill on 21/6/2022.
//

import Authorized

extension AuthorizationError: Equatable {

    public static func == (lhs: AuthorizationError, rhs: AuthorizationError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}
