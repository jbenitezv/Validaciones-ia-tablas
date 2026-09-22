/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_TMP_PBW_BLOQUEADO
  FECHA DE CREACIÓN: 21/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

create or replace table `{horizonte_project_id}.hzt_comercial.horizonte_tpm_pbw_bloqueado`(
  des_origen STRING OPTIONS(description="Nombre de tabla origen"),
  val_rownum INT64 OPTIONS(description="Número de fila"),
  cod_sociedad STRING OPTIONS(description="Código de sociedad"),
  cod_material STRING OPTIONS(description="Código de material"),
  cod_plan_cbp STRING OPTIONS(description="Código de plan CBP"), -- plan_cbp
  cod_interlocutor STRING OPTIONS(description="Código de interlocutor"), -- interlocutor
  des_bloqueo STRING OPTIONS(description="Descripción de bloqueo"),
  flg_bloqueado INT64 OPTIONS(description="Indicador de bloqueo"),
  cod_jerarquia STRING OPTIONS(description="Código de jerarquía"),
  cod_plataforma STRING OPTIONS(description="Código de plataforma"),
  des_plataforma STRING OPTIONS(description="Descripción de plataforma"),
  cod_subplataforma STRING OPTIONS(description="Código de subplataforma"),
  des_subplataforma STRING OPTIONS(description="Descripción de subplataforma"),
  cod_categoria STRING OPTIONS(description="Código de categoría"),
  des_categoria STRING OPTIONS(description="Descripción de categoría"),
  cod_familia STRING OPTIONS(description="Código de familia"),
  des_familia STRING OPTIONS(description="Descripción de familia"),
  cod_variedad STRING OPTIONS(description="Código de variedad"),
  des_variedad STRING OPTIONS(description="Descripción de variedad"),
  cod_presentacion STRING OPTIONS(description="Código de presentación"),
  des_presentacion STRING OPTIONS(description="Descripción de presentación"),
  fec_carga STRING OPTIONS(description="Fecha de carga"), -- fecha_carga
  val_dbkey STRING OPTIONS(description="Identificador único")
)
OPTIONS(description="PBW bloqueado");