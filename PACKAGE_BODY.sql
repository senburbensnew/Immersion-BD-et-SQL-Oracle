/* Formatted on 27/02/2024 21:35:31 (QP5 v5.360) */
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
        -- Insertion des données dans la table MEDECIN en utilisant les paramètres passés
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

        COMMIT;                                         -- Valider l'insertion
    END MEDECIN_INSERER;

    -- FUNCTION SUPPRIMER
    FUNCTION MEDECIN_SUPPRIMER (p_id_medecin IN INTEGER)
        RETURN VARCHAR2
    AS
    BEGIN
        -- Supprimer les consultations associées au médecin
        DELETE FROM CONSULTATION
              WHERE ID_MEDECIN_ = p_id_medecin;

        -- Supprimer le médecin lui-même
        DELETE FROM MEDECIN
              WHERE ID_MEDECIN_ = p_id_medecin;

        -- Retourner un message indiquant que la suppression a été effectuée
        RETURN 'Le médecin et les consultations associées ont été supprimés avec succès.';
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            RETURN ' Medecin ' || p_id_medecin || ' n''existe pas';
        WHEN OTHERS
        THEN
            -- En cas d'erreur, retourner un message d'erreur
            RETURN    'Une erreur s''est produite : '
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

        RETURN 'SUCCES';
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            RETURN ' Medecin ' || p_id_medecin || ' n''existe pas';
        WHEN OTHERS
        THEN
            RETURN    'Une erreur s''est produite : '
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
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            RETURN ' Medecin ' || p_id_medecin || ' n''existe pas';
        WHEN OTHERS
        THEN
            -- En cas d'erreur, retourner un message d'erreur
            RETURN    'Une erreur s''est produite : '
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