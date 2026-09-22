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
  num_mes_natural INT64 OPTIONS(description="Numero de mes natural"),
  num_dia_natural DATE OPTIONS(description="Fecha de dia natural"),
  id_categoria STRING OPTIONS(description="Identificador de la categoria"),
  des_categoria STRING OPTIONS(description="Descripcion de la categoria del material"),
  cod_sociedad STRING OPTIONS(description="Codigo de sociedad"),
  cod_tipo_material STRING OPTIONS(description="Codigo de tipo material"),
  des_familia STRING OPTIONS(description="Descripcion de la familia del material"),
  id_material STRING OPTIONS(description="Identificador unico del material"),
  des_material STRING OPTIONS(description="Descripcion del material"),
  id_centro STRING OPTIONS(description="Identificador unico del centro"),
  des_centro STRING OPTIONS(description="Descripcion del centro"),
  des_duenio_marca STRING OPTIONS(description="Descripcion del dueno de marca"),
  des_duenio_descripcion STRING OPTIONS(description="Descripcion detallada del dueno de marca"),
  id_negocio STRING OPTIONS(description="Identificador del negocio"),
  des_negocio STRING OPTIONS(description="Descripcion del negocio"),
  num_dia_quiebre NUMERIC(18,4) OPTIONS(description="Numero de dias de quiebre"),
  num_relev_quiebre NUMERIC(18,4) OPTIONS(description="Numero relevante de quiebre"),
  prc_dia_quiebre NUMERIC(18,4) OPTIONS(description="Porcentaje de dias de quiebre"),
  num_mes INT64 OPTIONS(description="Numero de mes"),
  num_dia INT64 OPTIONS(description="Numero de dia"),
  id_empresa STRING OPTIONS(description="Identificador de la empresa"),
  des_empresa STRING OPTIONS(description="Descripcion de la empresa"),
  des_alicorp NUMERIC(18,4) OPTIONS(description="Monto de Alicorp"),
  num_relev_quie_alicorp NUMERIC(18,4) OPTIONS(description="Numero relevante de quiebre Alicorp"),
  des_intradevco NUMERIC(18,4) OPTIONS(description="Monto de Intradevco"),
  num_relev_quie_itdc NUMERIC(18,4) OPTIONS(description="Numero relevante de quiebre Intradevco"),
  des_pareto STRING OPTIONS(description="Descripcion del pareto"),
  des_centro_final STRING OPTIONS(description="Descripcion del centro final"),
  cod_sku STRING OPTIONS(description="Codigo SKU"),
  cod_sku_cd STRING OPTIONS(description="Codigo SKU CD"),
  flg_percent_alicorp BOOLEAN OPTIONS(description="Flag que indica el porcentaje Alicorp"),
  flg_percent_alicorp_is_positive BOOLEAN OPTIONS(description="Flag que indica si el porcentaje Alicorp es positivo"),
  flg_percent_intradevco BOOLEAN OPTIONS(description="Flag que indica el porcentaje Intradevco"),
  flg_percent_intradevco_is_positive BOOLEAN OPTIONS(description="Flag que indica si el porcentaje Intradevco es positivo"),
  flg_percent_total BOOLEAN OPTIONS(description="Flag que indica el porcentaje total"),
  flg_percent_total_is_positive BOOLEAN OPTIONS(description="Flag que indica si el porcentaje total es positivo"),
  val_dbkey                                 STRING          OPTIONS (description="Identificador único")
)
OPTIONS (
    description = 'Tabla relacionada a control tower'
);
