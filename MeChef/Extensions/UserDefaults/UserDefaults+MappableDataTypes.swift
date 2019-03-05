import ObjectMapper
import RxSwift

// LeadKit candidate :)
// Seriously. This is the simplest way to store user objects like cart (with tiny number of items).

/// A type representing an possible errors that can be thrown during fetching
/// model or array of specified type from UserDefaults.
///
/// - noSuchValue:          there is no such value for given key
/// - unableToMap:          the value cannot be mapped to given type for some reason
public enum UserDefaultsError: Error {

    case noSuchValue(key: String)
    case unableToMap(mappingError: Error)

}

private typealias JSONObject = [String: Any]

public extension UserDefaults {

    private func storedValue<ST>(forKey key: String) throws -> ST {
        guard let objectForKey = object(forKey: key) else {
            throw UserDefaultsError.noSuchValue(key: key)
        }

        return try cast(objectForKey) as ST
    }

    /// Returns the object with specified type associated with the first occurrence of the specified default.
    ///
    /// - parameter key: A key in the current user's defaults database.
    ///
    /// - throws: One of cases in UserDefaultsError
    ///
    /// - returns: The object with specified type associated with the specified key,
    /// or throw exception if the key was not found.
    func object<T>(forKey key: String) throws -> T where T: ImmutableMappable {
        let jsonObject = try storedValue(forKey: key) as JSONObject

        do {
            return try T(JSON: jsonObject)
        } catch {
            throw UserDefaultsError.unableToMap(mappingError: error)
        }
    }

    /// Returns the array of objects with specified type associated with the first occurrence of the specified default.
    ///
    /// - parameter key: A key in the current user's defaults database.
    ///
    /// - throws: One of cases in UserDefaultsError
    ///
    /// - returns: The array of objects with specified type associated with the specified key,
    /// or throw exception if the key was not found.
    func objects<T>(forKey key: String) throws -> [T] where T: ImmutableMappable {
        let jsonArray = try storedValue(forKey: key) as [JSONObject]
        do {
            return try jsonArray.map { try T(JSON: $0) }
        } catch {
            throw UserDefaultsError.unableToMap(mappingError: error)
        }
    }

    /// Returns the object with specified type associated with the first occurrence of the specified default.
    ///
    /// - parameter key:          A key in the current user's defaults database.
    /// - parameter defaultValue: A default value which will be used if there is no such value for specified key,
    /// or if error occurred during mapping
    ///
    /// - returns: The object with specified type associated with the specified key, or passed default value
    /// if there is no such value for specified key or if error occurred during mapping.
    func object<T>(forKey key: String, defaultValue: T) -> T where T: ImmutableMappable {
        return (try? object(forKey: key)) ?? defaultValue
    }

    /// Returns the array of objects with specified type associated with the first occurrence of the specified default.
    ///
    /// - parameter key:          A key in the current user's defaults database.
    /// - parameter defaultValue: A default value which will be used if there is no such value for specified key,
    /// or if error occurred during mapping
    ///
    /// - returns: The array of objects with specified type associated with the specified key, or passed default value
    /// if there is no such value for specified key or if error occurred during mapping.
    func objects<T>(forKey key: String, defaultValue: [T]) -> [T] where T: ImmutableMappable {
        return (try? objects(forKey: key)) ?? defaultValue
    }

    /// Sets or removes the value of the specified default key in the standard application domain.
    ///
    /// - Parameters:
    ///   - model: The object with specified type to store or nil to remove it from the defaults database.
    ///   - key:   The key with which to associate with the value.
    func set<T>(model: T?, forKey key: String) where T: ImmutableMappable {
        if let model = model {
            set(model.toJSON(), forKey: key)
        } else {
            set(nil, forKey: key)
        }
    }

    /// Sets or removes the value of the specified default key in the standard application domain.
    ///
    /// - Parameters:
    ///   - models: The array of object with specified type to store or nil to remove it from the defaults database.
    ///   - key:    The key with which to associate with the value.
    func set<T, S>(models: S?, forKey key: String) where T: ImmutableMappable, S: Sequence, S.Iterator.Element == T {
        if let models = models {
            set(models.map { $0.toJSON() }, forKey: key)
        } else {
            set(nil, forKey: key)
        }
    }

}

public extension Reactive where Base: UserDefaults {

    /// Reactive version of object<T>(forKey:) -> T.
    ///
    /// - parameter key: A key in the current user's defaults database.
    ///
    /// - returns: Observable of specified model type.
    func object<T>(forKey key: String) -> Single<T> where T: ImmutableMappable {
        return Single.deferredJust { try self.base.object(forKey: key) }
    }

    /// Reactive version of object<T>(forKey:defaultValue:) -> T.
    ///
    /// Will never call onError(:) on observer.
    ///
    /// - parameter key:          A key in the current user's defaults database.
    /// - parameter defaultValue: A default value which will be used if there is no such value for specified key,
    /// or if error occurred during mapping
    ///
    /// - returns: Observable of specified model type.
    func object<T>(forKey key: String, defaultValue: T) -> Single<T> where T: ImmutableMappable {
        return Single.deferredJust { self.base.object(forKey: key, defaultValue: defaultValue) }
    }

    /// Reactive version of object<T>(forKey:) -> [T].
    ///
    /// - parameter key: A key in the current user's defaults database.
    ///
    /// - returns: Observable of specified array type.
    func object<T>(forKey key: String) -> Single<[T]> where T: ImmutableMappable {
        return Single.deferredJust { try self.base.objects(forKey: key) }
    }

    /// Reactive version of object<T>(forKey:defaultValue:) -> [T].
    ///
    /// Will never call onError(:) on observer.
    ///
    /// - parameter key:          A key in the current user's defaults database.
    /// - parameter defaultValue: A default value which will be used if there is no such value for specified key,
    /// or if error occurred during mapping
    ///
    /// - returns: Observable of specified array type.
    func object<T>(forKey key: String, defaultValue: [T]) -> Single<[T]> where T: ImmutableMappable {
        return Single.deferredJust { self.base.objects(forKey: key, defaultValue: defaultValue) }
    }

    /// Reactive version of set<T>(_:forKey:).
    ///
    /// Will never call onError(:) on observer.
    ///
    /// - parameter model: The object with specified type to store in the defaults database.
    /// - parameter key:   The key with which to associate with the value.
    ///
    /// - returns: Observable of Void type.
    func set<T>(model: T?, forKey key: String) -> Completable where T: ImmutableMappable {
        return Completable.create { _ in
            self.base.set(model: model, forKey: key)
            return Disposables.create()
        }
    }

    /// Reactive version of set<T, S>(_:forKey:).
    ///
    /// Will never call onError(:) on observer.
    ///
    /// - parameter models: The array of object with specified type to store in the defaults database.
    /// - parameter key:    The key with which to associate with the value.
    ///
    /// - returns: Observable of Void type.
    func set<T, S>(models: S?, forKey key: String) -> Completable
        where T: ImmutableMappable, S: Sequence, S.Iterator.Element == T {
            return Completable.create { _ in
                self.base.set(models: models, forKey: key)
                return Disposables.create()
            }
    }

}

private func cast<T>(_ value: Any?) throws -> T {
    guard let val = value as? T else {
        throw LeadKitError.failedToCastValue(expectedType: T.self, givenType: type(of: value))
    }

    return val
}

private extension Single {
    /// Returns an single that invokes the specified factory function whenever a new observer subscribes.
    ///
    /// - Parameter elementFactory: Element factory function to invoke for each observer
    /// that subscribes to the resulting sequence.
    /// - Returns: A single whose observers trigger an invocation of the given element factory function.
    static func deferredJust(_ elementFactory: @escaping () throws -> Element) -> Single<Element> {
        return .create { observer in
            do {
                observer(.success(try elementFactory()))
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }
}
