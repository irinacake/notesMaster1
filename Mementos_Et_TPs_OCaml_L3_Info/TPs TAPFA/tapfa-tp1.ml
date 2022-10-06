let hd l = match l with
  | x :: _ -> x
  | _ -> failwith "erreur";;

let tl l = match l with
  | _ :: l' -> l'
  | _ -> failwith "erreur";;




(* Exercice 1 *)

let rec tete m = match m with
  | [] -> []
  | x :: m' -> hd x :: tete m';;

let rec reste m = match m with
  | [] -> []
  | x :: m' -> tl x :: reste m';;

let rec trans m = if m = [] || hd m = [] 
  then []
  else tete m :: trans (reste m);;



(* Exercice 2 *)

let rec map f l = match l with 
  | [] -> []
  | x :: l' -> f x :: map f l';;
(* val map : ('a -> 'b) -> 'a list -> 'b list = <fun> *)

let tete2 m = map hd m;;

let reste2 m = map tl m;;


let rec ligzero n = if n <= 0 then [] else 0 :: ligzero (n-1);;

let zero n = map ligzero (map (fun x -> x + n) (ligzero n));;


(** idée :
  *  - la fonction "ligne" génère un ligne de 
  *    la matrice contenant un 1 au milieu 
  *    selon les paramètres "taille à gauche"
  *    et "taille à droite"
  *  - la nested fonction génère une à une ces
  *    lignes tant qu'elles n'ont pas toutes 
  *    été faites
  **)
let unite n = if n = 0 then []
  else
    let rec uniteRec n mid = match mid with
      | 0 -> []
      | _ -> ligne (n-mid) (mid-1) :: uniteRec n (mid-1)
    and ligne g d = ligzero g @ 1 :: ligzero d
    in uniteRec n n;;




(* Exercice 3 *)

let rec map2 f l1 l2 = match l1,l2 with 
  | [],[] -> []
  | x :: l1', y :: l2' -> f x y :: map2 f l1' l2'
  | _,_ -> failwith "erreur";;


let somlig l1 l2 = map2 (fun x y -> x+y) l1 l2;;


let add m1 m2 = map2 somlig m1 m2;;




(* Exercice 4 *)

let rec prodligcol l c = match l,c with
  | [],[] -> 0
  | x :: l', y :: c' -> x*y + prodligcol l' c'
  | _,_ -> failwith "erreur";;

let prodligtmat l tm = map (prodligcol l) tm;;


(* Je ne vois pas comment effectuer une application partielle
   sans inverser les deux arguments *)
let prodligtmat2 tm l = prodligtmat l tm

let prod m1 m2 = map (prodligtmat2 (trans m2)) m1;;





(* Exercice 5 *)

let create f n =
  let rec create2 f i n = 
    if i = n then [ f n ]
    else f i :: create2 f (i+1) n
  in if n <= 0 then [] else create2 f 1 n;;


let couples n =
  let ligneCouple i p = create (fun x -> (i,x)) p
  in create (fun x -> ligneCouple x n) n;;


let zero2 n = create (fun _ -> create (fun _ -> 0) n) n;;


let unite2 n = create (fun x -> create (fun y -> if y = x then 1 else 0) n) n;;











