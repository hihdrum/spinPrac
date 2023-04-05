bool p = true;

active proctype A()
{
  p;
  p = false;
}

ltl l01 { p }
