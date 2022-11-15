enregistrement voiture {
    num_im : varchar(4)
    marque : varchar(20)
    proprietaire : varchar(20)
} v
enregistrement personne {
    nom : varchar(20)
    adresse : varchar(20)
} p

assignation(fv, "C:\...\voiture.txt", sequentielle)
assignation(fp, "C:\...\personne.txt", sequentielle)

ouverture(fv, lecture , sequentiel)

while (!FDF(fv)):
    lecture(fv,v)
    if (v.marque == "Renault"):
        ouverture(fp, lecture , sequentiel)
        while (!FDF(fp)):
            lecture(fp,p)
            if (v.proprietaire == p.nom):
                afficher(p.adresse)
        fermeture(fp)
        
fermeture(fv)






