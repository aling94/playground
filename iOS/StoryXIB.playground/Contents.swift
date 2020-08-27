import UIKit

protocol BundleReferencing: class {
    static var myBundle: Bundle { get }
}

extension BundleReferencing {
    static var myBundle: Bundle { Bundle(for: self) }
}

protocol Storyboard {
    var name: String { get }
}

extension Storyboard where Self: RawRepresentable, Self.RawValue == String {
    var name: String { rawValue }
}

protocol Storyboarded: BundleReferencing {

    /// The enum that represents the name of the storyboard this class belongs to. If nil, the name
    /// of the class is assumed to be the storyboard name.
    static var storyboard: Storyboard? { get }

    /// Storyboard ID. Defaults to the name of the class. If nil, the initial View Controller in the
    /// storyboard is used to instantiate this class.
    static var storyboardID: String? { get }
}

extension Storyboarded {
    static var storyboard: Storyboard? { nil }
    static var storyboardID: String? { String(describing: self) }
}

extension Storyboarded where Self: UIViewController {

    static func fromStoryboard() -> Self? {
        let storyboardName = storyboard?.name ?? String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: myBundle)

        if let id = storyboardID {
            return storyboard.instantiateViewController(withIdentifier: id) as? Self
        }
        return storyboard.instantiateInitialViewController() as? Self
    }
}

protocol XIBInstantiable: BundleReferencing {
    static var xibName: String { get }
}

extension XIBInstantiable {
    static var xibName: String { String(describing: self) }

    static func fromXIB() -> Self? {
        UINib(nibName: xibName, bundle: myBundle)
            .instantiate(withOwner: nil, options: nil)[0] as? Self
    }
}

extension UIStoryboard {
    enum Example: String, Storyboard {
        case HelloWorld
    }
}

final class HelloWorldVC: UIViewController, Storyboarded {
    static let storyboard = UIStoryboard.Example.HelloWorld
}
