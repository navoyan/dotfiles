{combinators, ...}:
with combinators; {
  unsafe-dev-bind = from: to:
    unsafe-add-raw-args "--dev-bind ${escape from} ${escape to}";
}
