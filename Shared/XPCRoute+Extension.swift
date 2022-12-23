//
//  XPCRoute+Extension.swift
//  Mist
//
//  Created by Nindi Gill on 21/6/2022.
//

import SecureXPC

extension XPCRoute {
    static let commandRoute: XPCRouteWithMessageWithReply<HelperToolCommandRequest, HelperToolCommandResponse> = XPCRoute.named("com.ninxsoft.mist.helper")
        .withMessageType(HelperToolCommandRequest.self)
        .withReplyType(HelperToolCommandResponse.self)
}
