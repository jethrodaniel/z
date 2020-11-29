// functions called here are assumed to be defined elsewhere

f(); // it'd be nice to drop the parens for no/default args, like HolyC

a = b = 5;
b = b + 1;

g(24, 18); // 42
g(1, 2);   // 3
g(3, 4);   // 7
g(a, b);   // 11

f();
f();
