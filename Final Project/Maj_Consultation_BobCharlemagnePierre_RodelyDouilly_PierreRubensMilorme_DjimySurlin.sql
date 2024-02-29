/* Formatted on 28/02/2024 11:26:24 (QP5 v5.360) */
/**
        I• La description textuelles des requêtes de mise à jour (2 requêtes impliquant 1 table, 2 
        requêtes impliquant 2 tables, 2 requêtes impliquant plus de 2 tables)

**/

-- A) 2 requêtes impliquant 1 table:

UPDATE PATIENT
   SET DATE_NAISSAINCE = TO_DATE ('22-AUG-1986', 'DD-MON-YYYY')
 WHERE EMAIL = 'thomas.leclerc@email.com';

UPDATE PATIENT
   SET ADRESSE = '90, DELMAS 75'
 WHERE ID_PATIENT_ = 1;


-- B) 2 requêtes impliquant 2 tables:

UPDATE (SELECT P.ID_PATIENT_,
               P.NOM,
               P.PRENOM,
               R.DATE_RENDEZ_VOUS
          FROM PATIENT P JOIN RENDEZ_VOUS R ON P.ID_PATIENT_ = R.ID_PATIENT_
         WHERE R.DATE_RENDEZ_VOUS BETWEEN '14-FEB-2024' AND '18-FEB-2024') X
   SET X.DATE_RENDEZ_VOUS = '01-MAR-24';

UPDATE (SELECT *
          FROM FACTURE F, PATIENT P
         WHERE F.ID_PATIENT_ = P.ID_PATIENT_ AND F.MONTANT_TOTAL < 200)
   SET MONTANT_TOTAL = MONTANT_TOTAL + MONTANT_TOTAL * 0.1;


-- C)  2 requêtes impliquant plus de 2 tables

UPDATE PRESCRIPTION R
   SET R.DETAILS_PRESCRIPTION = 'Zinoboost'
 WHERE R.ID_CONSULTATION_ IN
           (SELECT C.ID_CONSULTATION_
              FROM CONSULTATION C
             WHERE     DATE_CONSULTATION =
                       TO_DATE ('05/02/2024', 'DD/MM/YYYY')
                   AND C.ID_PATIENT_ IN (SELECT P.ID_PATIENT_
                                           FROM PATIENT P
                                          WHERE P.ID_PATIENT_ = 1));


UPDATE EXAMEN R
   SET R.DETAILS_EXAMEN = 'HAC1'
 WHERE R.ID_CONSULTATION_ IN
           (SELECT C.ID_CONSULTATION_
              FROM CONSULTATION C
             WHERE     DATE_CONSULTATION =
                       TO_DATE ('05/02/2024', 'DD/MM/YYYY')
                   AND C.ID_PATIENT_ IN (SELECT P.ID_PATIENT_
                                           FROM PATIENT P
                                          WHERE P.ID_PATIENT_ = 1));

 /**
 
     II • La description textuelles des requêtes de suppression (2 requêtes impliquant 1 table, 2 
    requêtes impliquant 2 tables, 2 requêtes impliquant plus de 2 tables) 
     
**/

-- A) 2 requêtes impliquant 1 table:

DELETE EXAMEN
 WHERE DATE_EXAMEN = TO_DATE ('05-02-24', 'DD-MM-YY');

DELETE FROM PRESCRIPTION
      WHERE DATE_PRESCRIPTION = TO_DATE ('05-02-24', 'DD-MM-YY');


-- B) 2 requêtes impliquant 2 tables:  

DELETE FROM RENDEZ_VOUS
      WHERE ID_PATIENT_ IN (SELECT ID_PATIENT_
                              FROM PATIENT
                             WHERE EMAIL = 'thomas.leclerc@email.com');

DELETE FROM RENDEZ_VOUS
      WHERE ID_PATIENT_ IN (SELECT ID_PATIENT_
                              FROM PATIENT
                             WHERE ID_PATIENT_ = 3);


-- C) 2  requêtes de suppression impliquant plus de 2 tables:

DELETE FROM
    EXAMEN
      WHERE ID_CONSULTATION_ IN
                (SELECT C.ID_CONSULTATION_
                   FROM CONSULTATION C
                  WHERE     DATE_CONSULTATION =
                            TO_DATE ('05/02/2024', 'DD/MM/YYYY')
                        AND C.ID_PATIENT_ IN (SELECT P.ID_PATIENT_
                                                FROM PATIENT P
                                               WHERE P.ID_PATIENT_ = 1));

DELETE FROM
    EXAMEN
      WHERE ID_CONSULTATION_ IN
                (SELECT C.ID_CONSULTATION_
                   FROM CONSULTATION C
                  WHERE     DATE_CONSULTATION =
                            TO_DATE ('06/02/2024', 'DD/MM/YYYY')
                        AND C.ID_PATIENT_ IN (SELECT P.ID_PATIENT_
                                                FROM PATIENT P
                                               WHERE P.ID_PATIENT_ = 2));

/**            
 
III  • La description textuelles des requêtes de consultation (5 requêtes impliquant 1 table dont 1 
avec un group By et une avec un Order By, 5 requêtes impliquant 2 tables avec jointures internes 
dont 1 externe + 1 group by + 1 tri, 5 requêtes impliquant plus de 2 tables avec jointures internes 
dont 1 externe + 1 group by + 1 tri)

**/

-- A) 5 requêtes impliquant 1 table dont 1 avec un group By et une avec un Order By:

SELECT * FROM PATIENT;

SELECT * FROM CONSULTATION;

  SELECT COUNT (*), DETAILS_EXAMEN
    FROM EXAMEN
GROUP BY DETAILS_EXAMEN;

  SELECT COUNT (*), DETAILS_EXAMEN
    FROM EXAMEN
GROUP BY DETAILS_EXAMEN
ORDER BY DETAILS_EXAMEN;

  SELECT ID_PATIENT_, COUNT (*), SUM (MONTANT_TOTAL)
    FROM FACTURE
GROUP BY ID_PATIENT_
ORDER BY ID_PATIENT_;


-- B) 5 requêtes impliquant 2 tables avec jointures internes dont 1 externe + 1 group by + 1 tri:

SELECT *
  FROM CONSULTATION C INNER JOIN PATIENT P ON C.ID_PATIENT_ = P.ID_PATIENT_;

SELECT *
  FROM FACTURE F INNER JOIN PATIENT P ON F.ID_PATIENT_ = P.ID_PATIENT_;

  SELECT *
    FROM CONSULTATION C INNER JOIN PATIENT P ON C.ID_PATIENT_ = P.ID_PATIENT_
ORDER BY C.DATE_CONSULTATION;

  SELECT F.ID_PATIENT_, P.EMAIL, SUM (F.MONTANT_TOTAL) MONTANT_TOTAL
    FROM FACTURE F INNER JOIN PATIENT P ON F.ID_PATIENT_ = P.ID_PATIENT_
GROUP BY F.ID_PATIENT_, P.EMAIL
ORDER BY F.ID_PATIENT_, P.EMAIL;

  SELECT *
    FROM CONSULTATION C RIGHT JOIN PATIENT P ON C.ID_PATIENT_ = P.ID_PATIENT_
ORDER BY C.DATE_CONSULTATION;


-- C) 5 requêtes impliquant plus de 2 tables avec jointures internes dont 1 externe + 1 group by + 1 tri:

SELECT C.*, P.*, E.*
  FROM CONSULTATION  C
       INNER JOIN PATIENT P ON C.ID_PATIENT_ = P.ID_PATIENT_
       INNER JOIN EXAMEN E ON C.ID_CONSULTATION_ = E.ID_CONSULTATION_;

SELECT F.*, P.*, C.*
  FROM FACTURE  F
       INNER JOIN PATIENT P ON F.ID_PATIENT_ = P.ID_PATIENT_
       INNER JOIN CONSULTATION C ON F.ID_FACTURE_ = C.ID_FACTURE_;

  SELECT C.*, P.*, E.*
    FROM CONSULTATION C
         INNER JOIN PATIENT P ON C.ID_PATIENT_ = P.ID_PATIENT_
         INNER JOIN EXAMEN E ON C.ID_CONSULTATION_ = E.ID_CONSULTATION_
ORDER BY C.DATE_CONSULTATION;


  SELECT F.ID_PATIENT_,
         P.EMAIL,
         SUM (F.MONTANT_TOTAL)     MONTANT_TOTAL,
         F.DATE_FACTURE,
         C.DATE_CONSULTATION
    FROM FACTURE F
         INNER JOIN PATIENT P ON F.ID_PATIENT_ = P.ID_PATIENT_
         INNER JOIN CONSULTATION C ON F.ID_FACTURE_ = C.ID_FACTURE_
GROUP BY F.ID_PATIENT_,
         P.EMAIL,
         F.DATE_FACTURE,
         C.DATE_CONSULTATION
ORDER BY F.ID_PATIENT_,
         P.EMAIL,
         F.DATE_FACTURE,
         C.DATE_CONSULTATION;

  SELECT C.*, E.*, P.*
    FROM CONSULTATION C
         INNER JOIN EXAMEN E ON C.ID_CONSULTATION_ = E.ID_CONSULTATION_
         RIGHT JOIN PATIENT P ON C.ID_PATIENT_ = P.ID_PATIENT_
ORDER BY C.DATE_CONSULTATION;

