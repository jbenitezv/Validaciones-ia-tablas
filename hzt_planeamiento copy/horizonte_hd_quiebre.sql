/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_HD_QUIEBRE
  FECHA DE CREACIÓN: 18/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/


CREATE OR REPLACE TABLE `{horizonte_project_id}.hzt_planeamiento.horizonte_hd_quiebre`(
    des_origen                    STRING          OPTIONS (description = "Nombre de tabla origen"),
  val_rownum                              INT64           OPTIONS (description="Numero de fila"),
  mes_natural INT64,
  dia_natural DATE,
  categoria_id STRING,
  categoria STRING,
  cod_sociedad STRING,
  cod_tipo_material STRING,
  familia STRING,
  material_id STRING,
  material STRING,
  centro_id STRING,
  centro STRING,
  duenio_marca STRING,
  duenio_descripcion STRING,
  negocio_id STRING,
  negocio STRING,
  dia_quiebre NUMERIC(18,4),
  relev_quiebre NUMERIC(18,4),
  dia_quiebre_porcentaje NUMERIC(18,4),
  mes INT64,
  dia INT64,
  empresa_id STRING,
  empresa STRING,
  alicorp NUMERIC(18,4),
  relev_quie_alicorp NUMERIC(18,4),
  intradevco NUMERIC(18,4),
  relev_quie_itdc NUMERIC(18,4),
  pareto STRING,
  centro_final STRING,
  sku STRING,
  sku_cd STRING,
  flg_percent_alicorp INT64,
  flg_percent_alicorp_is_positive INT64,
  flg_percent_intradevco INT64,
  flg_percent_intradevco_is_positive INT64,
  flg_percent_total INT64,
  flg_percent_total_is_positive INT64,
  val_dbkey                                 STRING          OPTIONS (description="Identificador único")
)
OPTIONS (
    description = 'Tabla relacionada a control tower'
);
