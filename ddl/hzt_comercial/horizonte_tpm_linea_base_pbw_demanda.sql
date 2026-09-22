/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_TMP_LINEA_BASE_PWD_DEMANDA
  FECHA DE CREACIÓN: 18/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

create or replace table `{horizonte_project_id}.hzt_comercial.horizonte_tpm_linea_base_pbw_demanda`(
  des_origen STRING OPTIONS(description="Nombre de tabla origen"),
  val_rownum INT64 OPTIONS(description="Número de fila"),
  cod_sociedad STRING OPTIONS(description="Código de sociedad"),
  tip_canal STRING OPTIONS(description="Tipo de canal"), -- canal
  cod_cliente STRING OPTIONS(description="Código de cliente"),
  cod_organizacion_venta STRING OPTIONS(description="Código de organización de venta"),
  val_subdominio STRING OPTIONS(description="Valor de subdominio"), -- negocio
  nom_cliente STRING OPTIONS(description="Nombre de cliente"),
  nom_columna_cruce STRING OPTIONS(description="Nombre de columna de cruce"),
  cod_material STRING OPTIONS(description="Código de material"),
  nom_material STRING OPTIONS(description="Nombre de material"),
  val_categoria STRING OPTIONS(description="Valor de categoría"), -- categoria
  val_familia STRING OPTIONS(description="Valor de familia"), -- familia
  des_gramaje STRING OPTIONS(description="Descripción de gramaje"), -- gramaje
  num_linea_base_ton_pbw NUMERIC(18,4) OPTIONS(description="Línea base ton PBW"), -- linea_base_ton_pbw
  num_core NUMERIC(18,4) OPTIONS(description="Core"), -- core
  num_value NUMERIC(18,4) OPTIONS(description="Value"), -- value
  num_intradevco NUMERIC(18,4) OPTIONS(description="Intradevco"), -- intradevco
  num_alicorp_solucion NUMERIC(18,4) OPTIONS(description="Alicorp solución"), -- alicorp_soluciones
  num_linea_base_ton_demanda NUMERIC(18,4) OPTIONS(description="Línea base ton demanda"), -- linea_base_ton_demanda
  flg_valida_ton INT64 OPTIONS(description="Indicador de validación ton"),
  mnt_porcentaje_variacion NUMERIC(18,4) OPTIONS(description="Porcentaje de variación"),
  val_dbkey STRING OPTIONS(description="Identificador único")
)
OPTIONS(description="Línea base PBW demanda");