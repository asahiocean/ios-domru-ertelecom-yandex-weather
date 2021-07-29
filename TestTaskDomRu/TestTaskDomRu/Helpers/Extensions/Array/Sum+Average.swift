import Foundation

public extension Sequence where Element: AdditiveArithmetic {
    /// Returns the total sum of all elements in the sequence
    var sum: Element { reduce(.zero, +) }
}
public extension Collection where Element: BinaryFloatingPoint {
    /// Returns the average of all elements in the array
    var average: Element { isEmpty ? 0 : sum / Element(count) }
}
