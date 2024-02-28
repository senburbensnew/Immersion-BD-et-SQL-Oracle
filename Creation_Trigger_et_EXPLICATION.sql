/* Formatted on 25/02/2024 19:43:30 (QP5 v5.360) */
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



/**

Voici les définitions textuelles des deux triggers :

1. **Trigger `TG_CTRL_RENDEZ_VOUS_DOUBLE`** :
   - **Objectif :** Empêcher la création de rendez-vous en doublon pour un même patient avec un même médecin à la même date.
   - **Déclenchement :** Avant l'insertion ou la mise à jour dans la table `RENDEZ_VOUS`.
   - **Action :** 
     - Le trigger vérifie s'il existe déjà un rendez-vous pour le nouveau patient avec le nouveau médecin à la nouvelle date spécifiée.
     - Si un rendez-vous en doublon est trouvé, une erreur est levée pour signaler que le rendez-vous existe déjà pour ce patient avec ce médecin à cette date.

2. **Trigger `TG_HISTORIQUE_FACTURE`** :
   - **Objectif :** Maintenir un historique des modifications apportées aux factures.
   - **Déclenchement :** Après l'insertion, la mise à jour ou la suppression dans la table `FACTURE`.
   - **Action :** 
     - Si une nouvelle facture est insérée (`INSERTING`), les détails de la facture sont insérés dans la table `HISTORIQUE_FACTURE` avec l'action 'INSERTION'.
     - Si une facture est mise à jour et que la colonne `MONTANT_TOTAL` est modifiée (`UPDATING ('MONTANT_TOTAL')`), les anciennes et nouvelles valeurs du montant ainsi que la date de la modification sont insérées dans la table `HISTORIQUE_FACTURE` avec l'action 'MODIFICATION'.
     - Si une facture est supprimée (`DELETING`), les détails de la facture avant sa suppression sont insérés dans la table `HISTORIQUE_FACTURE` avec l'action 'SUPPRESSION'. De plus, toute référence à cette facture dans la table `CONSULTATION` est supprimée en mettant à jour la colonne `ID_FACTURE_` à NULL.

**/