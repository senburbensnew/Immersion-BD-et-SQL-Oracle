/*==============================================================*/
/* Nom de SGBD :  ORACLE Version 11g                            */
/* Date de cr�ation :  04/02/2024 15:35:29                      */
/*==============================================================*/


alter table CONSULTATION
   drop constraint FK_CONSULTA_EFFECTUER_MEDECIN;

alter table CONSULTATION
   drop constraint FK_CONSULTA_INCLURE_FACTURE;

alter table CONSULTATION
   drop constraint FK_CONSULTA_PASSER_PATIENT;

alter table EXAMEN
   drop constraint FK_EXAMEN_CONTENIR__CONSULTA;

alter table FACTURE
   drop constraint FK_FACTURE_RECEVOIR_PATIENT;

alter table PRESCRIPTION
   drop constraint FK_PRESCRIP_CONTENIR__CONSULTA;

alter table RENDEZ_VOUS
   drop constraint FK_RENDEZ_V_RENDEZ_VO_MEDECIN;

alter table RENDEZ_VOUS
   drop constraint FK_RENDEZ_V_RENDEZ_VO_PATIENT;

drop table CONSULTATION cascade constraints;

drop table EXAMEN cascade constraints;

drop table FACTURE cascade constraints;

drop table MEDECIN cascade constraints;

drop table PATIENT cascade constraints;

drop table PRESCRIPTION cascade constraints;

drop table RENDEZ_VOUS cascade constraints;

/*==============================================================*/
/* Table : CONSULTATION                                         */
/*==============================================================*/
create table CONSULTATION 
(
   ID_CONSULTATION_     INTEGER              not null,
   ID_FACTURE_          INTEGER              not null,
   ID_MEDECIN_          INTEGER              not null,
   ID_PATIENT_          INTEGER              not null,
   DATE_CONSULTATION    DATE                 not null,
   constraint PK_CONSULTATION primary key (ID_CONSULTATION_)
);

/*==============================================================*/
/* Table : EXAMEN                                               */
/*==============================================================*/
create table EXAMEN 
(
   ID_EXAMEN_           INTEGER              not null,
   ID_CONSULTATION_     INTEGER              not null,
   DETAILS_EXAMEN       VARCHAR2(100)        not null,
   DATE_EXAMEN          DATE                 not null,
   constraint PK_EXAMEN primary key (ID_EXAMEN_)
);

/*==============================================================*/
/* Table : FACTURE                                              */
/*==============================================================*/
create table FACTURE 
(
   ID_FACTURE_          INTEGER              not null,
   ID_PATIENT_          INTEGER              not null,
   MONTANT_TOTAL        NUMBER(15,2)         not null,
   DATE_FACTURE         DATE                 not null,
   constraint PK_FACTURE primary key (ID_FACTURE_)
);

/*==============================================================*/
/* Table : MEDECIN                                              */
/*==============================================================*/
create table MEDECIN 
(
   ID_MEDECIN_          INTEGER              not null,
   NOM                  VARCHAR2(50)         not null,
   PRENOM               VARCHAR2(50)         not null,
   SPECIALITE           VARCHAR2(50)         not null,
   TELEPHONE            VARCHAR2(8)          not null,
   EMAIL                VARCHAR2(50)         not null,
   constraint PK_MEDECIN primary key (ID_MEDECIN_)
);

/*==============================================================*/
/* Table : PATIENT                                              */
/*==============================================================*/
create table PATIENT 
(
   ID_PATIENT_          INTEGER              not null,
   NOM                  VARCHAR2(50)         not null,
   PRENOM               VARCHAR2(50)         not null,
   ADRESSE              VARCHAR2(100),
   EMAIL                VARCHAR2(50),
   DATE_NAISSAINCE      DATE                 not null,
   constraint PK_PATIENT primary key (ID_PATIENT_)
);

/*==============================================================*/
/* Table : PRESCRIPTION                                         */
/*==============================================================*/
create table PRESCRIPTION 
(
   ID_PRESCRIPTION_     INTEGER              not null,
   ID_CONSULTATION_     INTEGER              not null,
   DETAILS_PRESCRIPTION VARCHAR2(100)        not null,
   DATE_PRESCRIPTION    DATE                 not null,
   constraint PK_PRESCRIPTION primary key (ID_PRESCRIPTION_)
);

/*==============================================================*/
/* Table : RENDEZ_VOUS                                          */
/*==============================================================*/
create table RENDEZ_VOUS 
(
   ID_PATIENT_          INTEGER              not null,
   ID_MEDECIN_          INTEGER              not null,
   DATE_RENDEZ_VOUS     DATE                 not null,
   constraint PK_RENDEZ_VOUS primary key (ID_PATIENT_, ID_MEDECIN_)
);


alter table CONSULTATION
   add constraint FK_CONSULTA_EFFECTUER_MEDECIN foreign key (ID_MEDECIN_)
      references MEDECIN (ID_MEDECIN_);

alter table CONSULTATION
   add constraint FK_CONSULTA_INCLURE_FACTURE foreign key (ID_FACTURE_)
      references FACTURE (ID_FACTURE_);

alter table CONSULTATION
   add constraint FK_CONSULTA_PASSER_PATIENT foreign key (ID_PATIENT_)
      references PATIENT (ID_PATIENT_);

alter table EXAMEN
   add constraint FK_EXAMEN_CONTENIR__CONSULTA foreign key (ID_CONSULTATION_)
      references CONSULTATION (ID_CONSULTATION_);

alter table FACTURE
   add constraint FK_FACTURE_RECEVOIR_PATIENT foreign key (ID_PATIENT_)
      references PATIENT (ID_PATIENT_);

alter table PRESCRIPTION
   add constraint FK_PRESCRIP_CONTENIR__CONSULTA foreign key (ID_CONSULTATION_)
      references CONSULTATION (ID_CONSULTATION_);

alter table RENDEZ_VOUS
   add constraint FK_RENDEZ_V_RENDEZ_VO_MEDECIN foreign key (ID_MEDECIN_)
      references MEDECIN (ID_MEDECIN_);

alter table RENDEZ_VOUS
   add constraint FK_RENDEZ_V_RENDEZ_VO_PATIENT foreign key (ID_PATIENT_)
      references PATIENT (ID_PATIENT_);

