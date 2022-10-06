(* Prelude - pas besoin de recopier ce code *)
type 'a liste = Nil | Cons of 'a * 'a liste
type m3 = Zero | Un | Deux






(* Partie A *)

(* 1 *)
let liste_12 = Cons (1,Cons (2, Nil));;
let liste_liste0 = Cons(Nil,Nil);;

(* 2 *)
let rec dernier l = match l with
  | Nil -> failwith "erreur"
  | Cons (x, Nil) -> x
  | Cons (x, l') -> dernier l';;

(* 3 *)
let rec append l1 l2 = match l1 with
  | Nil -> l2
  | Cons (x, l') -> Cons (x, append l' l2);;



(* Partie B.1 *)

(* 1 *)
let m3s m = match m with
  | Zero -> Un
  | Un -> Deux
  | Deux -> Zero;;

(* 2 *)
let m3p m = match m with
  | Zero -> Deux
  | Un -> Zero
  | Deux -> Un;;

(* 3 *)
let m3plus m1 m2 = match m1 with
  | Zero -> m2
  | Un -> m3s m2
  | Deux -> m3p m2;;

(* 4 *)
let m3mult m1 m2 = match m1 with
  | Zero -> m1
  | Un -> m2
  | Deux -> match m2 with
    | Zero -> Zero
    | Un -> Deux
    | Deux -> Un;;

(* 5 *)
type exp = Const of m3 | Somme of exp * exp | Produit of exp * exp;;

(* 6 *)
let rec calculer expr = match expr with
  | Const m -> m
  | Somme (m1,m2) -> m3plus (calculer m1) (calculer m2)
  | Produit (m1,m2) -> m3mult (calculer m1) (calculer m2);;

let e1 = Somme (Const Un, Const Un);;
let e2 = Produit (Const Un, Const Deux);;



(* Partie B.2 *)

(* 1 *)
type figure = Cube of int | Sphere of int | Pyramide of int;;
type mobile = Figure of figure | Tige of int * mobile * int * mobile;;

(* 2 *)
let m1 = Tige (2, Figure (Pyramide 1), 4, 
               Tige (3, Figure (Sphere 1), 4, Figure (Cube 1)));;

(* 3 *)
let m2 = Figure (Cube 1);;

(* 4 *)
let rec nbSphere m = match m with
  | Figure (Sphere _) -> 1
  | Figure (Cube _) -> 0
  | Figure (Pyramide _) -> 0
  | Tige (_, m1, _, m2) -> (nbSphere m1) + (nbSphere m2);;

(* 5 *)
let hauteur m = let rec hRec m h = match m with
    | Figure (_) -> h
    | Tige (_,m1,_,m2) -> let (h1,h2) = ((hRec m1 h+1),(hRec m2 h+1)) in
        if h1 > h2 then h1 else h2
  in hRec m 1;;

(* 6 *)
let rec echanger m f1 f2 = match m with
  | Figure f -> if f = f1 then Figure f2 else m
  | Tige (x1, m1, x2, m2) -> Tige (x1, echanger m1 f1 f2, x2, echanger m2 f1 f2);;

(* 7 *)
let rec listeFigure m = match m with
  | Figure f -> [f]
  | Tige (_,m1,_,m2) -> (listeFigure m1) @ (listeFigure m2);; 

(* 8 *)
let pi = 4. *. atan 1.;;

let masseFigure f = match f with 
  | Cube x -> float (x * x * x * 9)
  | Sphere rayon -> let r = float rayon in (pi *. r *. r *. r *. 3. *. 4.)
  | Pyramide h -> float (h * h * h * 3);;

let rec masseMobile m = match m with
  | Figure f -> masseFigure f
  | Tige (_,m1,_,m2) -> masseMobile m1 +. masseMobile m2;;

(* 9 *)
let equilibreLocal m = match m with
  | Figure _ -> true
  | Tige (x,m1,y,m2) -> (float x) *. masseMobile m1 = (float y) *. masseMobile m2 ;;

(* 10 *)
let rec equilibreGlobal m = match m with
  | Figure _ -> true
  | Tige (_,m1,_,m2) -> equilibreLocal m 
                        && equilibreGlobal m1 && equilibreGlobal m2;;

(* 11 *)
let rec mobilesEquiv m1 m2 = match (m1, m2) with
  | (Figure _, Tige _) -> false
  | (Tige _ , Figure _) -> false
  | (Figure f1, Figure f2) -> f1 = f2
  | (Tige(x1,m11,x2,m12), Tige(y1,m21,y2,m22)) ->
      (x1 = y1 && x2 = y2 && mobilesEquiv m11 m21
       && mobilesEquiv m12 m22)
      || ( x1 = y2 && x2 = y1 && mobilesEquiv m11 m22 
           && mobilesEquiv m12 m21 );;






























