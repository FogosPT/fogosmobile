num plus3(num x) => x + 3;

// final curriedAddition = (num x) => (num y) => x + y;
void curriedAddition() {
  (num x) {
    return (num y) {
      return x + y;
    };
  };
}
