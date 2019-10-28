//
//  Storyboards.swift
//  AppTheme
//
//  Created by Alvin Ling on 10/18/19.
//  Copyright © 2019 Alvin Ling. All rights reserved.
//

import UIKit

extension UIStoryboard {
    convenience init(storyboard: Storyboard.Type, bundle: Bundle? = Bundle.main) {
        self.init(name: storyboard.name, bundle: bundle)
    }
}

/**
 Represents storyboard names and view controller storyboard IDs as enums for instantiating view controllers from storyboards. Meant for use with enums only and the name of the conforming enum is expected to match the name of the corresponding storyboard files. The cases within enum should match the case and spelling of the storyboard IDs used within the corresponding storyboard file.
 
 
 This is to mainly to be used in situations with view controllers whose storyboard IDs do not match their class name.
 For example, view controllers that are not custom UIViewController subclasses such as UINavigationControllers.
 
 
 For view controller subclasses whose storyboard IDs do match their class name, consider using the StoryboardInstantiate protocol.
 
 
 For reusable view controllers, consider defining and designing them within their own storyboards.
 
 ## Creating a new storyboard enum
 1. Create an enum conforming to the Storyboard protocol (preferrably in a UIStoryboard extension) matching the name of the storyboard file.
 2. Add cases under that new enum that match the case and spelling of any storyboard IDs from that storyboard.
 3. If using the StoryboardInstantiable protocol, you only need to list the IDs that do not match their class names.
 */

protocol Storyboard {}

extension Storyboard {
    
    /// The name of this storyboard.
    fileprivate static var name: String {
        return "\(self)"
    }
    
    /// A UIStoryboard instance referring to this storyboard.
    private static var instance: UIStoryboard {
        return UIStoryboard(name: name, bundle: Bundle.main)
    }
    
    /// Instantiates a view controller originating from this storyboard with the given storyboard ID String.
    static func viewController<T: UIViewController>() -> T {
        return instance.instantiateViewController(withIdentifier: "\(T.self)") as! T
    }

    /// Instantiates the initial view controller originating from this storyboard.
    static func initialViewController<T: UIViewController>() -> T {
        return instance.instantiateInitialViewController() as! T
    }
    
    /// Instantiate the view controller that this enum refers to.
    func instantiate<T: UIViewController>() -> T {
        return Self.instance.instantiateViewController(withIdentifier: "\(self)") as! T
    }
}

/**
 Protocol for providing UIViewController subclasses with code for storyboard instantiation. Conforming subclasses are expected to have their storyboard ID match their class names.
 
 ## Usage
 1. Create an enum conforming to the Storyboard protocol (preferrably in a UIStoryboard extension) matching the name of the originating storyboard file.
 2. Conform the target view controller to this protocol.
 3. Typealias `Origin` as the enum type referring to the originating storyboard name
 */

protocol StoryboardInstantiable {
    associatedtype Origin: Storyboard
}

extension StoryboardInstantiable where Self: UIViewController {
    
    /// Instantiates this view controller for the originating storyboard defined by `Origin`.
    static func instantiate() -> Self {
        return Origin.viewController() as! Self
    }
}
