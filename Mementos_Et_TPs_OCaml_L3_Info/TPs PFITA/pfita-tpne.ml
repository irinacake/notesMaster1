(*
(1,false) ;;
(2., 1+4, 1=1, "salut") ;;
(('a', 1), ('b', 2), ('c', 3)) ;;
(1, 2, 3) ;;
(1, (2, 3)) ;;
((1, 2), 3) ;;
(1, 2, 3) = (2, 1, 3) ;;
(1, (2, 3)) = (1, 2, 3) ;;
*)

(* Exercice 1 *)

let f x = x +. 1. ;;
let quadruplet = (true, (1, 2), f, "salut") ;;



(* Exercice 2 *)

(* Q1 *)
let imp a b = match (a,b) with
  | (true, true) -> true
  | (true, false) -> false
  | (false, true) -> true
  | (false, false) -> true ;; 

let xor a b = match (a,b) with
  | (true, true) -> false
  | (true, false) -> true
  | (false, true) -> true
  | (false, false) -> false ;; 

(* Q2 *)
let bissextile annee = (annee mod 400 = 0)
                       || ( not (annee mod 100 = 0) && (annee mod 4 = 0) ) ;;


let nbjour (mois, annee) = match (mois, annee) with 
  | (1,_) -> 31
  | (2,_) -> if bissextile annee then 29 else 28
  | (3,_) -> 31
  | (4,_) -> 30
  | (5,_) -> 31
  | (6,_) -> 30
  | (7,_) -> 31
  | (8,_) -> 31
  | (9,_) -> 30
  | (10,_) -> 31
  | (11,_) -> 30
  | (12,_) -> 31
  | _ -> 0 ;;

(* Q3 *) 
let valide (jour, mois, annee) = (nbjour (mois, annee) <> 0) &&
                                 ( (0 < jour) && (jour <= nbjour (mois, annee)) ) ;;

(* Q4 *)
let lendemain (jour, mois, annee) = if (not (valide (jour,mois,annee))) then 
    failwith "date invalide" else if (jour <> nbjour (mois,annee)) then
    (jour+1,mois,annee) else if (mois <> 12) then (1, mois+1, annee) else (1,1,annee+1) ;;

(* Q5 *)
let veille (jour, mois, annee) = if (not (valide (jour,mois,annee))) then 
    failwith "date invalide" else if (jour <> 1) then (jour-1,mois,annee) 
  else if (mois <> 1) then (nbjour (mois-1,annee), mois-1, annee) 
  else (31,12,annee-1) ;;



(* Exercice 3 *)

(* Q1a *) 
let sec2hms ts = (ts/3600, ts/60 mod 60, ts mod 60) ;;

(* Q1b *)
let ex1 = sec2hms 3661 ;;

(* Q2a *)
let hms2sec (heures, minutes, secondes) = heures * 3600 + minutes * 60 + secondes ;;

(* Q2b *)

let sommeTemps (h1, m1, s1) (h2, m2, s2) =
  sec2hms (hms2sec (h1, m1, s1) + hms2sec (h2, m2, s2)) ;;

(* Q2c *)
let ex2 = sommeTemps (1,31,7) (2,29,54) ;;






  
  
  
  
  
  
  
  
  
  
  
  
  
  
