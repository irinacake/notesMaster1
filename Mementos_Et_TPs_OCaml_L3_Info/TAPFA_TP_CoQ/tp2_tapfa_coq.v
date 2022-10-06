(* Rappel syntaxe Coq : les commentaires s'écrivent entre (* et *). *)

(* TAPFA - Partie Coq - TP 2 *)

(* Rappel de l'URL des supports de Cours :

   https://pfitaxel.github.io/tapfa-coq-alectryon/ *)

(* N'hésitez pas à solliciter votre encadrant de TP sur Discord
   pour toute question. *)

(* Pour évaluer les phrases dans Emacs+ProofGeneral :
   - aller jusqu'au curseur en faisant "C-c RET" (<=> Ctrl+C Entrée)
     ou "C-c C-RET"
   - avancer/reculer d'un cran avec "C-c C-n" et "C-c C-u"
   - et pour aller à la fin de la zone validée, faire "C-c C-."

  Pour évaluer les phrases dans l'éditeur en ligne,
  utiliser les trois boutons adéquats (ou Alt+N, Alt+P, Alt+Entrée) *)

(******************************************)
(* Retour sur la logique propositionnelle *)
(******************************************)

Section PremieresTactiques.

(* Dans cette section, supposons trois propositions A, B et C *)
Variables A B C : Prop.

(* On pourrait faire toutes nos preuves en écrivant des fonctions du
   bon type, comme au TP 1, mais ça devient vite inhumain ; Coq
   propose donc un mode interactif dans lequel il va nous aider à
   construire les preuves étape par étape (d'où le nom d'assistant de
   preuve). *)

Lemma ex0 : B -> B.
(* au lieu de Lemma, on pourrait utiliser les synonymes Theorem,
Remark, Corollary, Fact, Example *)
Proof.
(* on démarre une preuve interactive *)
(* on tape maintenant des tactiques qui vont modifier les sous buts à
prouver jusqu'à ce qu'il n'en reste plus *)
intros Hb.
(* notre première tactique, on bouge l'hypothèse B et on lui donne le nom Hb *)
(* Hb a pour type B cad que Hb est une preuve de B *)
apply Hb.
(* notre deuxième tactique, on utilise B *)
Qed.
(* Quod Erat Demonstrandum, CQFD en latin, on enregistre et vérifie la preuve *)

(* en fait, ici Coq sait se débrouiller tout seul *)
Lemma ex0' : B -> B.
Proof. auto. Qed.

(* refaire les preuves précédentes en utilisant les tactiques intros et apply *)
Lemma ex1 : A -> B -> A.
Proof.
(* ... (à compléter) *)
Admitted.

Lemma ex2 : A -> B -> B.
Proof.
(* ... (à compléter) *)
Admitted.

(*
  Pour ex3, on remarquera que le type de la 2eme hypothese introduite est
  un type fonctionnel. Il est donc possible d'appliquer la fonction sur un
  argument de type A pour obtenir un B.
  En déduire 2 preuves différentes de ex3', en utilisant la tactique apply
  une seule fois ou bien deux fois.
  On notera (Print ex3_Vi) que le terme construit est le même.
*)
Lemma ex3_V1 : A -> (A -> B) -> B.
Proof.
(* ... (à compléter) *)
Admitted.

Lemma ex3_V2 : A -> (A -> B) -> B.
Proof.
(* ... (à compléter) *)
Admitted.

Lemma ex4 : (A -> B) -> (B -> C) -> A -> C.
Proof.
(* ... (à compléter) *)
Admitted.

Lemma ex5 : (A -> B) -> (A -> B -> C) -> A -> C.
Proof.
(* ... (à compléter) *)
Admitted.

(* en présence de plusieurs sous-buts, on peut utiliser des accolades
   pour les délimiter *)
Lemma ex5' : (A -> B) -> (A -> B -> C) -> A -> C.
Proof.
intros Hab Habc Ha.
apply Habc.
{ admit. (* ... (à compléter) *)
}
admit. (* ... (à compléter) *)
Admitted.

(* ou délimiter les sous-buts avec des items "-" *)
Lemma ex5'' : (A -> B) -> (A -> B -> C) -> A -> C.
Proof.
intros Hab Habc Ha.
apply Habc.
- admit. (* ... (à compléter) *)
- admit.  (* ... (à compléter) *)
Admitted.

(* remarque: ces lemmes sont assez simples et la tactique «auto» les
   prouve tous *)
Lemma ex5''' : (A -> B) -> (A -> B -> C) -> A -> C.
Proof.
auto.
Qed.

(* Considérons la conjonction de 2 propositions : A /\ B.
   À partir de A et de B, on peut prouver A /\ B en appliquant conj.
   À ne pas confondre avec la fonction (andb : bool -> bool -> bool).
*)
Check conj.

Lemma ex6 : A -> B -> A /\ B.
Proof.
intros Ha Hb.
apply conj.
- apply Ha.
- apply Hb.
Qed.

(* la tactique «split» est un synonyme de «apply conj» *)
Lemma ex6' : A -> B -> A /\ B.
Proof.
intros Ha Hb.
split. (* 2 sous-buts sont produits: prouver A, prouver B *)
- apply Ha. (* 1er sous-but: on prouve A *)
- apply Hb. (* 2eme sous-but: on prouve B *)
Qed.

(* on peut détruire A /\ B après l'avoir introduit, avec "destruct …"
ou "destruct … as [Ha Hb]" *)
Lemma ex7 : A /\ B -> A.
intros Hab. (* Hab est une preuve de A/\B *)
destruct Hab as [Ha Hb]. (* Ha est une preuve de A, Hb une preuve de B *)
apply Ha.
Qed.

(* Prouver le lemme suivant *)
Lemma ex8 : A /\ B -> B /\ A.
Proof.
(* ... (à compléter) *)
Admitted.

(* la disjonction (ou) est similaire : A \/ B.
   À partir de A (resp. B), on a une preuve de A \/ B.
   Si on a une preuve de A ou une preuve de B,
   on peut prouver A \/ B en appliquant or_introl (resp. or_intror) *)
Check or_introl.
Check or_intror.

Lemma ex9 : A -> A \/ B.
Proof.
intros Ha.
apply or_introl.
apply Ha.
Qed.

(* la tactique «left» (resp. right) est un synonyme de «apply or_introl» *)
Lemma ex9' : A -> A \/ B.
Proof.
intros Ha.
left.
apply Ha.
Qed.

(* de même que A /\ B, on peut détruire A \/ B avec "destruct …" ou
   "destruct … as [Ha | Hb]"
 *)
(* on notera que la destruction d'un ET produit 2 hypothèses alors que
   la destruction d'un OU conduit à réaliser 2 preuves - 1 pour chaque hypothèse
 *)
Lemma ex10 : A \/ B -> (B -> A) -> A.
Proof.
intros Hab.
destruct Hab as [Ha | Hb]. (* crée 2 sous-buts *)
- intros _. (* on n'a pas besoin de l'hypothèse introduite, donc on l'ignore avec _ *)
  apply Ha.
- intros Himpl.
  apply Himpl.
  apply Hb.
Qed.

(* Prouver le lemme suivant *)
Lemma ex11 : A \/ B -> B \/ A.
Proof.
(* ... (à compléter) *)
Admitted.

End PremieresTactiques.

(***************************************************)
(* Calcul des prédicats (avec des quantificateurs) *)
(***************************************************)
Section CalculPredicats.

Variable P Q : nat -> Prop.
Variable R : nat -> nat -> Prop.

(* Prouver *)
Lemma ex12 : (forall x, P x) /\ (forall x, Q x) -> (forall x, P x /\ Q x).
Proof. (* on pourra utiliser «intros x» et apply *)
(* ... (à compléter) *)
Admitted.

(* Prouver *)
Lemma ex13 : (forall x, P x) \/ (forall x, Q x) -> (forall x, P x \/ Q x).
Proof.
(* ... (à compléter) *)
Admitted.

(* Essayez de prouver (si c'est possible !) *)
Lemma ex14 : (forall x, P x \/ Q x) -> (forall x, P x) \/ (forall x, Q x).
Proof.
(* ... (à compléter) *)
Abort.

(* (H : exists x, …) se détruit avec "destruct H as [x Hx]" *)
(* et se prouve avec la tactique «exists x» : pour prouver une formule
  exists x, P x, il faut fournir une valeur pour x et prouver qu'elle
  satisfait P *)
Lemma ex15 : (exists x, forall y, R x y) -> (forall y, exists x, R x y).
Proof.
intros Hex.
destruct Hex as [x Hx].
intros y.
exists x.
apply Hx.
Qed.

(* Prouver *)
Lemma ex16 : (exists x, P x -> Q x) -> (forall x, P x) -> exists x, Q x.
Proof.
(* ... (à compléter) *)
Admitted.

End CalculPredicats.

(**************************************)
(* Retour aux booléens et aux entiers *)
(**************************************)

Open Scope bool_scope.

(* les booléens permettent de faire facilement des preuves par "force brute"
(énumération de tous les cas) : *)
Lemma negneg : forall b, negb (negb b) = b.
Proof.
intros b.
destruct b. (* génère un but pour chaque valeur possible de b *)
- easy. (* un peu plus puissant que "reflexivity" *)
- easy.
Qed.

(* Prouver *)
Lemma and_commutatif : forall a b, a && b = b && a.
Proof.
(* ... (à compléter) *)
Admitted.

(* on considère l'addition sur les entiers définie dans la librairie Coq par :

Fixpoint plus n m :=
  match n with
  | 0 => m
  | S p => S (plus p m)
  end.

On notera donc que
  - (plus 0 m) se réduit en m
  - (plus (S n) m) se réduit en S (plus n m).
Par contre (plus n 0) ne se réduit pas.
 *)

(* la tactique «simpl» permet de simplifier des termes *)
Lemma plus0n : forall n, plus 0 n = n.
Proof.
intros n.
simpl.
reflexivity.
Qed.

(* mais on peut aussi écrire directement *)
Lemma plus0n' : forall n, plus 0 n = n.
Proof.
reflexivity. (* puisque les 2 termes sont identiques après réduction *)
Qed.

(* ça ne marche pas dans l'autre sens *)
Lemma plusn0 : forall n, plus n 0 = n.
Proof.
intros n.
simpl. (* ne fait rien *)
(* en effet, plus est défini récursivement sur son premier argument,
ici il s'agit de n qui est un entier naturel quelconque (on ne sait
pas s'il est de la forme O ou S n') donc on ne peut rien calculer *)
Abort.

(* On va donc procéder par récurrence sur n on utilise pour cela la
   tactique induction *)
Lemma plusn0 : forall n, plus n 0 = n.
Proof.
(* pas besoin de faire "intros n" avant ! *)
induction n.
- (* simpl. inutile *) reflexivity. (* cas de base *)
- simpl. (* utile pour faire apparaitre le terme de gauche de l'égalité *)
  rewrite IHn. (* hypothèse de récurrence *)
  (* on peut utiliser rewrite avec n'importe quelle égalité *)
  (* si besoin on pourrait utiliser l'égalité de droite à gauche en faisant
     rewrite <-IHn *)
  easy.
Qed.

(* Prouver *)
Lemma plus1n : forall n, plus 1 n = S n.
Proof.
(* ... (à compléter) *)
Admitted.

(* Prouver *)
Lemma plusSn : forall n m, S (plus n m) = plus n (S m).
Proof.
(* ... (à compléter) *)
Admitted.

(* Prouver (un peu plus dur, ne pas hésiter à utiliser les lemmes précédents)  *)
Lemma plus_commutatif : forall n m, plus n m = plus m n.
Proof.
(* ... (à compléter) *)
Admitted.

(* on peut aussi utiliser les opérateurs +,* qui ne sont que des notations *)
Lemma plus_commutatif_bis : forall n m, n + m = m + n.
Proof.
apply plus_commutatif.
Qed.

From Coq Require Import Lia. (* Linear Integer Aritmetic :
preuve automatique de propriétés linéaires sur les entiers *)

Lemma plus_commutatif' : forall n m, n + m = m + n.
Proof.
intros n m.
lia. (* c'est automatique! *)
Qed.
(* lia supporte la somme, le produit par une constante, les comparaisons *)

(*****************************)
(* Preuve en avant, Coupures *)
(*****************************)

(* Jusqu'à maintenant, les preuves ont été réalisées en modifiant le
but jusqu'à le rendre trivial ou le ramener à un lemme connu.

On fait souvent l'inverse quand on rédige une preuve sur papier : on
part des hypothèses et on les modifie pour atteindre la conclusion.
On parle de style de preuve «en avant».

Cela consiste souvent à faire ce qu'on appelle une coupure : on met la
preuve «en pause» pour prouver un résultat intermédiaire qui sera
ensuite utilisé.

On peut pour cela faire un lemme intermédiaire (comme le lemme "plusSn"
dans la preuve de "plus_commutatif" plus haut) mais ça impose parfois
de recopier toutes les hypothèses et de laisser traîner un lemme
peut-être trop spécialisé pour être réellement réutilisable.

La tactique
«assert (nom : propriété).» fournit une alternative plus légère. *)

Lemma plus_commutatif'' : forall n m, plus n m = plus m n.
Proof.
induction n.
- intros m.
  rewrite plusn0.
  easy.
- assert (HplusSn : forall m, S (plus m n) = plus m (S n)).
  { induction m.
    - easy.
    - simpl.
      rewrite IHm.
      easy.
  } (* on a maintenant HplusSn dans nos hypothèses *)
  intros m.
  simpl.
  rewrite IHn.
  rewrite HplusSn.
  easy.
Qed.

(**************************)
(* Preuves sur les listes *)
(**************************)

Require Import List.
Import ListNotations.
(* les 2 constructeurs sont notés [] et _::_ comme en Caml *)

Fixpoint append {T} (l1 l2 : list T) : list T := (* T rendu implicite *)
  match l1 with
    [] => l2
  | x :: r => x :: append r l2 (* le 1er argument T est implicite *)
  end.
Eval compute in append [1;2] [3;4].  (* utilise "append", défini précédemment *)
Eval compute in [1;2] ++ [3;4].  (* utilise "app" de la bibliothèque standard *)
(* la concaténation est ainsi est notée "… @ …" en Caml, "… ++ …" en Coq *)

(* Le principe d'induction sur les listes est automatiquement généré lors
   de la définition du type list. L'itérateur le plus général sur les listes
   a pour type le principe d'induction : *)
Check list_ind.

(********************************************)
(* Modules en Coq : un Type Abstrait Prouvé *)
(********************************************)

(* Voici une interface de module *)
Module Type ListNat.
  Parameter list_nat : Type.
  Parameter nil : list_nat.
  Parameter cons : nat -> list_nat -> list_nat.
  Parameter list_nat_it :
    forall T (f_nil : T) (f_cons : nat -> list_nat -> T -> T), list_nat -> T.
  Parameter length : list_nat -> nat.

  Axiom list_nat_ind :
    forall (P : list_nat -> Prop),
      P nil -> (forall (a : nat) (l : list_nat), P l -> P (cons a l)) ->
      forall l : list_nat, P l.

  Axiom list_nat_it_nil :
    forall T f_nil f_cons, list_nat_it T f_nil f_cons nil = f_nil.
  Axiom list_nat_it_cons :
    forall T f_nil f_cons x l,
      list_nat_it T f_nil f_cons (cons x l)
      = f_cons x l (list_nat_it T f_nil f_cons l).

  Axiom length_nil : length nil = 0.
  Axiom length_cons : forall x l, length (cons x l) = 1 + length l.
End ListNat.

(* Pour un module L suivant cette interface, étendons le avec une
   nouvelle opération.  *)
Module ListNatExt (L : ListNat).

(* Effectue une copie du module L dans le module ambient *)
Include L.

(* implémenter la concaténation de deux liste "app" *)
Definition app (l l' : L.list_nat) : L.list_nat :=
  L.nil. (* ... (à compléter (remplacer L.nil par votre implémentation)) *)

Lemma app_length : forall l l', L.length (app l l') = L.length l + L.length l'.
Proof.
(* ... (à compléter) *)
Admitted.

End ListNatExt.

(* Implémenter un module de type ListNat *)
(*
Module ListNatImpl : ListNat.
(* ... (à compléter) *)
(* (penser à list_ind pour list_nat_ind) *)
End ListNatImpl.
*)

(* on peut alors appliquer le foncteur ListNatExt *)
Module L' := ListNatExt ListNatImpl.

(* et utiliser le module résultant *)
Lemma app3 : forall l l', L'.length (L'.app l l') = L'.length (L'.app l' l).
Proof.
(* ... (à compléter) *)
Admitted.
