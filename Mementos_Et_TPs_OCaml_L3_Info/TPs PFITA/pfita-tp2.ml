(* Partie A - Fonctions et n-uplets *)
(*Exercice A.1*)

let e1 = ((3,true),4);;
let e2 = let f n=n in (f,'s');;

(*Exercice A.2*)

let f1 1 true = (1,true);;

let f2 a = if a=a then true else false;;

let f3 a b = if a=b then 0 else 1;;

let f4 (a,b) = (b,a);;

let f5 = fun g1 -> fun g2 -> fun g3 -> fun a1 -> fun a2 -> 
  let a = fst(g1(a1)) in let b = snd(g1(a2)) in g3 (g2 a b,true);;

let f6 = fun g1 -> fun g2 -> fun a1 -> g2 a1 (g1 a1) ;; 

let f7 (a,b,x) = b(x,a(x));;

let f8 x1 x2 y1 y2 = if x1=x2 then (x1,y1) else (x2,y2) ;;

(*Exercice A.3.1*)

let cube a = a*a*a;;

let quad a = 4*a;;

let estPair a = if a mod 2 = 0 then true else false;;

let max3 a b c = if a<b then if b<c then c else b else if a<c then c else a;;

let discriminant a b c = b*b - 4*a*c;;

(*Exercice A.3.2*)

let estImpair a = not(estPair a);;

(*Exercice A.3.3*)

let choix a = if estPair a then cube a else quad a;;

(*Exercice A.3.4*)

let nbRac a b c = let delta = discriminant a b c in if delta>0 then 2 
  else if delta = 0 then 1 else 0;;

(*Exercice A.3.5*)

let nor a b = not(a || b);;

let nand a b = not(a && b);;

let xor a b = (a && not(b)) || (not(a) && b);;

(* Partie B - Récursion *)

(*Exercice B.1.1*)

let rec sommeChiffres a = if a< 0 then failwith "negatif" 
  else if a = 0 then 0 else a mod 10 +sommeChiffres(a/10);;

let rec sommeIteree n = let somme = sommeChiffres n in 
  if somme < 10 then somme else sommeIteree(somme);;

let dernierCh n = n mod 10;;

let toutSaufDer n = n/10;;

let rec premierCh n = if n < 10 then n else premierCh(n/10);;

let rec toutSaufPrem n = if n < 10 then 0 else toutSaufPrem(n/10)*10 + n mod 10;; 

let rec estPalindrome n = let debut = premierCh(n) in let fin = dernierCh(n) in
  let nvParam = toutSaufDer(toutSaufPrem(n)) in
  if debut = fin then if n<10 then true else estPalindrome(nvParam) else false;;

let rec nbOcc occ x = let der = dernierCh(x) in let reste = toutSaufDer(x) in
  if der = occ then 
    if x < 10 then 1 else nbOcc occ (reste) + 1 
  else if reste = 0 then 0 else nbOcc occ reste;; 

(*Exercice B.2*)

let rec iterer n f x = if n = 0 then x else 
    let resultat = f x in let nv = n -1 in iterer nv f resultat;;

let id x = x;;

let compose f1 f2 x = f1(f2 x);;

(*let rec iterer2 n f = if n = 0 then id else 
     let nv = n-1 in iterer2 nv compose(f id) ;;*)