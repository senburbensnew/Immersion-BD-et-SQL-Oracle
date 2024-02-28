  
--- -- Association --
/**

Bien sûr, voici les descriptions textuelles des associations entre les tables de votre modèle physique de données (MPD) :

1. **Association "Effectuer" entre MEDECIN et CONSULTATION** : Cette association indique que chaque consultation est effectuée par un médecin. Un médecin peut effectuer plusieurs consultations, mais une consultation est effectuée par un seul médecin à la fois.

2. **Association "Inclure" entre FACTURE et CONSULTATION** : Cette association représente le fait qu'une facture inclut une consultation. Chaque consultation peut être incluse dans une seule facture, mais une facture peut inclure plusieurs consultations.

3. **Association "Passer" entre PATIENT et CONSULTATION** : Cette association signifie qu'un patient passe une consultation. Chaque consultation est passée par un seul patient, mais un patient peut passer plusieurs consultations.

4. **Association "Contenir" entre CONSULTATION et EXAMEN** : Cette association indique que chaque consultation peut contenir plusieurs examens. Chaque examen est associé à une seule consultation.

5. **Association "Recevoir" entre PATIENT et FACTURE** : Cette association représente le fait qu'un patient peut recevoir une facture. Chaque facture est destinée à un seul patient, mais un patient peut recevoir plusieurs factures.

6. **Association "Contenir" entre CONSULTATION et PRESCRIPTION** : Cette association signifie qu'une consultation peut contenir plusieurs prescriptions. Chaque prescription est associée à une seule consultation.

7. **Association "Rendez-vous" entre PATIENT et MEDECIN** : Cette association indique que chaque rendez-vous est entre un patient et un médecin. Chaque rendez-vous est pris par un patient avec un médecin spécifique.


**/