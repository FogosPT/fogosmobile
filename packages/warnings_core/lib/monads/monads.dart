///
/// Based on this article: https://olexale.medium.com/dart-functors-applicatives-and-monads-in-pictures-ddd8c54bce15
///
abstract class Applicative<T> {
  Applicative<U> apply<U>(Applicative<U Function(T)> f);
}

/// Also known as Option, with Some and None sublcasses
///
/// aka Option
abstract class Maybe<T> implements Functor<T>, Applicative<T> {}

extension MaybeExtensions on Maybe {
  Just get asJust => this as Just;
}

/// aka Some
class Just<T> extends Maybe<T> {
  final T value;

  Just(this.value);

  /// Grabs the value of this object and passes to the function f and wraps it in a Just.
  ///
  /// Example:
  /// ```dart
  /// num plus3(num x) => x + 3;
  /// Just(2).fmap(plus3); // Just 5
  /// ```
  ///
  @override
  Maybe<U> fmap<U>(U Function(T) f) {
    return Just(f(value));
  }

  /// From a Functor apply triggers its fmap together with the function f.
  ///
  /// Example:
  /// ```dart
  /// Just(2).apply(Just((x) => x + 3)); // Just 5
  /// ```
  @override
  Maybe<U> apply<U>(covariant Maybe<U Function(T)> f) =>
      f.fmap((ff) => ff(value)) as Maybe<U>;
}

/// aka None
class Nothing<T> extends Maybe<T> {
  @override
  Maybe<U> fmap<U>(U Function(T) f) => Nothing();

  @override
  Applicative<U> apply<U>(Applicative<U Function(T)> f) => Nothing();
}

/// A [Functor] is any data type that defines how [fmap] applies to it.
abstract class Functor<T> {
  Functor<U> fmap<U>(U Function(T) f);
}
