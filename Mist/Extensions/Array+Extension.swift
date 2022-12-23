//
//  Array+Extension.swift
//  Mist
//
//  Created by Nindi Gill on 20/6/2022.
//

extension Array where Element == UInt8 {

    func uInt8(at offset: Int) -> UInt8 {
        self[offset]
    }

    func uInt32(at offset: Int) -> UInt32 {
        self[offset...offset + 0x03].reversed().reduce(0) {
            $0 << 0x08 + UInt32($1)
        }
    }

    func uInt64(at offset: Int) -> UInt64 {
        self[offset...offset + 0x07].reversed().reduce(0) {
            $0 << 0x08 + UInt64($1)
        }
    }
}
