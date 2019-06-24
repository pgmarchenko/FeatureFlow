//
//  UIApplication+Rx.swift
//  RxCocoa
//
//  Created by Mads Bøgeskov on 18/01/16.
//  Copyright © 2016 Krunoslav Zaher. All rights reserved.
//

#if os(iOS)

    import UIKit
    import RxSwift

    extension Reactive where Base: UIApplication {
        
        /// Bindable sink for `networkActivityIndicatorVisible`.
        public var isNetworkActivityIndicatorVisible: Binder<Bool> {
            return Binder(self.base) { application, active in
                application.isNetworkActivityIndicatorVisible = active
            }
        }
    }

    extension Reactive where Base: UIApplication {
        public static var willResignActive: ControlEvent<()> {
            let source = NotificationCenter.default.rx.notification(UIApplication.willResignActiveNotification).map { _ in return () }
            
            return ControlEvent(events: source)
        }
        
        public static var didEnterBackground: ControlEvent<()> {
            let source = NotificationCenter.default.rx.notification(UIApplication.didEnterBackgroundNotification).map { _ in return () }
            
            return ControlEvent(events: source)
        }
        
        public static var willEnterForeground: ControlEvent<()> {
            let source = NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification).map { _ in return () }
            
            return ControlEvent(events: source)
        }
        
        public static var didBecomeActive: ControlEvent<()> {
            let source = NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification).map { _ in return () }
            
            return ControlEvent(events: source)
        }
        
        public static var willTerminate: ControlEvent<()> {
            let source = NotificationCenter.default.rx.notification(UIApplication.willTerminateNotification).map { _ in return () }
            
            return ControlEvent(events: source)
        }

        public static var didReceiveMemoryWarning: ControlEvent<()> {
            let source = NotificationCenter.default.rx.notification(UIApplication.didReceiveMemoryWarningNotification).map { _ in return () }

            return ControlEvent(events: source)
        }
    }


    extension UIApplication: HasDelegate {
        public typealias Delegate = UIApplicationDelegate
    }

    public class RxUIApplicationDelegateProxy: DelegateProxy<UIApplication, UIApplicationDelegate>, DelegateProxyType, UIApplicationDelegate {
        
        public init(application: UIApplication) {
            super.init(parentObject: application, delegateProxy: RxUIApplicationDelegateProxy.self)
        }
        
        public static func registerKnownImplementations() {
            self.register { RxUIApplicationDelegateProxy(application: $0) }
        }
    }

    extension Reactive where Base: UIApplication {
        public var delegate: RxUIApplicationDelegateProxy {
            return RxUIApplicationDelegateProxy.proxy(for: base)
        }
        
        public var notificationSettings: Observable<UIUserNotificationSettings> {
            return delegate.methodInvoked(#selector(UIApplicationDelegate.application(_:didRegister:))).map { a in
                return try castOrThrow(UIUserNotificationSettings.self, a[1])
            }
        }
        
        public static var didRegisterNotificationSettings: Observable<UIUserNotificationSettings> {
            return UIApplication.shared.rx.notificationSettings
        }
    }

    private func castOptionalOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T? {
        if NSNull().isEqual(object) {
            return nil
        }
        
        guard let returnValue = object as? T else {
            throw RxCocoaError.castingError(object: object, targetType: resultType)
        }
        
        return returnValue
    }

#endif

