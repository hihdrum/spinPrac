bool p = false;

active proctype A()
{
  p = false;
  p = true;
  p = false;
}

ltl l01 { []<>p }
