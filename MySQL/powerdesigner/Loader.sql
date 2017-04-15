/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     2016/10/10 21:31:45                          */
/*==============================================================*/


drop table if exists CarInfo;

drop table if exists CarframeInfo;

drop table if exists EngineCurve;

drop table if exists EngineInfo;

drop table if exists GearInfo;

drop table if exists TractionEfficiency;

drop table if exists TurbineCurve;

drop table if exists TurbineInfo;

/*==============================================================*/
/* Table: CarInfo                                               */
/*==============================================================*/
create table CarInfo
(
   CarName              varchar(50) not null,
   TurbineName          varchar(50),
   EngineName           varchar(50),
   GearName             varchar(50),
   CarframeName         varchar(50),
   primary key (CarName)
);

/*==============================================================*/
/* Table: CarframeInfo                                          */
/*==============================================================*/
create table CarframeInfo
(
   CarframeName         varchar(50) not null,
   DriveAxleSpeedRatio  decimal(8,4),
   Roll                 decimal(12,4),
   MaxV                 decimal(12,4),
   MaxF                 decimal(12,4),
   WeightEmpty          decimal(12,4),
   WeightFull           decimal(12,4),
   primary key (CarframeName)
);

/*==============================================================*/
/* Table: EngineCurve                                           */
/*==============================================================*/
create table EngineCurve
(
   EngineCurveID        int not null auto_increment,
   EngineName           varchar(50),
   Me                   decimal(12,4),
   P                    decimal(12,4),
   ge                   decimal(12,4),
   n                    decimal(12,4),
   EngineGroupx         int,
   primary key (EngineCurveID)
);

/*==============================================================*/
/* Table: EngineInfo                                            */
/*==============================================================*/
create table EngineInfo
(
   EngineName           varchar(50) not null,
   RatedPower           decimal(12,4),
   RatedSpeed           decimal(12,4),
   MaxTorqueSpeed       decimal(12,4),
   MaxTorque            decimal(12,4),
   NumCylinder          int,
   DCylinder            decimal(12,4),
   PistonStroke         decimal(12,4),
   PistonDisplacement   decimal(12,4),
   CompressionRatio     decimal(12,4),
   Lengthx              decimal(12,4),
   Width                decimal(12,4),
   Height               decimal(12,4),
   Weight               decimal(12,4),
   primary key (EngineName)
);

/*==============================================================*/
/* Table: GearInfo                                              */
/*==============================================================*/
create table GearInfo
(
   GearName             varchar(50) not null,
   F1                   decimal(8,4),
   F2                   decimal(8,4),
   F3                   decimal(8,4),
   F4                   decimal(8,4),
   R1                   decimal(8,4),
   R2                   decimal(8,4),
   R3                   decimal(8,4),
   primary key (GearName)
);

/*==============================================================*/
/* Table: TractionEfficiency                                    */
/*==============================================================*/
create table TractionEfficiency
(
   TractionEfficiencyID int not null auto_increment,
   TurbineName          varchar(50),
   VF1                  decimal(12,4),
   FF1                  decimal(12,4),
   GradientF1           decimal(12,4),
   alphaF1              decimal(12,4),
   VF2                  decimal(12,4),
   FF2                  decimal(12,4),
   GradientF2           decimal(12,4),
   alphaF2              decimal(12,4),
   VF3                  decimal(12,4),
   FF3                  decimal(12,4),
   GradientF3           decimal(12,4),
   alphaF3              decimal(12,4),
   VF4                  decimal(12,4),
   FF4                  decimal(12,4),
   GradientF4           decimal(12,4),
   alphaF4              decimal(12,4),
   efficiency           decimal(12,4),
   TractionGroupx       int,
   primary key (TractionEfficiencyID)
);

/*==============================================================*/
/* Table: TurbineCurve                                          */
/*==============================================================*/
create table TurbineCurve
(
   TurbineCurveID       int not null auto_increment,
   TurbineName          varchar(50),
   K                    decimal(12,4),
   i                    decimal(12,4),
   nt                   decimal(12,4),
   Mt                   decimal(12,4),
   lamda                decimal(12,4),
   TurbineGroupx        int,
   primary key (TurbineCurveID)
);

/*==============================================================*/
/* Table: TurbineInfo                                           */
/*==============================================================*/
create table TurbineInfo
(
   TurbineName          varchar(50) not null,
   TurbineD             decimal(8,4),
   TurbineRatedSpeed    decimal(12,4),
   TurbineMaxTorque     decimal(12,4),
   TurbineRatedPower    decimal(12,4),
   primary key (TurbineName)
);

alter table CarInfo add constraint FK_carframe_ref_car foreign key (CarframeName)
      references CarframeInfo (CarframeName) on delete restrict on update restrict;

alter table CarInfo add constraint FK_engine_ref_car foreign key (EngineName)
      references EngineInfo (EngineName) on delete restrict on update restrict;

alter table CarInfo add constraint FK_gear_ref_car foreign key (GearName)
      references GearInfo (GearName) on delete restrict on update restrict;

alter table CarInfo add constraint FK_turbine_ref_car foreign key (TurbineName)
      references TurbineInfo (TurbineName) on delete restrict on update restrict;

alter table EngineCurve add constraint FK_engine_ref_enginecurve foreign key (EngineName)
      references EngineInfo (EngineName) on delete restrict on update restrict;

alter table TractionEfficiency add constraint FK_tractionefficiency_ref_turbine foreign key (TurbineName)
      references TurbineInfo (TurbineName) on delete restrict on update restrict;

alter table TurbineCurve add constraint FK_turbine_ref_turbinecurve foreign key (TurbineName)
      references TurbineInfo (TurbineName) on delete restrict on update restrict;

