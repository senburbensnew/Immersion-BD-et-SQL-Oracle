/*<TOAD_FILE_CHUNK>*/
/* Formatted on 03/03/2024 13:16:35 (QP5 v5.360) */
/********************************** PACKAGE SPECIFICATION PK_MEDECIN *************************************************/

CREATE OR REPLACE PACKAGE PK_MEDECIN
AS
    -- D?claration de la fonction AInserer pour ins?rer des donn?es dans la table MEDECIN
    FUNCTION MEDECIN_INSERER (p_id_medecin       IN INTEGER,
                              p_nom_medecin      IN VARCHAR2,
                              p_prenom_medecin   IN VARCHAR2,
                              p_specialite       IN VARCHAR2,
                              p_telephone        IN VARCHAR2,
                              p_email            IN VARCHAR2)
        RETURN VARCHAR2;

    -- FUNCTION SUPPRIMER
    FUNCTION MEDECIN_SUPPRIMER (p_id_medecin IN INTEGER)
        RETURN VARCHAR2;

    -- MODIFIER SPECIALITE
    FUNCTION MEDECIN_MODIFIER_SPECIALITE (p_id_medecin   IN INTEGER,
                                          p_specialite   IN VARCHAR2)
        RETURN VARCHAR2;

    -- MODIFIER EMAIL TELEPHONE
    FUNCTION MEDECIN_MODIFIER_CONTACT (p_id_medecin          IN INTEGER,
                                       p_nouveau_telephone   IN VARCHAR2,
                                       p_nouvel_email        IN VARCHAR2)
        RETURN VARCHAR2;

    -- LIST OF MEDECIN
    FUNCTION MEDECIN_LISTER_ALL
        RETURN SYS_REFCURSOR;


    -- TOTAL MEDECIN
    FUNCTION MEDECIN_TOTAL
        RETURN NUMBER;

    FUNCTION LISTE_PATIENT_CONSULTER_MEDECIN_JOUR (P_ID_MEDECIN   IN INTEGER,
                                                   P_DATE         IN DATE)
        RETURN SYS_REFCURSOR;


    FUNCTION NBRE_CONSULTATION_MEDECIN_JOUR (P_DATE IN DATE)
        RETURN SYS_REFCURSOR;

    FUNCTION NBRE_CONSULTATION_SPECIALITE_JOUR (P_DATE IN DATE)
        RETURN SYS_REFCURSOR;
END;


/********************************** PACKAGE BODY PK_MEDECIN *************************************************/

CREATE OR REPLACE PACKAGE BODY PK_MEDECIN
AS
    FUNCTION MEDECIN_INSERER (p_id_medecin       IN INTEGER,
                              p_nom_medecin      IN VARCHAR2,
                              p_prenom_medecin   IN VARCHAR2,
                              p_specialite       IN VARCHAR2,
                              p_telephone        IN VARCHAR2,
                              p_email            IN VARCHAR2)
        RETURN VARCHAR2
    AS
    BEGIN
        -- Insertion des donn?es dans la table MEDECIN en utilisant les param?tres pass?s
        INSERT INTO MEDECIN (ID_MEDECIN_,
                             NOM,
                             PRENOM,
                             SPECIALITE,
                             TELEPHONE,
                             EMAIL)
             VALUES (p_id_medecin,
                     p_nom_medecin,
                     p_prenom_medecin,
                     p_specialite,
                     p_telephone,
                     p_email);

        RETURN 'Insertion Reussie';
    EXCEPTION
        WHEN OTHERS
        THEN
            RETURN ( 'Erreur au niveau de la function MEDECIN_INSERER: '
                || SQLCODE
                || '-'
                || SQLERRM);
    END MEDECIN_INSERER;

    -- FUNCTION SUPPRIMER
    FUNCTION MEDECIN_SUPPRIMER (p_id_medecin IN INTEGER)
        RETURN VARCHAR2
    AS
    BEGIN
        -- Supprimer les EXAMENS associEes au CONSULTATION
        DELETE FROM EXAMEN
              WHERE ID_CONSULTATION_ IN (SELECT ID_CONSULTATION_
                                           FROM CONSULTATION
                                          WHERE ID_MEDECIN_ = p_id_medecin);

        IF SQL%ROWCOUNT = 0
        THEN
            RAISE NO_DATA_FOUND;
        END IF;

        -- Supprimer les PRESCIPTIONS associEes au CONSULTATION
        DELETE FROM PRESCRIPTION
              WHERE ID_CONSULTATION_ IN (SELECT ID_CONSULTATION_
                                           FROM CONSULTATION
                                          WHERE ID_MEDECIN_ = p_id_medecin);

        IF SQL%ROWCOUNT = 0
        THEN
            RAISE NO_DATA_FOUND;
        END IF;

        -- Supprimer les consultations associ?es au m?decin
        DELETE FROM CONSULTATION
              WHERE ID_MEDECIN_ = p_id_medecin;

        IF SQL%ROWCOUNT = 0
        THEN
            RAISE NO_DATA_FOUND;
        END IF;

        -- Supprimer les rendez-vous associ?es au m?decin
        DELETE FROM RENDEZ_VOUS 
              WHERE ID_MEDECIN_ = p_id_medecin;

        IF SQL%ROWCOUNT = 0
        THEN
            RAISE NO_DATA_FOUND;
        END IF;
        
        -- Supprimer le m?decin lui-m?me
        DELETE FROM MEDECIN
              WHERE ID_MEDECIN_ = p_id_medecin;

        IF SQL%ROWCOUNT = 0
        THEN
            RAISE NO_DATA_FOUND;
        END IF;

        -- Retourner un message indiquant que la suppression a ?t? effectu?e
        RETURN 'Le m?decin et les consultations associ?es ont ?t? supprim?s avec succ?s.';
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            RETURN ' Medecin ' || p_id_medecin || ' n''existe pas';
        WHEN OTHERS
        THEN
            -- En cas d'erreur, retourner un message d'erreur
            RETURN    'Erreur au niveau de la function MEDECIN_SUPPRIMER: '
                   || SQLCODE
                   || '-'
                   || SQLERRM;
    END MEDECIN_SUPPRIMER;


    -- MODIFIER SPECIALITE
    FUNCTION MEDECIN_MODIFIER_SPECIALITE (p_id_medecin   IN INTEGER,
                                          p_specialite   IN VARCHAR2)
        RETURN VARCHAR2
    AS
    BEGIN
        UPDATE MEDECIN
           SET SPECIALITE = p_specialite
         WHERE ID_MEDECIN_ = p_id_medecin;

        IF SQL%ROWCOUNT = 0
        THEN
            RAISE NO_DATA_FOUND;
        END IF;

        RETURN 'SUCCES';
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            RETURN ' Medecin ' || p_id_medecin || ' n''existe pas';
        WHEN OTHERS
        THEN
            RETURN    'Erreur au niveau de la function MEDECIN_MODIFIER_SPECIALITE : '
                   || SQLCODE
                   || '-'
                   || SQLERRM;
    END MEDECIN_MODIFIER_SPECIALITE;

    -- MODIFIER EMAIL TELEPHONE
    FUNCTION MEDECIN_MODIFIER_CONTACT (p_id_medecin          IN INTEGER,
                                       p_nouveau_telephone   IN VARCHAR2,
                                       p_nouvel_email        IN VARCHAR2)
        RETURN VARCHAR2
    AS
    BEGIN
        UPDATE MEDECIN
           SET TELEPHONE = p_nouveau_telephone, EMAIL = p_nouvel_email
         WHERE ID_MEDECIN_ = p_id_medecin;

        IF SQL%ROWCOUNT = 0
        THEN
            RAISE NO_DATA_FOUND;
        END IF;

        RETURN 'Mdification Reussie';
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            RETURN ' Medecin ' || p_id_medecin || ' n''existe pas';
        WHEN OTHERS
        THEN
            -- En cas d'erreur, retourner un message d'erreur
            RETURN    'Erreur au de la function MEDECIN_MODIFIER_CONTACT : '
                   || SQLCODE
                   || '-'
                   || SQLERRM;
    END MEDECIN_MODIFIER_CONTACT;

    FUNCTION MEDECIN_LISTER_ALL
        RETURN SYS_REFCURSOR
    AS
        C_MEDECIN   SYS_REFCURSOR;
    BEGIN
        OPEN C_MEDECIN FOR   SELECT ID_MEDECIN_,
                                    NOM,
                                    PRENOM,
                                    SPECIALITE,
                                    TELEPHONE,
                                    EMAIL
                               FROM MEDECIN
                           ORDER BY ID_MEDECIN_, NOM, PRENOM;

        RETURN C_MEDECIN;
    END MEDECIN_LISTER_ALL;


    FUNCTION MEDECIN_TOTAL
        RETURN NUMBER
    AS
        P_COUNT   INTEGER := 0;
    BEGIN
        SELECT COUNT (*) INTO P_COUNT FROM MEDECIN;

        RETURN P_COUNT;
    END MEDECIN_TOTAL;


    FUNCTION LISTE_PATIENT_CONSULTER_MEDECIN_JOUR (P_ID_MEDECIN   IN INTEGER,
                                                   P_DATE         IN DATE)
        RETURN SYS_REFCURSOR
    AS
        C_CONSULTATION   SYS_REFCURSOR;
    BEGIN
        OPEN C_CONSULTATION FOR
              SELECT P.NOM, P.PRENOM, P.EMAIL
                FROM PATIENT P
                     JOIN CONSULTATION C ON P.ID_PATIENT_ = C.ID_PATIENT_
               WHERE     C.ID_MEDECIN_ = P_ID_MEDECIN
                     AND C.DATE_CONSULTATION = P_DATE
            ORDER BY P.NOM, P.PRENOM, P.EMAIL;

        RETURN C_CONSULTATION;
    END LISTE_PATIENT_CONSULTER_MEDECIN_JOUR;

    FUNCTION NBRE_CONSULTATION_MEDECIN_JOUR (P_DATE IN DATE)
        RETURN SYS_REFCURSOR
    AS
        C_CONSULTATION   SYS_REFCURSOR;
    BEGIN
        OPEN C_CONSULTATION FOR
              SELECT M.NOM,
                     M.PRENOM,
                     M.SPECIALITE,
                     COUNT (C.ID_PATIENT_)     NBRE_PATIENT
                FROM MEDECIN M
                     JOIN CONSULTATION C ON M.ID_MEDECIN_ = C.ID_MEDECIN_
               WHERE C.DATE_CONSULTATION = P_DATE
            GROUP BY M.NOM, M.PRENOM, M.SPECIALITE
            ORDER BY M.NOM, M.SPECIALITE;

        RETURN C_CONSULTATION;
    END NBRE_CONSULTATION_MEDECIN_JOUR;

    FUNCTION NBRE_CONSULTATION_SPECIALITE_JOUR (P_DATE IN DATE)
        RETURN SYS_REFCURSOR
    AS
        C_CONSULTATION   SYS_REFCURSOR;
    BEGIN
        OPEN C_CONSULTATION FOR
              SELECT M.SPECIALITE, COUNT (C.ID_PATIENT_) NBRE_CONSULTATION
                FROM MEDECIN M
                     JOIN CONSULTATION C ON M.ID_MEDECIN_ = C.ID_MEDECIN_
               WHERE C.DATE_CONSULTATION = P_DATE
            GROUP BY M.SPECIALITE
            ORDER BY M.SPECIALITE;

        RETURN C_CONSULTATION;
    END NBRE_CONSULTATION_SPECIALITE_JOUR;
END PK_MEDECIN;
/*********************************** END BODY  PK_MEDECIN *************************************************/



/********************************** TEST PACKAGE  PK_MEDECIN *************************************************/


SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
    v_resultat             VARCHAR2 (200);
    v_cursor               SYS_REFCURSOR;
    c_medecin              MEDECIN%ROWTYPE;

    v_nom_patient          PATIENT.NOM%TYPE;
    v_prenom_patient       PATIENT.PRENOM%TYPE;
    v_email_patient        PATIENT.EMAIL%TYPE;

    v_nom_medecin          MEDECIN.NOM%TYPE;
    v_prenom_medecin       MEDECIN.PRENOM%TYPE;
    v_specialite_medecin   MEDECIN.SPECIALITE%TYPE;
    v_nbr_consultation     NUMBER;

    v_total                NUMBER;
BEGIN
    DBMS_OUTPUT.ENABLE (buffer_size => NULL);

    -- Test de la fonction MEDECIN_INSERER
    v_resultat :=
        PK_MEDECIN.MEDECIN_INSERER (p_id_medecin       => 30,
                                    p_nom_medecin      => 'Nom',
                                    p_prenom_medecin   => 'Pr�nom',
                                    p_specialite       => 'Sp�cialit�',
                                    p_telephone        => '12345678',
                                    p_email            => 'email@example.com');
    DBMS_OUTPUT.PUT_LINE ('R�sultat de MEDECIN_INSERER : ' || v_resultat);

    -- Test de la fonction MEDECIN_SUPPRIMER
    v_resultat := PK_MEDECIN.MEDECIN_SUPPRIMER (p_id_medecin => 1);
    DBMS_OUTPUT.PUT_LINE ('R�sultat de MEDECIN_SUPPRIMER : ' || v_resultat);

    -- Test de la fonction MEDECIN_MODIFIER_SPECIALITE
    v_resultat :=
        PK_MEDECIN.MEDECIN_MODIFIER_SPECIALITE (
            p_id_medecin   => 30,
            p_specialite   => 'Nouvelle sp�cialit�');
    DBMS_OUTPUT.PUT_LINE (
        'R�sultat de MEDECIN_MODIFIER_SPECIALITE : ' || v_resultat);

    -- Test de la fonction MEDECIN_MODIFIER_CONTACT
    v_resultat :=
        PK_MEDECIN.MEDECIN_MODIFIER_CONTACT (
            p_id_medecin          => 15,
            p_nouveau_telephone   => '87654321',
            p_nouvel_email        => 'new_email@example.com');
    DBMS_OUTPUT.PUT_LINE (
        'R�sultat de MEDECIN_MODIFIER_CONTACT : ' || v_resultat);

    -- Test de la fonction MEDECIN_LISTER_ALL
    v_cursor := PK_MEDECIN.MEDECIN_LISTER_ALL;

    -- Parcourir et afficher les r�sultats du curseur
    LOOP
        FETCH v_cursor INTO c_medecin;

        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE (
               'ID M�decin : '
            || c_medecin.id_medecin_
            || ', Nom : '
            || c_medecin.nom
            || ', Pr�nom : '
            || c_medecin.prenom
            || ', Sp�cialit� : '
            || c_medecin.specialite
            || ', T�l�phone : '
            || c_medecin.telephone
            || ', Email : '
            || c_medecin.email);
    END LOOP;

    CLOSE v_cursor;

    -- Test de la fonction MEDECIN_TOTAL
    v_total := PK_MEDECIN.MEDECIN_TOTAL;
    DBMS_OUTPUT.PUT_LINE ('Total des m�decins : ' || v_total);

    -- Test de la fonction LISTE_PATIENT_CONSULTER_MEDECIN_JOUR
    v_cursor :=
        PK_MEDECIN.LISTE_PATIENT_CONSULTER_MEDECIN_JOUR (
            P_ID_MEDECIN   => 2,
            P_DATE         => TO_DATE ('05/02/2024', 'DD/MM/YYYY'));

    -- Parcourir et afficher les r�sultats du curseur
    LOOP
        FETCH v_cursor INTO v_nom_patient, v_prenom_patient, v_email_patient;

        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE (
               'Nom Patient : '
            || v_nom_patient
            || ', Pr�nom Patient : '
            || v_prenom_patient
            || ', Email Patient : '
            || v_email_patient);
    END LOOP;

    CLOSE v_cursor;

    -- Test de la fonction NBRE_CONSULTATION_MEDECIN_JOUR
    v_cursor :=
        PK_MEDECIN.NBRE_CONSULTATION_MEDECIN_JOUR (
            P_DATE   => TO_DATE ('07/02/2024', 'DD/MM/YYYY'));

    -- Parcourir et afficher les r�sultats du curseur
    LOOP
        FETCH v_cursor
            INTO v_nom_medecin,
                 v_prenom_medecin,
                 v_specialite_medecin,
                 v_nbr_consultation;

        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE (
               'Nom M�decin : '
            || v_nom_medecin
            || ', Pr�nom M�decin : '
            || v_prenom_medecin
            || ', Sp�cialit� M�decin : '
            || v_specialite_medecin
            || ', Nombre de consultations : '
            || v_nbr_consultation);
    END LOOP;

    CLOSE v_cursor;

    -- Test de la fonction NBRE_CONSULTATION_SPECIALITE_JOUR
    v_cursor :=
        PK_MEDECIN.NBRE_CONSULTATION_SPECIALITE_JOUR (
            P_DATE   => TO_DATE ('08/02/2024', 'DD/MM/YYYY'));

    -- Parcourir et afficher les r�sultats du curseur
    LOOP
        FETCH v_cursor INTO v_specialite_medecin, v_nbr_consultation;

        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE (
               'Sp�cialit� M�decin : '
            || v_specialite_medecin
            || ', Nombre de consultations : '
            || v_nbr_consultation);
    END LOOP;

    CLOSE v_cursor;
END;

/****************************** END TEST PACKAGE PK_MEDECIN *************************************************/


/****************************** PACKAGE SPECIFICATION PK_CONSULTATION *************************************************/


CREATE OR REPLACE PACKAGE PK_CONSULTATION
AS
    FUNCTION CONSULTATION_INSERER (
        P_ID_CONSULTATION     IN consultation.ID_CONSULTATION_%TYPE,
        p_id_facture          IN consultation.ID_FACTURE_%TYPE,
        p_id_medecin          IN consultation.ID_MEDECIN_%TYPE,
        p_id_patient          IN consultation.ID_PATIENT_%TYPE,
        p_date_consultation   IN consultation.DATE_CONSULTATION%TYPE)
        RETURN VARCHAR2;

    FUNCTION CONSULTATION_SUPPRIMER (
        p_id_consultation   IN consultation.ID_CONSULTATION_%TYPE)
        RETURN VARCHAR2;

    FUNCTION CONSULTATION_MODIFIER_DATE (
        p_id_consultation   IN consultation.ID_CONSULTATION_%TYPE,
        p_nouvelle_date     IN consultation.DATE_CONSULTATION%TYPE)
        RETURN VARCHAR2;

    FUNCTION CONSULTATION_MODIFIER_PATIENT (
        p_id_consultation   IN consultation.ID_CONSULTATION_%TYPE,
        p_id_patient        IN consultation.ID_PATIENT_%TYPE)
        RETURN VARCHAR2;

    FUNCTION CONSULTATION_LISTER (p_id_medecin IN medecin.ID_MEDECIN_%TYPE)
        RETURN SYS_REFCURSOR;
END PK_CONSULTATION;

/****************************** END PACKAGE SPECIFICATION PK_CONSULTATION *************************************************/


/****************************** PACKAGE BODY PK_CONSULTATION *************************************************/


CREATE OR REPLACE PACKAGE BODY PK_CONSULTATION
AS
    FUNCTION CONSULTATION_INSERER (
        P_ID_CONSULTATION     IN consultation.ID_CONSULTATION_%TYPE,
        p_id_facture          IN consultation.ID_FACTURE_%TYPE,
        p_id_medecin          IN consultation.ID_MEDECIN_%TYPE,
        p_id_patient          IN consultation.ID_PATIENT_%TYPE,
        p_date_consultation   IN consultation.DATE_CONSULTATION%TYPE)
        RETURN VARCHAR2
    AS
        BAD_ID_PATIENT     EXCEPTION;
        BAD_ID_MEDECIN     EXCEPTION;
        BAD_ID_FACTURE     EXCEPTION;
        IS_PATIENT_EXIST   NUMBER;
        IS_MEDECIN_EXIST   NUMBER;
        IS_FACTURE_EXIST   NUMBER;
    BEGIN
        -- check if patient exist
        SELECT COUNT (*)
          INTO IS_PATIENT_EXIST
          FROM PATIENT
         WHERE ID_PATIENT_ = p_id_patient;

        IF IS_PATIENT_EXIST = 0
        THEN
            RAISE BAD_ID_PATIENT;
        END IF;

        -- check if medecin exist
        SELECT COUNT (*)
          INTO IS_MEDECIN_EXIST
          FROM MEDECIN
         WHERE ID_MEDECIN_ = p_id_medecin;

        IF IS_MEDECIN_EXIST = 0
        THEN
            RAISE BAD_ID_MEDECIN;
        END IF;

        -- check if facture exist
        SELECT COUNT (*)
          INTO IS_FACTURE_EXIST
          FROM FACTURE
         WHERE ID_FACTURE_ = p_id_facture;

        IF IS_FACTURE_EXIST = 0
        THEN
            RAISE BAD_ID_FACTURE;
        END IF;

        -- Ins�rez les donn�es dans la table
        INSERT INTO consultation (ID_CONSULTATION_,
                                  ID_FACTURE_,
                                  ID_MEDECIN_,
                                  ID_PATIENT_,
                                  DATE_CONSULTATION)
             VALUES (P_ID_CONSULTATION,
                     p_id_facture,
                     p_id_medecin,
                     p_id_patient,
                     p_date_consultation);

        RETURN 'Insertion Reussie';
    EXCEPTION
        WHEN BAD_ID_PATIENT
        THEN
            RETURN ' Patient  ' || p_id_patient || ' n''existe pas';
        WHEN BAD_ID_MEDECIN
        THEN
            RETURN ' Medecin  ' || p_id_medecin || ' n''existe pas';
        WHEN BAD_ID_FACTURE
        THEN
            RETURN ' Facture  ' || p_id_facture || ' n''existe pas';
        WHEN OTHERS
        THEN
            DBMS_OUTPUT.PUT_LINE (
                'Erreur CONSULTATION_INSERER : ' || SQLERRM);
            ROLLBACK;
    END CONSULTATION_INSERER;


    FUNCTION CONSULTATION_SUPPRIMER (
        p_id_consultation   IN consultation.ID_CONSULTATION_%TYPE)
        RETURN VARCHAR2
    AS
    BEGIN
        -- Supprimer les PRESCIPTIONS associEes au CONSULTTION
        DELETE FROM PRESCRIPTION
              WHERE ID_CONSULTATION_ = p_id_consultation;

        IF SQL%ROWCOUNT = 0
        THEN
            RAISE NO_DATA_FOUND;
        END IF;

        -- Supprimer les EXAMENS associEes au CONSULTTION
        DELETE FROM EXAMEN
              WHERE ID_CONSULTATION_ = p_id_consultation;

        IF SQL%ROWCOUNT = 0
        THEN
            RAISE NO_DATA_FOUND;
        END IF;

        -- Supprimer l'occurrence de la table consultation
        DELETE FROM consultation
              WHERE ID_CONSULTATION_ = p_id_consultation;

        IF SQL%ROWCOUNT = 0
        THEN
            RAISE NO_DATA_FOUND;
        END IF;

        -- Retourner un message indiquant que la suppression a ?t? effectu?e
        RETURN 'Les examens ,les prescription et les consultations associEes ont EtE supprimEs avec succEs.';
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            RETURN ' Consultation ' || p_id_consultation || ' n''existe pas';
        WHEN OTHERS
        THEN
            -- En cas d'erreur, retourner un message d'erreur
            RETURN    'Erreur au niveau de la fonction CONSULTATION_SUPPRIMER : '
                   || SQLCODE
                   || '-'
                   || SQLERRM;
    END CONSULTATION_SUPPRIMER;

    FUNCTION CONSULTATION_MODIFIER_DATE (
        p_id_consultation   IN consultation.ID_CONSULTATION_%TYPE,
        p_nouvelle_date     IN consultation.DATE_CONSULTATION%TYPE)
        RETURN VARCHAR2
    AS
    BEGIN
        -- Modifier la date de consultation pour l'ID de consultation sp�cifi�
        UPDATE consultation
           SET DATE_CONSULTATION = p_nouvelle_date
         WHERE ID_CONSULTATION_ = p_id_consultation;

        IF SQL%ROWCOUNT = 0
        THEN
            RAISE NO_DATA_FOUND;
        END IF;

        RETURN 'Modification Reussie';
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            RETURN ' Consultation ' || p_id_consultation || ' n''existe pas';
        WHEN OTHERS
        THEN
            RETURN    'Erreur au niveau de la fonction CONSULTATION_MODIFIER_DATE : '
                   || SQLCODE
                   || '-'
                   || SQLERRM;
    END CONSULTATION_MODIFIER_DATE;


    FUNCTION CONSULTATION_MODIFIER_PATIENT (
        p_id_consultation   IN consultation.ID_CONSULTATION_%TYPE,
        p_id_patient        IN consultation.ID_PATIENT_%TYPE)
        RETURN VARCHAR2
    AS
        BAD_ID_PATIENT     EXCEPTION;
        IS_PATIENT_EXIST   NUMBER;
    BEGIN
        SELECT COUNT (*)
          INTO IS_PATIENT_EXIST
          FROM PATIENT
         WHERE ID_PATIENT_ = p_id_patient;

        IF IS_PATIENT_EXIST = 0
        THEN
            --on l�ve l�exception
            RAISE BAD_ID_PATIENT;
        END IF;

        -- Modifier l'ID du patient pour l'ID de consultation sp�cifi�
        UPDATE consultation
           SET ID_PATIENT_ = p_id_patient
         WHERE ID_CONSULTATION_ = p_id_consultation;

        IF SQL%ROWCOUNT = 0
        THEN
            RAISE NO_DATA_FOUND;
        END IF;

        RETURN 'Modification Reussie';
    EXCEPTION
        WHEN BAD_ID_PATIENT
        THEN
            RETURN ' Patient  ' || p_id_patient || ' n''existe pas';
        WHEN NO_DATA_FOUND
        THEN
            RETURN ' Consultation ' || p_id_consultation || ' n''existe pas';
        WHEN OTHERS
        THEN
            RETURN    'Erreur au niveau de la fonction CONSULTATION_MODIFIER_PATIENT  : '
                   || SQLCODE
                   || '-'
                   || SQLERRM;
    END CONSULTATION_MODIFIER_PATIENT;


    FUNCTION CONSULTATION_LISTER (p_id_medecin IN medecin.ID_MEDECIN_%TYPE)
        RETURN SYS_REFCURSOR
    AS
        C_CONSULTATION   SYS_REFCURSOR;
    BEGIN
        OPEN C_CONSULTATION FOR SELECT *
                                  FROM consultation
                                 WHERE ID_MEDECIN_ = p_id_medecin;

        RETURN C_CONSULTATION;
    END CONSULTATION_LISTER;
END PK_CONSULTATION;

/****************************** END PACKAGE BODY PK_CONSULTATION *************************************************/



/****************************** TEST PACKAGE PK_CONSULTATION *************************************************/

DECLARE
    v_resultat           VARCHAR2 (200);
    C_CONSULTATION_REF   SYS_REFCURSOR;
    C_CONSULTATION       CONSULTATION%ROWTYPE;
BEGIN
    -- Test de la fonction CONSULTATION_INSERER avec des donn�es valides
    v_resultat :=
        PK_CONSULTATION.CONSULTATION_INSERER (
            P_ID_CONSULTATION     => 31,
            P_ID_FACTURE          => 101,
            P_ID_MEDECIN          => 1,
            P_ID_PATIENT          => 1,
            P_DATE_CONSULTATION   => SYSDATE);
    DBMS_OUTPUT.PUT_LINE (
           'R�sultat de CONSULTATION_INSERER avec des donn�es valides : '
        || v_resultat);

    -- Test de la fonction CONSULTATION_INSERER avec un ID de patient invalide
    v_resultat :=
        PK_CONSULTATION.CONSULTATION_INSERER (
            P_ID_CONSULTATION     => 32,
            P_ID_FACTURE          => 101,
            P_ID_MEDECIN          => 1,
            P_ID_PATIENT          => 100,
            P_DATE_CONSULTATION   => SYSDATE);
    DBMS_OUTPUT.PUT_LINE (
           'R�sultat de CONSULTATION_INSERER avec un ID de patient invalide : '
        || v_resultat);

    -- Test de la fonction CONSULTATION_SUPPRIMER
    v_resultat :=
        PK_CONSULTATION.CONSULTATION_SUPPRIMER (p_id_consultation => 2);
    DBMS_OUTPUT.PUT_LINE (
        'R�sultat de CONSULTATION_SUPPRIMER : ' || v_resultat);

    -- Test de la fonction CONSULTATION_MODIFIER_DATE
    v_resultat :=
        PK_CONSULTATION.CONSULTATION_MODIFIER_DATE (
            p_id_consultation   => 3,
            p_nouvelle_date     => SYSDATE);
    DBMS_OUTPUT.PUT_LINE (
        'R�sultat de CONSULTATION_MODIFIER_DATE : ' || v_resultat);

    -- Test de la fonction CONSULTATION_MODIFIER_PATIENT valide
    v_resultat :=
        PK_CONSULTATION.CONSULTATION_MODIFIER_PATIENT (
            p_id_consultation   => 3,
            p_id_patient        => 3);
    DBMS_OUTPUT.PUT_LINE (
           'R�sultat de CONSULTATION_MODIFIER_PATIENT avec un ID de patient valide : '
        || v_resultat);

    -- Test de la fonction CONSULTATION_MODIFIER_PATIENT avec un ID de patient invalide
    v_resultat :=
        PK_CONSULTATION.CONSULTATION_MODIFIER_PATIENT (
            p_id_consultation   => 2,
            p_id_patient        => 1000);
    DBMS_OUTPUT.PUT_LINE (
           'R�sultat de CONSULTATION_MODIFIER_PATIENT avec un ID de patient invalide : '
        || v_resultat);

    -- Test de la fonction CONSULTATION_MODIFIER_PATIENT avec un ID de consultation invalide
    v_resultat :=
        PK_CONSULTATION.CONSULTATION_MODIFIER_PATIENT (
            p_id_consultation   => 200,
            p_id_patient        => 1);
    DBMS_OUTPUT.PUT_LINE (
           'R�sultat de CONSULTATION_MODIFIER_PATIENT avec un ID de consultation invalide : '
        || v_resultat);

    -- Test de la fonction CONSULTATION_LISTER
    C_CONSULTATION_REF := PK_CONSULTATION.CONSULTATION_LISTER (1);

    -- Parcourir et afficher les r�sultats du curseur
    LOOP
        FETCH C_CONSULTATION_REF INTO C_CONSULTATION;

        EXIT WHEN C_CONSULTATION_REF%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE (
               'ID Consultation : '
            || C_CONSULTATION.ID_CONSULTATION_
            || ', ID Facture : '
            || C_CONSULTATION.ID_FACTURE_
            || ', ID M�decin : '
            || C_CONSULTATION.ID_MEDECIN_
            || ', ID Patient : '
            || C_CONSULTATION.ID_PATIENT_
            || ', Date Consultation : '
            || TO_CHAR (C_CONSULTATION.DATE_CONSULTATION, 'DD-MON-YYYY'));
    END LOOP;

    CLOSE C_CONSULTATION_REF;
END;

/****************************** END TEST PACKAGE PK_CONSULTATION *************************************************/



/********************************** TRIGGERS *************************************************/

-- Creation de la table historique des factures POUR LES TRIGGERS

CREATE TABLE HISTORIQUE_FACTURE
(
    ID_FACTURE_          INTEGER NOT NULL,
    ID_PATIENT_          INTEGER NOT NULL,
    OLD_MONTANT_TOTAL    NUMBER (15, 2),
    NEW_MONTANT_TOTAL    NUMBER (15, 2),
    OLD_DATE_FACTURE     DATE,
    NEW_DATE_FACTURE     DATE,
    ACTION               VARCHAR2 (30)
);

CREATE OR REPLACE TRIGGER TG_CTRL_RENDEZ_VOUS_DOUBLE
    BEFORE INSERT OR UPDATE
    ON RENDEZ_VOUS
    FOR EACH ROW
DECLARE
    V_COUNT   NUMBER;
BEGIN
    SELECT COUNT (*)
      INTO V_COUNT
      FROM RENDEZ_VOUS
     WHERE     ID_PATIENT_ = :NEW.ID_PATIENT_
           AND ID_MEDECIN_ = :NEW.ID_MEDECIN_
           AND DATE_RENDEZ_VOUS = :NEW.DATE_RENDEZ_VOUS;

    IF V_COUNT > 0
    THEN
        RAISE_APPLICATION_ERROR (-20101, 'UN Rendez-vous pour ce patient 
    avec ce medecin a cette date existe deja');
    END IF;
END;


CREATE OR REPLACE TRIGGER TG_HISTORIQUE_FACTURE
    AFTER INSERT OR UPDATE OR DELETE
    ON FACTURE
    FOR EACH ROW
BEGIN
    IF INSERTING
    THEN
        INSERT INTO HISTORIQUE_FACTURE (ID_FACTURE_,
                                        ID_PATIENT_,
                                        OLD_MONTANT_TOTAL,
                                        NEW_MONTANT_TOTAL,
                                        OLD_DATE_FACTURE,
                                        NEW_DATE_FACTURE,
                                        ACTION)
             VALUES (:NEW.ID_FACTURE_,
                     :NEW.ID_PATIENT_,
                     NULL,
                     :NEW.MONTANT_TOTAL,
                     NULL,
                     :NEW.DATE_FACTURE,
                     'INSERTION');
    END IF;

    IF UPDATING ('MONTANT_TOTAL')
    THEN
        INSERT INTO HISTORIQUE_FACTURE (ID_FACTURE_,
                                        ID_PATIENT_,
                                        OLD_MONTANT_TOTAL,
                                        NEW_MONTANT_TOTAL,
                                        OLD_DATE_FACTURE,
                                        NEW_DATE_FACTURE,
                                        ACTION)
             VALUES (:OLD.ID_FACTURE_,
                     :OLD.ID_PATIENT_,
                     :OLD.MONTANT_TOTAL,
                     :NEW.MONTANT_TOTAL,
                     :OLD.DATE_FACTURE,
                     :NEW.DATE_FACTURE,
                     'MODIFICATION');
    END IF;

    IF DELETING
    THEN
        -- DELETE
        INSERT INTO HISTORIQUE_FACTURE (ID_FACTURE_,
                                        ID_PATIENT_,
                                        OLD_MONTANT_TOTAL,
                                        NEW_MONTANT_TOTAL,
                                        OLD_DATE_FACTURE,
                                        NEW_DATE_FACTURE,
                                        ACTION)
             VALUES (:OLD.ID_FACTURE_,
                     :OLD.ID_PATIENT_,
                     :OLD.MONTANT_TOTAL,
                     NULL,
                     :OLD.DATE_FACTURE,
                     NULL,
                     'SUPPRESSION');

        -- UPDATE CONSULTATION
        UPDATE CONSULTATION
           SET ID_FACTURE_ = NULL
         WHERE ID_FACTURE_ = :OLD.ID_FACTURE_;
    END IF;
END;

/********************************** END TRIGGERS *************************************************/



/********************************** TESTS TRIGGERS *************************************************/


-- Test pour le trigger TG_CTRL_RENDEZ_VOUS_DOUBLE

DECLARE
    v_count   NUMBER;
BEGIN
    -- Tester l'insertion d'un rendez-vous pour un m�me patient, m�decin et date
    INSERT INTO RENDEZ_VOUS (ID_PATIENT_, ID_MEDECIN_, DATE_RENDEZ_VOUS)
         VALUES (1, 1, TO_DATE ('10/02/2024', 'DD/MM/YYYY'));
EXCEPTION
    WHEN OTHERS
    THEN
        -- Capturer l'erreur lev�e par le trigger et l'afficher
        DBMS_OUTPUT.PUT_LINE ('Erreur : ' || SQLERRM);
        -- Rollback pour annuler les modifications effectu�es pendant le test
        ROLLBACK;
END;
/

/*<TOAD_FILE_CHUNK>*/
-- Test pour le trigger TG_HISTORIQUE_FACTURE

DECLARE
    v_count   NUMBER;
BEGIN
    -- Ins�rer une facture
    INSERT INTO FACTURE (ID_FACTURE_,
                         ID_PATIENT_,
                         MONTANT_TOTAL,
                         DATE_FACTURE)
         VALUES (30,
                 1,
                 100.00,
                 SYSDATE);

    -- Mettre � jour le montant total de la facture
    UPDATE FACTURE
       SET MONTANT_TOTAL = 150.00
     WHERE ID_FACTURE_ = 30;

    -- Supprimer la facture
    DELETE FROM FACTURE
          WHERE ID_FACTURE_ = 30;
EXCEPTION
    WHEN OTHERS
    THEN
        -- Capturer l'erreur lev�e par le trigger et l'afficher
        DBMS_OUTPUT.PUT_LINE ('Erreur : ' || SQLERRM);
        -- Rollback pour annuler les modifications effectu�es pendant le test
        ROLLBACK;
END;
/

/*<TOAD_FILE_CHUNK>*/
-- V�rification des donn�es dans la table HISTORIQUE_FACTURE apr�s les op�rations
-- Assurez-vous de v�rifier la table HISTORIQUE_FACTURE pour voir les entr�es de journalisation ins�r�es par les d�clencheurs
SELECT * FROM HISTORIQUE_FACTURE;

/********************************** END TESTS TRIGGERS *************************************************/

