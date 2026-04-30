# Protocol Witness Patterns Reference

Detailed code examples for all six protocol witness variants. Read this file when you need full context on a specific variant or want to compare approaches for a user's scenario.

## Table of Contents

1. Basic (Stateless, Static) — line ~15
2. Instance-Bound — line ~60
3. Multiple Implementations — line ~110
4. Generic (Replacing Associated Types) — line ~145
5. Per-Type Conformance — line ~200
6. Composed Witnesses — line ~240
7. When to Use Each — line ~290

---

## 1. Basic (Stateless, Static)

The simplest form. A protocol with stateless requirements becomes a struct with closure properties. Implementations are static instances.

**Before (protocol):**

```swift
protocol CanFoo {
    func foo()
}

class FooClient {
    var fooer: CanFoo!
}
```

**After (witness):**

```swift
struct CanFoo {
    let foo: () -> Void
}

extension CanFoo {
    static let defaultFooer = CanFoo(foo: { DefaultFooer.foo() })
}

// Injection
let client = FooClient()
client.fooer = .defaultFooer
```

**When to use:** The implementation has no instance state. All behavior can be expressed as pure functions or calls to static methods.

**Tradeoffs:**
- Simplest form, easiest to understand
- Limited: can't capture per-instance state
- Good starting point; refactor to instance-bound if state is needed later

---

## 2. Instance-Bound

When the implementation needs access to a specific object's state, the factory method accepts that instance and closures capture it.

**Before (protocol):**

```swift
protocol Logging {
    func log(message: String)
}

class PrintLogger: Logging {
    func log(message: String) {
        print(message)
        logCounter += 1
    }
    var logCounter = 0
}
```

**After (witness):**

```swift
struct LoggingClient {
    func log(message: String) { _log(message) }

    private let _log: (String) -> Void

    init(log: @escaping (String) -> Void) {
        self._log = log
    }
}

extension LoggingClient {
    static func live(logger: PrintLogger) -> Self {
        Self(log: logger.log)
    }
}

// Alternative: provide from the conforming type itself
extension PrintLogger {
    var loggingClient: LoggingClient {
        LoggingClient(log: self.log)
    }
}
```

**When to use:** The implementation has mutable state or identity that matters. You need a specific instance's methods captured in the closures.

**Tradeoffs:**
- The witness captures a strong reference to the instance — be mindful of retain cycles
- Factory method makes the dependency explicit
- Instance approach (computed property on conforming type) is more analogous to traditional conformance

---

## 3. Multiple Implementations

The same type provides multiple witnesses to the same "protocol" — impossible with traditional protocol conformance.

```swift
struct CanFoo {
    let foo: () -> Void
}

class Fooer {
    func foo(debug: Bool = false) { /* ... */ }

    lazy var canFoo = CanFoo { self.foo() }
    lazy var canFooDebug = CanFoo { self.foo(debug: true) }
}

// Pick which implementation to inject
let client = FooClient()
let fooer = Fooer()
client.fooer = (debug) ? fooer.canFooDebug : fooer.canFoo
```

**When to use:** You need different behaviors from the same type for the same interface. Examples: debug vs release logging, verbose vs quiet modes, different serialization strategies.

**Tradeoffs:**
- This is a construction pattern — it applies on top of any other variant
- Traditional protocols cannot do this at all (only one conformance per type)
- Name your factories clearly to distinguish variants

---

## 4. Generic (Replacing Associated Types)

The killer feature of protocol witnesses. Instead of `associatedtype`, use generic type parameters on the struct. This avoids PAT issues entirely.

**Before (protocol with associated types):**

```swift
protocol StateMachineProtocol {
    associatedtype State
    associatedtype Event

    var state: State { get }
    func handle(event: Event)
}

// Client forced into generic hell:
class Client<SM: StateMachineProtocol>
where SM.State == OnOffState, SM.Event == OnOffEvent {
    var stateMachine: SM!
}
```

**After (witness):**

```swift
struct StateMachineClient<State, Event> {
    func state() -> State { _state() }
    func handle(event: Event) { _handleEvent(event) }

    private let _state: () -> State
    private let _handleEvent: (Event) -> Void

    init(state: @escaping () -> State, handleEvent: @escaping (Event) -> Void) {
        self._state = state
        self._handleEvent = handleEvent
    }
}

// Client is clean — no generics infection:
class Client {
    var stateMachine: StateMachineClient<OnOffState, OnOffEvent>!
}

// Factory
extension StateMachine {
    func asClient() -> StateMachineClient<State, Event> {
        StateMachineClient(
            state: { self.state },
            handleEvent: { self.handle(event: $0) }
        )
    }
}
```

**When to use:** The original protocol has `associatedtype` declarations. You're hitting "Protocol can only be used as a generic constraint" errors. The client shouldn't need to be generic.

**Tradeoffs:**
- Eliminates PAT issues completely
- Client code is dramatically cleaner
- Slightly more boilerplate in the witness definition
- The real win: you can store witnesses in arrays, optionals, and properties without type erasure

---

## 5. Per-Type Conformance

Using `where` clauses on extensions to provide type-specific static witnesses. This enables "one protocol, many type-specific implementations" which is impossible with traditional protocols.

```swift
struct Converting<From, To> {
    func convert(_ value: From) -> To { _convert(value) }

    private let _convert: (From) -> To

    init(convert: @escaping (From) -> To) {
        self._convert = convert
    }
}

extension Converting where From == Int, To == String {
    static let intToString = Self { "\($0)" }
}

extension Converting where From == Int, To == Float {
    static let intToFloat = Self { Float($0) }
}

extension Converting where From == String, To == Data {
    static let utf8 = Self { $0.data(using: .utf8)! }
}

// Usage
let s: String = Converting.intToString.convert(42) // "42"
let f: Float = Converting.intToFloat.convert(42)   // 42.0
```

**When to use:** You want the same generic witness to have different named implementations for different type combinations. Traditional protocols only allow one conformance per type.

**Tradeoffs:**
- Very expressive for conversion, serialization, comparison operations
- Static factories are discoverable via autocomplete
- Can get verbose if you have many type combinations

---

## 6. Composed Witnesses

Protocol inheritance → struct composition. Instead of `protocol B: A`, embed a witness of `A` inside `B`.

```swift
struct Equating<T> {
    func equals(_ lhs: T, _ rhs: T) -> Bool { _equals(lhs, rhs) }

    private let _equals: (T, T) -> Bool

    init(equals: @escaping (T, T) -> Bool) {
        self._equals = equals
    }
}

extension Equating where T: Equatable {
    static var `default`: Self { Self(equals: ==) }
}

struct Hashing<T> {
    let equating: Equating<T>

    func hashValue(for value: T) -> Int { _hashValue(value) }

    private let _hashValue: (T) -> Int

    init(equating: Equating<T>, hashValue: @escaping (T) -> Int) {
        self.equating = equating
        self._hashValue = hashValue
    }
}

extension Hashing where T: Hashable {
    static var `default`: Self {
        Self(equating: .default, hashValue: { $0.hashValue })
    }
}
```

**When to use:** You have a protocol hierarchy where child protocols extend parent protocols. The composed witness makes the relationship explicit.

**Tradeoffs:**
- Composition over inheritance — more explicit about what's included
- Forces you to specify which equating/sub-witness to use (more verbose but more explicit)
- Consider flattening if the composition adds complexity without value
- Sometimes it's better to just include all closures in one struct (flat approach)

---

## 7. When to Use Each

| Scenario | Recommended Variant |
|---|---|
| Simple stateless dependency (e.g., formatter, validator) | Basic (stateless) |
| Dependency with internal state (e.g., logger, cache, connection pool) | Instance-bound |
| Same type needs different behaviors for same interface | Multiple implementations |
| Protocol has `associatedtype` or causes "can only be used as generic constraint" | Generic |
| Want type-specific named conversions/operations | Per-type conformance |
| Modeling protocol hierarchy (A extends B) | Composed |
| Dependency used across actors/tasks | Any variant + `@Sendable` + `Sendable` struct |
| Need test doubles | Any variant + `.mock`/`.noop`/`.unimplemented` factories |

### Decision Flow

1. **Does it have associated types?** → Generic witness
2. **Does it capture instance state?** → Instance-bound factory
3. **Does it need multiple behaviors?** → Named factory variants
4. **Does it extend another witness?** → Composed
5. **None of the above?** → Basic stateless

Remember: these are combinable. A witness can be generic + instance-bound + composed + async. Pick from each axis independently.
