enregistrement voiture {
    num_im : number(4)
    marque : varchar(20)
    proprietaire : varchar(20)
} v

assignation(fv, "C:\...\voiture.txt", sequentielle)

ouverture(fv, lecture , sequentiel)

while (!FDF(fv)):
    lecture(fv,v)
    if (v.num_im == '31xx31'):
        afficher(v.marque)

fermeture(fv)