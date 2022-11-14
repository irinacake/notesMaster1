#Cette version n'a pas été officiellement corrigée en TD

enregistrement voiture {
    num_im : varchar(4)
    marque : varchar(20)
    proprietaire : varchar(20)
} v;

enregistrement personne {
    nom : varchar(20)
    adresse : varchar(20)
} p;

assignation(fv, "C:\...\voiture.txt", sequentielle);

assignation(fp, "C:\...\personne.txt", sequentielle);


ouverture(fv, lecture , sequentiel);

String[] nomsProprietaires;

while (!FDF(fv)){
    lecture(fv,v);
    if (v.marque == 'Renault')
        nomsProprietaire.append(v.proprietaire);
}

fermeture(fv);

if(!nomsProprietaires.isEmpty()){
    ouverture(fp, lecture , sequentiel);
    
    while (!FDF(fp)){
        lecture(fp,p);

        for (proprio in nomsProprietaire) {
            if(proprio == p.nom){
                afficher(p.adresse)
            }
        }
    }

    fermture(fp);
}






