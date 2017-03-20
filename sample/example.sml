val foo = 42
infixr 0 $
fun f $ x = f x
fun println s = print $ s ^ "\n"

(* 'fun' is different color from 'val' *)
fun bar x = x * foo

(* Use :SMLTypeQuery to look up the types of identifiers: *)
fun thirdElem (xs : 'a list) = List.nth (xs, 3)
(* Also, type variables are colored like types *)
(* and they're concealled if your cursor isn't on the line *)
fun identity (x : 'a) = x

(* 'fn' is concealled with 'λ.' *)
val addOne = fn x => x + 1
(* ... and '=>' is styled as one operator, not '=' and '>' *)

(* 'o' is styled like '∘' *)
val _ = println o Int.toString o valOf $ SOME 42
(* ... and '$' stands out in a different color *)

val five = addOne "4"
