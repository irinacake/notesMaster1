(* Exercice 1 - Signature *)
module type tARITH = sig
  type t
  val zero: t
  val one: t
  val add: t -> t -> t
  val mul: t -> t -> t
  val opp: t -> t
  val of_int: int -> t
  val to_string: t -> string
end;;

      


(* Exercice 2 - Modules implémentant une signature *)

module INT : tARITH = struct
  type t = int
  let zero = 0
  let one = 1
  let add = (+)
  let mul = ( * )
  let opp = (~-)
  let of_int n = n + 0
  let to_string = string_of_int 
end;;


(* récupération du type m3 défini au TP4 ainsi que des fonctions associées *)
type m3 = Zero | Un | Deux ;;
let m3s m = match m with
  | Zero -> Un
  | Un -> Deux
  | Deux -> Zero;; 
let m3p m = match m with
  | Zero -> Deux
  | Un -> Zero
  | Deux -> Un;;
let m3plus m1 m2 = match m1 with
  | Zero -> m2
  | Un -> m3s m2
  | Deux -> m3p m2;; 
let m3mult m1 m2 = match m1 with
  | Zero -> m1
  | Un -> m2
  | Deux -> match m2 with
    | Zero -> Zero
    | Un -> Deux
    | Deux -> Un;;

module M3 : tARITH = struct
  type t = m3
  let zero = Zero
  let one = Un
  let add x y = m3plus x y 
  let mul x y = m3mult x y
  let opp x = if x == zero then Zero else if x == one then Deux else Un
  let rec of_int n = let x = n mod 3 in if x == 0 then Zero else if x == 1 then Un
    else if x == 2 then Deux else opp ( of_int (-n mod 3) )
  let to_string m = if m == Zero then "0" else if m == Un then "1" else "2"
end;;

(* écriture alternative pour of_int
   let of_int n = match n mod 3 with
    | 0 -> Zero
    | 1 -> Un
    | 2 -> Deux
    | _ -> failwith "erreur internet n mod 3";;
         
*)

let checkA1 m = M3.add m (M3.opp m) == M3.zero;;
let checkA2 m = M3.mul m M3.one == m;; 
let checkA3 m n = M3.add (M3.of_int m) (M3.of_int n) == M3.of_int (m+n);;

let two = M3.add M3.one M3.one;;
let three = M3.add two M3.one;; 
let six = M3.mul two three;;

checkA1 two;;
checkA1 three;;
checkA1 six;;

checkA2 two;; 
checkA2 three;;
checkA2 six;;

checkA3 347 874;;

(* Exercice 3 - Signature paramétrée *)

(* Exercice 4 - Foncteur implémentant une signature paramétrée *)

(* Exercice 5 - Instanciation *)

(* Exercice 6 - Polynômes *)
