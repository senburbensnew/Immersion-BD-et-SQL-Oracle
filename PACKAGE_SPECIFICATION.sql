/* Formatted on 27/02/2024 21:35:17 (QP5 v5.360) */
CREATE OR REPLACE PACKAGE BOB.PK_MEDECIN
AS
    -- Déclaration de la fonction AInserer pour insérer des données dans la table MEDECIN
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