bool p = false;
bool q = false;

int t = 0;

active proctype A()
{
  do
  :: t > 0 -> break;
  :: else ->
      if
      :: atomic { p = false; q = false; printf("p = %d, q = %d\n", p, q); t++; }
      :: atomic { p = false; q = true; printf("p = %d, q = %d\n", p, q); t++; }
      :: atomic { p = true; q = false; printf("p = %d, q = %d\n", p, q); t++; }
      :: atomic { p = true; q = true; printf("p = %d, q = %d\n", p, q); t++; }
      fi;
  od
}

ltl l01 { p U q }
ltl l02 { !<>(p U q) }
ltl l03 { ![](p U q) }
