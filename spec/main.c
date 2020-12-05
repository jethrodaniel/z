f() {
  // we have comments
  foo = bar = 42;
  {
    foo = 10;
    baz = 10;
  }
  return foo + bar;
  return bar = 7;
}

g(){
  a = b =5;
  t = b + 5;
  foo(1, 2);
  return t+1;
}

b(x){a;{}}h(){{1;}{{{}}}}
