bool p = false;
bool q = false;

active proctype A()
{
  p;
}

ltl l01 { [](p -> <>q) }
