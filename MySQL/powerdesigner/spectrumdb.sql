/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     2016/10/5 22:33:20                           */
/*==============================================================*/


drop table if exists Spectrumdata;

drop table if exists Spectrumtype;

/*==============================================================*/
/* Table: Spectrumdata                                          */
/*==============================================================*/
create table Spectrumdata
(
   SpecturmdataID       int not null auto_increment,
   SpectrumtypeID       int,
   Timex                decimal(12,4),
   PressureGZB          decimal(12,4),
   PressureDBDQ         decimal(12,4),
   PressureDBXQ         decimal(12,4),
   PressureZZX          decimal(12,4),
   PressureYZX          decimal(12,4),
   PressureZDDQ         decimal(12,4),
   PressureZDXQ         decimal(12,4),
   PressureZXB          decimal(12,4),
   PressureQJD          decimal(12,4),
   PressureHTD          decimal(12,4),
   PressureF1           decimal(12,4),
   PressureF2           decimal(12,4),
   PressureF3           decimal(12,4),
   PressureF4           decimal(12,4),
   PressureBSX          decimal(12,4),
   PressureQNJ          decimal(12,4),
   PressureHNJ          decimal(12,4),
   PressureBJQCK        decimal(12,4),
   PressureBJQJK        decimal(12,4),
   Acce1                decimal(12,4),
   Acce2                decimal(12,4),
   Acce3                decimal(12,4),
   SpeedWL              decimal(12,4),
   SpeedSCZ             decimal(12,4),
   primary key (SpecturmdataID)
);

/*==============================================================*/
/* Table: Spectrumtype                                          */
/*==============================================================*/
create table Spectrumtype
(
   SpectrumtypeID       int not null auto_increment,
   Driver               varchar(50),
   Object               varchar(50),
   Power                varchar(50),
   Modex                varchar(50),
   Groupx               varchar(50),
   primary key (SpectrumtypeID)
);

alter table Spectrumdata add constraint FK_type_ref_data foreign key (SpectrumtypeID)
      references Spectrumtype (SpectrumtypeID) on delete restrict on update restrict;

