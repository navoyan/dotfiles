{combinators, ...}:
with combinators; {
  fake-machine-id = ro-bind "/run/jail/fake-machine-id" "/etc/machine-id";
}
