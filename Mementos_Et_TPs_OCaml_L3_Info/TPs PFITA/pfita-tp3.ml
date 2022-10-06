(* Partie A *)

(* predicat unaire juste pour aller plus vite dans les tests *)
let p x = x > 5;;

(* Exercice A.1 *)

(* 1 *) 
let rec filter p liste = match liste with
  | [] -> []
  | x :: l -> if p x then x :: filter p l else filter p l;;

(* 2 *)
let rec forall p liste = match liste with
  | [] -> true
  | x :: l -> p x && forall p l;;

(* 3 *)
let rec exists p liste = match liste with
  | [] -> false
  | x :: l -> p x || exists p l;;


(* Exercice A.2 *) 

(* 0 *)
let fst (a,b) = a;;
let snd (a,b) = b;;

(* 1 *)
let rec estFonction liste = match liste with
  | [] -> true
  | (x,y) :: l -> not (exists (fun (a,b) -> a = x) l) && estFonction l;;

(* 2 *)
let rec image e liste = match liste with
  | [] -> failwith "l'element n'a pas d'image"
  | (a,b) :: l -> if a = e then b else image e l;;

(* 3 *) 
let rec imageEns listelem listef = match listelem with
  | [] -> []
  | a :: newlistelem -> (image a listef) :: (imageEns newlistelem listef);;
  
(* 4 *)
let rec estInjective liste = match liste with
  | [] -> true
  | (x,y) :: l -> not (exists (fun (a,b) -> b = y) l) && estInjective l;;

(* 5 *)
let rec surcharge f1 f2 = match f1 with 
  | [] -> if f2 = [] then [] else surcharge f2 []
  | (x,y) :: f -> if (exists (fun (a,b) -> a = x) f2) then surcharge f f2
      else (x,y) :: surcharge f f2;;

let isDef x f = exists (fun (a,b) -> a = x) f;;
(* 6 *)
let rec composition f1 f2 = match f2 with 
  | [] -> []
  | (x,y) :: f -> if isDef y f1 then
        (x,image y f1) :: composition f1 f else composition f1 f;;

(* 7 *)
let rec produit f1 f2 =
  let rec sousProduit (x,y) f2 = match f2 with
    | [] -> []
    | (x2,y2) :: f2' -> ((x,x2),(y,y2)) :: sousProduit (x,y) f2' in 
  match f1 with 
  | [] -> []
  | (x1,y1) :: f1' -> 
      surcharge (sousProduit (x1,y1) f2) (produit f1' f2) ;;


(* Exercice B.1 *)

(* 1 *) 
let liste3elem = 10 :: 20 :: 30 :: [];;
let liste3elemV2 = [10 ; 20 ; 30];;

(* 2 *)
let head l = match l with 
  | [] -> failwith "liste vide"
  | x :: l' -> x;;
let tail l = match l with
  | [] -> failwith "liste vide"
  | x :: l' -> l';;

(* 3 *)
let troisemeElem l = head (tail (tail l));;



(* Exercice B.2 *)

(* 
let un = [];;
val un : 'a list = []

let deux = [1;2;true];;
Error: This expression has type bool but an expression was expected of type int

let trois = [1;(2,true)];;
Error: This expression has type 'a * 'b but an expression was expected of type int

let quatre = [1,2,3];;
val quatre : (int * int * int) list = [(1, 2, 3)]
                                      
let cinq = [[1,2];[3,4]];;
val cinq : (int * int) list list = [[(1, 2)]; [(3, 4)]]

let six = [[1,2];[3,4,5]];;
Error: This expression has type 'a * 'b * 'c but an expression was expected of type
  int * int

let sept = [1;2;3];;
val sept : int list = [1; 2; 3]
                      
let huit = [(1,true,5.0);(2,false,6.4);(3,true,7.9)];;
val huit : (int * bool * float) list =
           [(1, true, 5.); (2, false, 6.4); (3, true, 7.9)]
           
let neuf = ([1;2;3],[[];[true,false]]);;
val neuf : int list * (bool * bool) list list =
           ([1; 2; 3], [[]; [(true, false)]]) 

*)



(* Exercice B.3 *) 

let rec consCpleDouble n = if n <= 0 then []
  else (n, 2*n) :: consCpleDouble (n-1);;



(* Exercice C.1 *) 

let rec hanoi n (t1,t2,t3) = if n <= 0 then [] else
    (hanoi (n-1) (t1,t3,t2)) @ [(t1,t3)] @ (hanoi (n-1) (t2,t1,t3));;




(* Exercice C.2 *) 

(* 1 *)
let rec inserer e l = match l with
  | [] -> [e]
  | x :: [] -> if e > x then [x ; e]
      else [e ; x]
  | x :: l' -> if e > x then x :: (inserer e l')
      else e :: x :: l' ;;

let triInsertion l = 
  let rec recTriInsertion l newL = match l with
    | [] -> newL
    | x :: l' -> recTriInsertion l' (inserer x newL)
  in recTriInsertion l [];;

(* 2 *)
let partage l = 
  let rec recPartage l l1 l2 = match l with
    | [] -> (l1 , l2)
    | x :: [] -> (x :: l1 , l2)
    | x :: y :: l' -> recPartage l' (x :: l1) (y :: l2)
  in recPartage l [] [];;

let rec merge l1 l2 = match (l1, l2) with
  | ([],[]) -> []
  | ([], x :: l2') -> x :: merge l1 l2'
  | (x :: l1', []) -> x :: merge l1' l2
  | (x :: l1', y :: l2') -> if x < y then
        x :: merge l1' l2 else y :: merge l1 l2' ;;

let rec triFusion l = match l with
  | [] -> [] 
  | [x] -> l
  | _ -> let (l1,l2) = partage l in
      merge (triFusion l1) (triFusion l2) ;;



(* Exercice C.3 *) 

(* 1 *)
let rec last l = match l with
  | [] -> failwith "liste vide"
  | x :: [] -> x
  | _ :: l' -> last l';;

(* 2 *)
let sum l =
  let rec sumN l n = match l with
    | [] -> n
    | x :: l' -> sumN l' (n+x)
  in sumN l 0;;

(* 4 *)
let rec append l1 l2 = match l1 with
  | [] -> l2
  | x :: l -> x :: append l l2;;

(* 4 *)
let reverse l = 
  let rec recReverse l1 l2 = match l1 with
    | [] -> l2
    | x :: l1' -> recReverse l1' (x :: l2)
  in recReverse l [];;

(* 5 *)
let nbOcc x l =
  let rec recOcc x l n = match l with
    | [] -> n
    | y :: l' -> recOcc x l' (if x=y then n+1 else n)
  in recOcc x l 0;;

(* 6 *)
let elimFirst e l =
  let rec elim e leftL rightL = match rightL with
    | [] -> leftL
    | x :: rightL' -> if (e=x) then leftL @ rightL'
        else elim e (leftL @ [x]) rightL'
  in elim e [] l;;

(* 7a *)
let rec elimLast1 e l = match l with
  | [] -> []
  | x :: l' -> if exists (fun a -> a = x) l' then x :: elimLast1 e l'
      else if (x = e) then elimLast1 e l' else x :: elimLast1 e l';;

(* 7b *)
let elimLast2 e l = reverse (elimFirst e (reverse l));; 

(* 8 *)
let elim e l =
  let rec recElim e leftL rightL = match rightL with
    | [] -> leftL
    | x :: rightL' -> if (e=x) then recElim e leftL rightL'
        else recElim e (leftL @ [x]) rightL'
  in recElim e [] l;;

(* 9 *)
let substitute x y l =
  let rec recSubstitute x y leftL rightL = match rightL with
    | [] -> leftL
    | e :: rightL' -> if (e = x) then recSubstitute x y (leftL @ [y]) rightL'
        else recSubstitute x y (leftL @ [e]) rightL'
  in recSubstitute x y [] l;;

(* 10 *)
let substitute2 p x l =
  let rec recSubstitute2 p x leftL rightL = match rightL with
    | [] -> leftL
    | e :: rightL' -> if p e then recSubstitute2 p x (leftL @ [x]) rightL'
        else recSubstitute2 p x (leftL @ [e]) rightL'
  in recSubstitute2 p x [] l;;









