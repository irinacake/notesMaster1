(* Rappel syntaxe Coq : les commentaires s'écrivent entre (* et *). *)

(* TAPFA - Partie Coq - TP 1 *)

(* Rappel de l'URL des supports de Cours :

   https://pfitaxel.github.io/tapfa-coq-alectryon/ *)

(* Le sujet des 2 TP TAPFA se présentent sous la forme d'un fichier .v
   à compléter. Vous pouvez coder vos réponses :
   - dans Emacs+ProofGeneral (environnement de TP recommandé :

     https://moodle.univ-tlse3.fr/course/view.php?id=183#env-tp ;
     https://github.com/erikmd/tapfa-init.el )

   - ou dans JsCoq (éditeur en ligne, pratique mais moins performant :
     https://jscoq.github.io/scratchpad.html )
 *)

(* N'hésitez pas à solliciter votre encadrant de TP sur Discord
   pour toute question. *)

(* Pour évaluer les phrases dans Emacs+ProofGeneral :
   - aller jusqu'au curseur en faisant "C-c RET" (<=> Ctrl+C Entrée)
     ou "C-c C-RET"
   - avancer/reculer d'un cran avec "C-c C-n" et "C-c C-u"
   - et pour aller à la fin de la zone validée, faire "C-c C-."

  Pour évaluer les phrases dans l'éditeur en ligne,
  utiliser les trois boutons adéquats (ou Alt+N, Alt+P, Alt+Entrée) *)

(*********************************************************)
(* D'abord un petit peu de programmation (fonctionnelle) *)
(*********************************************************)

(* Définissons la fonction qui à n, associe n + 1. *)

(* En OCaml, on aurait écrit :

   let f = fun n -> n + 1;;
 *)

(* En Coq, on écrit : *)

Definition f := fun n => n + 1.

(* En maths, on écrirait :

   f : N ⟶ N
       n ↦ n+1

   "↦" ("\mapsto" en LaTeX) s'écrira "fun … => …" en Coq.

   La partie "N ⟶ N" existe aussi en Coq et est appelée «type» de la fonction.

   Ici Coq l'a automatiquement inféré, on peut l'afficher avec : *)

Check f.

Print f.

(* On aurait aussi pu le donner explicitement *)
Definition f2 : nat -> nat := fun n => n + 1.

(* Contrairement à OCaml, il est impossible de définir en Coq deux
   fonctions (ou types) ayant le même nom dans le même fichier ;
   ainsi, cela permet d'éviter des confusions. *)
Fail Definition f2 := fun n => n + 2.
(* La commande "Fail" vérifie que la phrase qui suit donne une erreur,
   ignore celle-ci et permet de continuer tout de même.
   Cette commande a donc essentiellement un but de «documentation». *)

(* De manière générale, "t : T" se lit «t est de type T».
   On peut mettre de telles «annotations de type» un peu partout et
   t n'est pas nécessairement une fonction. *)
Definition f3 := fun (n : nat) => n + 1.

(* Autre syntaxe : pour éviter d'avoir à écrire fun, on peut également
   écrire le nom de l'argument après celui de la fonction, avant ":="
   (et c'est dorénavant ce que l'on fera). *)
Definition f4 n := n + 1.

(* La syntaxe change mais c'est exactement la même fonction, comme la
   montre la commande Print. *)
Print f4.
Print f.  (* même résultat *)

(* Comme avec tout langage de programmation, on peut évaluer les fonctions *)
Eval compute in f 2.
(* Tout comme en OCaml, on pourrait écrire "f(2)", mais les parenthèses
   ne servent à rien s'il n'y a pas de sous-expression à regrouper ;
   on utilise donc généralement simplement un espace : "f 2" *)

(* On peut aussi demander le type de f 2 *)
Check f 2.
(* Bien sûr, il faut que le terme soit bien typé. Ceci échoue : *)
Fail Check f f.
(* Commentez la ligne précédente (ou ajoutez la commande "Fail" devant)
pour pouvoir continuer *)

(****************************************************)
(* Petit rappel sur les fonctions d'ordre supérieur *)
(****************************************************)

(* Comme en OCaml, on peut définir des fonctions curryfiées
(c.-à-d. prenant deux arguments ou plus) : *)
Definition g x y := x + 2 * y.
Print g.

(* syntaxes équivalentes *)
Definition g2 := fun x y => x + 2 * y.
Definition g3 := fun x => (fun y => x + 2 * y).

(* Regardons le type de g *)
Check g.
(* on obtient «nat -> nat -> nat» qui se lit «nat -> (nat -> nat)»
   c.-à-d. la fonction g est une fonction à un argument (x), qui
   renvoie une fonction prenant un argument (y) et retournant x+2y. *)
Check g 1.

(* pour l'évaluation, on peut donc écrire *)
Eval compute in (g 1) 3.
(* ou plus simplement *)
Eval compute in g 1 3.

(* On peut aussi définir des fonctionnelles, c.-à-d. des fonctions
prenant des fonctions en argument : *)
Definition repeat_twice f (x : nat) := f (f x).

Definition rtwice := fun (f : nat -> nat) => fun (x : nat) => f (f x).

Check rtwice.
Check repeat_twice.
(* repeat_twice *)
(*      : (nat -> nat) -> nat -> nat *)

Print f.
Eval compute in repeat_twice f 2.

(******************************************************************)
(* Encore un peu de programmation, quelques structures de données *)
(******************************************************************)

(* un des types les plus simples : les booléens *)
Check true.
Check false.

(* Les booléens sont définis dans la bibliothèque standard de Coq
comme un type utilisateur à 2 constructeurs :

un booléen est soit true, soit false (et rien d'autre) *)
Print bool.

(* true et false sont ainsi des constructeurs. Notez au passage qu'il
n'y a pas de contrainte sur la «casse» des constructeurs dans Coq :
pas besoin qu'ils commencent par une majuscule. *)

(* on peut examiner la valeur d'un booléen avec un match *)

Definition et a b :=
  match a with
  | true => b
  | false => false
  end.

(* L'écriture "if b then ct else cf" est juste du sucre syntaxique
pour le match ci-dessus et c'est l'écriture simplifiée par défaut : *)

Print et.

(* Mais on peut passer en mode "affichage bas-niveau" pour désactiver
cette écriture simplifiée : *)

Set Printing All.

Print et.

Unset Printing All.

Eval compute in et true false.

Eval compute in et true true.

(* Similairement à OCaml, on est obligé de définir tous les cas, mais
   le «filtrage non-exhaustif» est une erreur, pas un warning
   (commenter pour pouvoir continuer) *)
Fail Definition et_non_exhaustif a b :=
  match a with
  | true => b
  end.

(* La bibliothèque standard de Coq fournit des notations "&&", "||"
associée aux définitions "andb" (identique à notre définition "et"
donc dans la suite on utilisera donc "andb" plutôt que "et"), "orb",
et "negb" : *)

Check andb false true.
Check (false && true)%bool.

Check orb false true.
Check (false || true)%bool.

Check negb false.


Eval compute in negb false.

(* Une invocation possible pour avoir des notations plus légères : *)
Open Scope bool_scope.

Check andb false true.
Check orb false true.

(* un type un peu plus complexe : les entiers naturels.

Ils sont définis dans la bibliothèque standard de Coq comme un type
utilisateur à 2 constructeurs :

un entier est soit O, soit le successeur d'un entier. *)
Print nat.

(* Notez que la syntaxe affichée par Coq est équivalente à la syntaxe
suivante, vue en cours :

Inductive nat :=
  | O
  | S (_ : nat). *)

(* Au moment où ce type nat est défini dans la bibliothèque standard,
   Coq génère automatiquement le principe d'induction "nat_ind", qui
   coïncide naturellement avec le schéma de "preuve par récurrence",
   que l'on (re)verra lors du TP2. *)
Check nat_ind.

(* À noter, la représentation des entiers sous cette forme correspond
   à une "représentation en base 1", c'est-à-dire que le nombre entier
   16, même si Coq le "lit" et "l'écrit" en base 10 avec les options
   d'affichage par défaut, en interne, il est stocké sous la forme
   d'une expression inductive impliquant 17 constructeurs ! *)

Set Printing All.
Check 16.
Unset Printing All.
Check 17.

(* Bien entendu, d'autres représentations plus compactes des entiers
   naturels (en binaire…) et des entiers relatifs, sont disponibles
   dans la bibliothèque standard de Coq, mais nous n'approfondirons
   pas cet aspect durant ce TP TAPFA. *)

(* Nous avons rappelé précédemment (fonction "et") la syntaxe de Coq
   pour effectuer un filtrage (syntaxe très proche de celle d'OCaml !)

   Quant à l'équivalent du "let rec" en Coq, il s'agit d'utiliser
   la commande "Fixpoint".
   En revanche, nous n'utiliserons pas l'équivalent Coq de la syntaxe
   "let rec … in", puisqu'en pratique cela rendrait plus compliqué les
   preuves de propriétés de la fonction définie localement... *)

(* Définir la fonction "factorielle" de type "nat -> nat".
   Puis calculer "factorielle 3".

   Rappel sur la récursion : il faut que vous veilliez à ce que vos
   définitions de fonctions récursives aient des appels récursifs dont
   l'argument principal soit décroissant structurellement (pour
   garantir la terminaison. Sinon, Coq refusera votre définition ! *)


Fixpoint factorielle (n : nat) :=
  match n with
  | 0 => 1
  | S p => factorielle p * n
  end.

Eval compute in factorielle 8.

(* Définir le prédicat booléen "pair" de type "nat -> bool".
   Puis calculer "pair 6". *)

Fixpoint pair n :=
  match n with
  | 0 => true
  | S 0 => false
  | S (S p) => pair p
  end.

Eval compute in pair 6.


(* Pour conclure sur cette revue du filtrage et de la récursion en Coq
   voici un exemple de définition d'un prédicat booléen "inf",
   testant si un entier n est plus petit ou égal à un autre entier m.
   Pouvez-vous expliquer avec vos propres mots chacune des branches du
   match ? (qui correspond ici à un filtrage simultané !) *)
Fixpoint inf n m :=
  match n,m with
  | O, _ => true            (* si n=0, alors ∀m, n<=m *)
  | S n1, O => false        (* si n>0 et m=0, alors n>m *)
  | S n1, S m1 => inf n1 m1 (* si n>0 et m>0, alors vérifier avec les préds de n et m *)
  end.

Require Extraction.

Recursive Extraction inf.

Check inf.
Eval compute in inf 2 3.
Eval compute in inf 1 0.

(* Remarque : ne pas confondre les opérations booléennes «calculables»
&&, || et negb, avec les connecteurs logiques /\, \/ et ~, qui ne
prennent pas en argument des booléens mais des Propositions : *)

Check 0 = 0.
(* 0 = 0 *)
(*      : Prop *)

Check (0 = 0) /\ (0 = 0).

Check 0 < 1 \/ 0 = 1 \/ 0 > 1.

(* "/\" est ainsi une notation pour and,
   "\/" pour or,
   "~" pour not *)

Check and (0 = 0) (0 = 0).
Check or (0 < 1) (or (0 = 1) (0 > 1)).

(* Q1. Qu'est-ce qu'une proposition dans Coq ?
   Q2. comment montrer qu'une proposition est vraie ?

Avant de faire des exercices spécifiques pour prouver des propositions
simples de 3 façons différentes (à la main, de façon semi-automatique
ou complètement automatique), deux réponses rapides :


R1. Une proposition est une formule logique, et dans Coq c'est à la
fois un objet de type Prop, et un type de données dont les expressions
de ce type sont les preuves de la formule en question.

Cela correspond à la notion de «correspondance de Curry-Howard» vue en
cours.

Par exemple, on aura  (preuve que 0=0) : 0 = 0 : Prop

Ainsi, Prop est un "type de type", au même titre que le mot-clé Type
vu en cours.

Il y a quelques différences de sémantique entre Prop et Type que nous
ne détaillerons pas ici. (La principale idée étant que Type correspond
au type des «types de données informatifs» (entiers,listes,fonctions),
Prop correspond au type des «formules purement logiques».)


R2. Pour montrer qu'une proposition P est vraie, il s'agit d'exhiber
une preuve, c'est-à-dire une expression p qui a le bon type (p : P).

Le but de l'assistant de preuves Coq est de faciliter la construction
de ces termes de preuve (p), puis au moment du "Qed.", de vérifier
automatiquement que le type du terme de preuve coïncide avec l'énoncé
de la formule que l'on veut prouver.

Maintenant, des exercices. *)

(**************************************************************)
(* Premières preuves "à la main", en logique propositionnelle *)
(**************************************************************)

Section PremieresPreuves.

(* Dans cette section, supposons trois propositions A, B et C *)
Variables A B C : Prop.

(* une fonction est une preuve : par exemple, la fonction identité
   "prouve" que A implique A *)
Definition identite : A -> A := fun a => a.

(* prouver les propriétés suivantes *)


Definition ex0 : B -> B := fun b => b.

Definition ex1 : A -> B -> A := fun a => fun b => a.

Definition ex2 : A -> B -> B := fun a b => b.

Definition ex3 : A -> (A -> B) -> B := fun a ab => ab a.

Definition ex4 : (A -> B) -> (B -> C) -> A -> C := fun ab bc a => bc (ab a).

Definition ex5 : (A -> B) -> (A -> B -> C) -> A -> C := fun ab abc a => (abc a) (ab a).


Theorem cinQ : (A -> B) -> (A -> B -> C) -> A -> C.
intros H1.
intros H2.
intros H3.
apply H2.
exact H3.
apply H1.
exact H3.
Qed.
(* auto. *)

(*
Theorem distr_and_or : (A /\ B) \/ (A /\ C) -> A /\ (B \/ C).
intros H.
destruct H as [H1 | H2].
split.*)








