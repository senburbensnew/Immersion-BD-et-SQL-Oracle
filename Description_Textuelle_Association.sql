  
--- -- Association --
/**

voici les descriptions textuelles des associations entre les entités :

1. **Association "Effectuer" entre MEDECIN et CONSULTATION** : Cette association indique que chaque consultation est effectu�e par un m�decin. Un m�decin peut effectuer plusieurs consultations, mais une consultation est effectu�e par un seul m�decin � la fois.

2. **Association "Inclure" entre FACTURE et CONSULTATION** : Cette association repr�sente le fait qu'une facture inclut une consultation. Chaque consultation peut �tre incluse dans une seule facture, mais une facture peut inclure plusieurs consultations.

3. **Association "Passer" entre PATIENT et CONSULTATION** : Cette association signifie qu'un patient passe une consultation. Chaque consultation est pass�e par un seul patient, mais un patient peut passer plusieurs consultations.

4. **Association "Contenir" entre CONSULTATION et EXAMEN** : Cette association indique que chaque consultation peut contenir plusieurs examens. Chaque examen est associ� � une seule consultation.

5. **Association "Recevoir" entre PATIENT et FACTURE** : Cette association repr�sente le fait qu'un patient peut recevoir une facture. Chaque facture est destin�e � un seul patient, mais un patient peut recevoir plusieurs factures.

6. **Association "Contenir" entre CONSULTATION et PRESCRIPTION** : Cette association signifie qu'une consultation peut contenir plusieurs prescriptions. Chaque prescription est associ�e � une seule consultation.

7. **Association "Rendez-vous" entre PATIENT et MEDECIN** : Cette association indique que chaque rendez-vous est entre un patient et un m�decin. Chaque rendez-vous est pris par un patient avec un m�decin sp�cifique.


**/