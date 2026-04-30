---
name: swift-protocol-witness
description: Helps design and generate Swift protocol witness structs (struct-based alternatives to protocols using closure properties). Use when asked to 'convert a protocol to a witness', 'create a protocol witness', 'replace protocol with struct of closures', 'closure-based dependency', 'dependency client', 'PointFree-style client', or 'PAT workaround'. Also triggers on 'protocol with associated type' problems or questions about testable Swift dependencies using struct-based DI. Do NOT use for general Swift protocol questions, protocol-oriented programming, delegate/data-source patterns, Combine publishers, or framework-required conformances (Codable, Sequence, View, etc.).
license: CC-BY-4.0
metadata:
  author: Michael Robinson
  version: 1.0.0
---

# Swift Protocol Witness

Generate and guide the design of Swift protocol witness structs — struct-based dependency abstractions that replace traditional protocols with closure properties and static factory methods.

## When NOT to Use Protocol Witnesses

Before proceeding, check if a traditional protocol is actually the better fit. Recommend staying with protocols when:

- **Framework conformance is required** — SwiftUI `View`, `Codable`, `Sequence`, `Identifiable`, UIKit delegates, Obj-C interop
- **Public extension points** — third-party consumers need to conform with their own types
- **`Self` or initializer requirements** — the protocol relies on `Self` semantics or `init` requirements that don't map to closures
- **Retroactive conformance** — you need to conform existing types you don't own
- **Single, obvious implementation** — no testability or flexibility benefit

If any of these apply, tell the user and suggest keeping the protocol. Only proceed with a witness when the pattern genuinely adds value (testability, multiple implementations, avoiding PAT issues, composability).

## Instructions

### Step 1: Ask Clarifying Questions

Before generating code, ask 1-3 of these questions based on what's unclear from context:

1. **Mode:** Are you converting an existing protocol, or designing a new dependency from scratch?
2. **State:** Does the implementation need to capture mutable instance state, or are operations stateless/pure?
3. **Effects:** Do any operations need `async`, `throws`, or `async throws`? Should closures be `@Sendable`?
4. **Types:** Does the protocol have associated types or generics? (If converting, look at the source.)
5. **Composition:** Does this witness need to compose other witnesses (like Hashable composes Equatable)?

Skip questions you can infer from context (e.g., if the user pastes a protocol with `associatedtype`, don't ask about generics).

### Step 2: Select Along Each Axis

Protocol witnesses combine independent design dimensions. Select one option from each axis:

**Axis 1 — State Model:**
- **Stateless** — All closures are pure or only reference external state. Use a simple struct with closure properties.
- **Captured instance** — Closures capture a specific object instance (e.g., a database connection). Factory methods accept the instance as a parameter.
- **Boxed mutable state** — The witness itself holds mutable state. Use a `class`-backed box or `@unchecked Sendable` wrapper if concurrency is needed.

**Axis 2 — Effect Model:**
- **Sync** — `(Args) -> Result`
- **Throws** — `(Args) throws -> Result`
- **Async** — `(Args) async -> Result`
- **Async throws** — `(Args) async throws -> Result`
- Mark closures `@Sendable` when the witness will be shared across concurrency domains. Omit `@Sendable` for main-actor-only or single-threaded usage.

**Axis 3 — Type Model:**
- **Concrete** — No generics. Closure types use specific types directly.
- **Generic** — The witness struct has type parameters replacing associated types. Use `struct Fetching<T>` instead of `protocol Fetching { associatedtype T }`.
- **Constrained** — Generic with `where` clauses providing type-specific factories.

**Axis 4 — Composition Model:**
- **Standalone** — Single witness, no nested dependencies.
- **Composed** — Witness embeds other witness structs as properties (analogous to protocol inheritance).
- **Flat** — Merge all operations into one struct even if they could be separated (simpler API, less flexible).

**Axis 5 — Construction Model (Factories):**
- `.live` — Production implementation
- `.mock(...)` — Configurable test double (closures accept overrides with sensible defaults)
- `.noop` — All closures do nothing / return defaults (for previews, lightweight tests)
- `.unimplemented` — All closures fatal error with a message (catches accidental usage in tests)
- `.failing` — Alias for unimplemented with XCTest integration

### Step 3: Generate the Code

Output the following in order:

1. **Witness struct** — with stored closure properties (private underscore-prefixed) and public API methods with labeled parameters
2. **Factory methods** — `.live`, `.mock`, `.noop`, `.unimplemented` as appropriate
3. **Usage example** — showing injection and call-site
4. **Call-site migration** (for conversions only) — before/after at the injection point

Use this template structure:

```swift
// MARK: - Witness Struct

struct [Name] {
    // Public API with labeled parameters
    // Private closure storage
}

// MARK: - Live Implementation

extension [Name] {
    static func live(...) -> Self { ... }
}

// MARK: - Test Doubles

extension [Name] {
    static let noop = Self(...)
    static let unimplemented = Self(...)
    static func mock(...) -> Self { ... }
}
```

### Step 4: For Conversions — Apply the Conversion Checklist

When converting an existing protocol, map each element:

| Protocol Element | Witness Equivalent |
|---|---|
| `func name(label: Type) -> Return` | `var _name: (Type) -> Return` + `func name(label: Type) -> Return { _name(arg) }` |
| `var name: Type { get }` | `var _name: () -> Type` + `var name: Type { _name() }` |
| `var name: Type { get set }` | Pair of closures: `_getName: () -> Type` and `_setName: (Type) -> Void`, or use boxed mutable state |
| `mutating func` | Boxed mutable state pattern (class wrapper or inout closure) |
| `associatedtype T` | Generic type parameter on the struct |
| `Self` requirement | Often not a good witness candidate — flag to user |
| `init(...)` | Factory method parameter or separate factory witness |
| Default implementations | Move into shared helper functions called by factories |
| `async` / `throws` | Preserve in closure signature |
| `@MainActor` | Apply to the struct or specific closures as needed |

After generating, note anything that **cannot be preserved exactly** and explain the tradeoff.

## Style Conventions

- **Naming:** Use PointFree-style verb/gerund names: `Fetching`, `Logging`, `Routing` — or noun-based: `APIClient`, `DatabaseClient`
- **Sendable:** Add `@Sendable` to closures when the witness crosses concurrency domains. Make the struct itself `Sendable` when all closures are `@Sendable`.
- **Labels:** Wrap closures in methods to preserve Swift's labeled parameter ergonomics.
- **Access control:** Default to `public` struct + `public` API methods + `private` closure storage for library code. Use `internal` for app-level witnesses.
- **File organization:** One witness per file. Name the file after the witness struct.

## Examples

### Example 1: Converting a simple protocol (stateless, sync)

User says: "Convert this protocol to a protocol witness"

```swift
protocol NetworkSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}
```

**Clarifying question:** "Does the implementation need to capture a specific URLSession instance, or should it be configurable per-call?"

**Result (instance-bound, async throws, concrete):**

```swift
struct NetworkSessionClient: Sendable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await _data(request)
    }

    private let _data: @Sendable (URLRequest) async throws -> (Data, URLResponse)

    init(data: @escaping @Sendable (URLRequest) async throws -> (Data, URLResponse)) {
        self._data = data
    }
}

extension NetworkSessionClient {
    static func live(session: URLSession = .shared) -> Self {
        Self { request in
            try await session.data(for: request)
        }
    }
}

extension NetworkSessionClient {
    static let noop = Self(data: { _ in (Data(), URLResponse()) })

    static let unimplemented = Self(data: { _ in
        fatalError("NetworkSessionClient.data is unimplemented")
    })

    static func mock(returning data: Data, response: URLResponse = URLResponse()) -> Self {
        Self(data: { _ in (data, response) })
    }
}
```

### Example 2: Generic witness replacing associated type

User says: "I have a protocol with an associated type for a repository pattern, help me make it a witness"

```swift
protocol Repository {
    associatedtype Model: Identifiable
    func fetchAll() async throws -> [Model]
    func fetch(id: Model.ID) async throws -> Model?
    func save(_ model: Model) async throws
    func delete(id: Model.ID) async throws
}
```

**Result (generic, async throws, standalone):**

```swift
struct RepositoryClient<Model: Identifiable & Sendable>: Sendable {
    func fetchAll() async throws -> [Model] { try await _fetchAll() }
    func fetch(id: Model.ID) async throws -> Model? { try await _fetchByID(id) }
    func save(_ model: Model) async throws { try await _save(model) }
    func delete(id: Model.ID) async throws { try await _delete(id) }

    private let _fetchAll: @Sendable () async throws -> [Model]
    private let _fetchByID: @Sendable (Model.ID) async throws -> Model?
    private let _save: @Sendable (Model) async throws -> Void
    private let _delete: @Sendable (Model.ID) async throws -> Void

    init(
        fetchAll: @escaping @Sendable () async throws -> [Model],
        fetch: @escaping @Sendable (Model.ID) async throws -> Model?,
        save: @escaping @Sendable (Model) async throws -> Void,
        delete: @escaping @Sendable (Model.ID) async throws -> Void
    ) {
        self._fetchAll = fetchAll
        self._fetchByID = fetch
        self._save = save
        self._delete = delete
    }
}

extension RepositoryClient where Model == User {
    static func live(database: Database) -> Self {
        Self(
            fetchAll: { try await database.fetchAll(User.self) },
            fetch: { try await database.fetch(User.self, id: $0) },
            save: { try await database.save($0) },
            delete: { try await database.delete(User.self, id: $0) }
        )
    }
}
```

### Example 3: Composed witnesses

User says: "I need a witness that composes equating and hashing like Hashable extends Equatable"

**Result (composed, sync, generic):**

```swift
struct Equating<T>: Sendable {
    func equals(_ lhs: T, _ rhs: T) -> Bool { _equals(lhs, rhs) }

    private let _equals: @Sendable (T, T) -> Bool

    init(equals: @escaping @Sendable (T, T) -> Bool) {
        self._equals = equals
    }
}

extension Equating where T: Equatable {
    static var `default`: Self { Self(equals: ==) }
}

struct Hashing<T>: Sendable {
    let equating: Equating<T>

    func hashValue(for value: T) -> Int { _hashValue(value) }

    private let _hashValue: @Sendable (T) -> Int

    init(equating: Equating<T>, hashValue: @escaping @Sendable (T) -> Int) {
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

## Troubleshooting

### "Should I use a protocol witness or a protocol here?"

Use the guardrails at the top of this document. The key question: **do you need multiple implementations, testability without mocking frameworks, or are you hitting PAT compiler errors?** If yes → witness. If no → protocol is fine.

### Closures lose parameter labels

This is expected. Wrap closure calls in methods with labeled parameters to restore ergonomics. See the `_data`/`data(for:)` pattern in Example 1.

### Mutable state in witnesses

If you need mutable state, either:
1. Capture a reference type (class) in your `.live` factory
2. Use a class-backed box inside the struct
3. Use `@unchecked Sendable` if you manage synchronization manually

Avoid making the witness struct itself mutable — prefer capturing state externally.

### Sendable conformance issues

Not all witnesses need `@Sendable`. Only add it when:
- The witness is stored in an actor or passed across isolation boundaries
- It's used in structured concurrency (`Task {}`, `TaskGroup`)
- Multiple concurrent callers may invoke it

For main-actor-only code, skip `@Sendable` to avoid unnecessary complexity.

## References

For detailed code examples of all six protocol witness variants with full explanations, read `references/patterns.md`. Consult it when:
- You need to see the progression from basic to advanced variants
- The user asks about a specific variant you want to verify
- You want additional context on tradeoffs between approaches
