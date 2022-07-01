//
//  UInt32+Extension.swift
//  Mist
//
//  Created by Nindi Gill on 20/6/2022.
//

import Foundation

extension UInt32 {

    func hexString() -> String {
        String(format: "0x%08X", self)
    }
}
