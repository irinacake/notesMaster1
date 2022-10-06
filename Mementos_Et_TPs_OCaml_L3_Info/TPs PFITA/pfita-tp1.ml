let estZero_v1 = fun number -> match number with
  | 0 -> "zero" ;;
                
(* si on écrit "estZero_v1 2022" on obtient 
   Exception: Match_failure ("//toplevel//", 1, 31).
*)


let estZero_v2 = fun number -> match number with
  | 0 -> "zero" 
  | _ -> "nonZero" ;;


let voyelle = fun c -> match c with
  | 'a' -> true
  | 'e' -> true
  | 'i' -> true
  | 'o' -> true
  | 'u' -> true
  | 'y' -> true
  | _ -> false ;;


(* Exercice 2 *)

(* 1 *)

let rang = fun jour -> match jour with
  | "lundi" -> 1
  | "mardi" -> 2
  | "mercredi" -> 3
  | "jeudi" -> 4
  | "vendredi" -> 5
  | "samedi" -> 6
  | "dimanche" -> 7
  | _ -> 0 ;;


(* 2 *)

let inf = fun jour1 jour2 ->  not ( rang jour1 = 0 || rang jour2 = 0 ) 
                              && ( ( rang jour1 mod 7 ) + 1 ) = ( rang jour2 ) ;;


(* 3 *)

let jsem = fun rang -> match rang with
  | 1 -> "lundi"
  | 2 -> "mardi"
  | 3 -> "mercredi"
  | 4 -> "jeudi"
  | 5 -> "vendredi"
  | 6 -> "samedi"
  | 7 -> "dimanche"
  | _ -> "jour inconnu" ;;


(* 4 *)
(* a *) 
let jourSucc1 = fun jour -> match jour with
  | "lundi" -> "mardi"
  | "mardi" -> "mercredi"
  | "mercredi" -> "jeudi"
  | "jeudi" -> "vendredi"
  | "vendredi" -> "samedi"
  | "samedi" -> "dimanche"
  | "dimanche" -> "lundi"
  | _ -> "jour inconnu" ;;


(* b *)
let jourSucc2 = fun jour -> if rang jour = 0 
  then jsem 0 else jsem ( if rang jour = 7 then 1 else ( rang jour + 1 ) ) ;;

(* c *)
let jourSucc3 = fun jour -> if rang jour = 0 
  then jsem 0 else jsem ( ( rang jour mod 7) + 1 ) ;;
  


(* 5 *)
(* a *) 
let jourPred1 = fun jour -> match jour with
  | "lundi" -> "dimanche"
  | "mardi" -> "lundi"
  | "mercredi" -> "mardi"
  | "jeudi" -> "mercredi"
  | "vendredi" -> "jeudi"
  | "samedi" -> "vendredi"
  | "dimanche" -> "samedi"
  | _ -> "jour inconnu" ;;


(* b *)
let jourPred2 = fun jour -> if rang jour = 0 
  then jsem 0 else jsem ( if rang jour = 1 then 7 else ( rang jour - 1 ) ) ;;

(* c *)
let jourPred3 = fun jour -> if rang jour = 0 
  then jsem 0 else jsem ( ( rang jour + 5 ) mod 7 + 1 ) ;;


(* 6 *)

let bissextile = fun annee -> (annee mod 400 = 0)
                              || ( not (annee mod 100 = 0) && (annee mod 4 = 0) ) ;;

(* 7 *)

let nbjour = fun mois annee -> match mois with
  | 1 -> 31
  | 2 -> if bissextile annee then 29 else 28
  | 3 -> 31
  | 4 -> 30
  | 5 -> 31
  | 6 -> 30
  | 7 -> 31
  | 8 -> 31
  | 9 -> 30
  | 10 -> 31
  | 11 -> 30
  | 12 -> 31 ;;










