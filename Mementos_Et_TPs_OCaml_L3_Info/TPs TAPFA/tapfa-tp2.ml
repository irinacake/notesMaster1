(* Prelude - pas besoin de recopier ce code *)
type elem = Obstacle | Objet | Rien
type plateau = (int * int) -> elem
type etat_pince = Vide | Pleine





(* Exercice 1 *)

type prop = Contient of elem | Pince_est_vide
          | Andp of prop * prop | Notp of prop;;

let contient e = Contient (e);;
let pince_est_vide = Pince_est_vide;;
let andp p1 p2 = Andp (p1,p2);; 
let notp p = Notp (p);;

let some_prop = andp (contient Objet) pince_est_vide;;


let it_prop = fun fC -> fun fP -> fun fA -> fun fN
  -> let rec trait p = match p with
      | Contient e -> fC e
      | Pince_est_vide -> fP
      | Andp (p1,p2) -> fA p1 p2 (trait p1) (trait p2)
      | Notp p -> fN p (trait p)
    in trait;;





(* Exercice 2 *)

type etat = Etat of plateau * (int * int) * etat_pince * (int * int);;
(* pas de type somme, il n'y a pas plusieurs constructeurs *)


let mk_etat pla posRobot ep dirRobot = Etat (pla,posRobot,ep,dirRobot);;


let get_plateau e = let Etat (pla,_,_,_) = e in pla;;
let get_position e = let Etat (_,posRobot,_,_) = e in posRobot;;
let get_pince e = let Etat (_,_,ep,_) = e in ep;;
let get_direction e = let Etat (_,_,_,dirRobot) = e in dirRobot;;






(* Exercice 3 *)

let eval e = let Etat (plat,posRobot,etatPince,dirRobot) = e
  in it_prop
    (fun e' -> e' = plat posRobot)
    (etatPince = Vide)
    (fun p1 p2 b1 b2 -> b1 && b2)
    (fun p' b' -> not b');;
  




(* Exercice 4 *)

let prendreCase e = match e with
  | Objet -> Rien
  | _ -> failwith "erreur";;

let prendreA plat pos = let e = prendreCase (plat pos) in 
  (fun (x,y) -> if pos = (x,y) then e else plat (x,y));;

let etatPrendre e = let Etat (pla,posRobot,ep,dirRobot) = e
  in if ep = Pleine then failwith "pince déjà pleine" else
  if pla posRobot <> Objet then failwith "case vide ou obstacle" else
    Etat (prendreA pla posRobot, posRobot, Pleine, dirRobot);;




(* Exercice 5 *)

let poserCase e = match e with
  | Rien -> Objet
  | _ -> failwith "erreur";;

let poserA plat pos = let e = poserCase (plat pos) in 
  (fun (x,y) -> if pos = (x,y) then e else plat (x,y));;

let etatPoser e = let Etat (pla,posRobot,ep,dirRobot) = e
  in if ep = Vide then failwith "pince vide" else
  if pla posRobot <> Rien then failwith "la case n'est pas vide" else
    Etat (poserA pla posRobot, posRobot, Vide, dirRobot);;



(* Exercice 6 *)

let etatTourner e = let Etat (plat,posRobot,etatPince,dirRobot) = e
  in let newDir = 
       match dirRobot with
       | (1,0)  -> (0,1)
       | (0,1)  -> (-1,0)
       | (-1,0) -> (0,-1)
       | (0,-1) -> (1,0)
       | _ -> failwith "unexpected direction"
  in Etat (plat,posRobot,etatPince,newDir);;

let etatTourner e = let Etat (plat,posRobot,etatPince,(x,y)) = e
  in Etat (plat,posRobot,etatPince,(-y,x));;


let etatAvancer e = let Etat (plat,(x,y),etatPince,(a,b)) = e
  in let newPos = (x+a,y+b)
  in if plat newPos = Obstacle then failwith "avancée pas possible"
  else Etat (plat,newPos,etatPince,(a,b));;



(* Exercice 7 *)


type commande = 
  | Prendre
  | Poser
  | Tourner
  | Avancer
  | If_prop of commande * prop
  | Seq of commande list;;

let prendre = Prendre;;
  
let poser = Poser;;
  
let tourner = Tourner;;
  
let avancer = Avancer;;
  
let if_prop cmd p = If_prop (cmd,p);;
  
let seq cmdL = Seq cmdL;; 



let rec executer etat cmd = match cmd with 
  | Prendre -> etatPrendre etat
  | Poser -> etatPoser etat
  | Tourner -> etatTourner etat
  | Avancer -> etatAvancer etat
  | If_prop (c,p) -> if eval etat p then executer etat c else etat
  | Seq cmdL -> (match cmdL with
      | [] -> etat
      | c :: cmdL' -> let newE = executer etat c in executer newE (Seq cmdL'))
;;
    

let rec executer2 etat cmd = match cmd with 
  | Prendre -> etatPrendre etat
  | Poser -> etatPoser etat
  | Tourner -> etatTourner etat
  | Avancer -> etatAvancer etat
  | If_prop (c,p) -> if eval etat p then executer2 etat c else etat
  | Seq cmdL -> List.fold_left executer2 etat cmdL
;;

















