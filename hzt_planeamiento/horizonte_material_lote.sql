/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_LOTE
  FECHA DE CREACIÓN: 18/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

CREATE OR REPLACE TABLE `{horizonte_project_id}.hzt_planeamiento.horizonte_material_lote`
(
  des_origen STRING OPTIONS(description="Nombre de tabla origen"),
  val_rownum INT64 OPTIONS (description="Numero de fila "),
  id_material STRING OPTIONS (description="Identificaciòn del des_material"),
  cod_material STRING OPTIONS (description="Codigo de des_material "),
  des_denominacion_material STRING OPTIONS (description="Descripcion del des_material"),
  cod_tipo_material STRING OPTIONS (description="Codigo del tipo de des_material"),
  cod_centro STRING OPTIONS (description="Codigo de des_centro"),
  des_descripcion_centro STRING OPTIONS (description="Descripcion del des_centro "),
  cod_sociedad STRING OPTIONS (description="Codigo de nom_sociedad"),
  nom_nombre_sociedad STRING OPTIONS (description="Nombre de nom_sociedad"),
  cod_pais STRING OPTIONS (description="Codigo de pais"),
  cod_almacen STRING OPTIONS (description="Codigo de almacen"),
  cod_lote STRING OPTIONS (description="Codigo de lote"),
  cod_centro_produccion STRING OPTIONS (description="Codigo de des_centro de produccion del lote "),
  flg_codigo_lote BOOLEAN OPTIONS (description="Flag de cod_codigo de lote"),
  fec_creacion DATE OPTIONS (description="Fecha de creacion del lote"),
  fec_vencimiento DATE OPTIONS (description="Fecha de vencimiento del lote "),
  fec_produccion DATE OPTIONS (description="Fecha de produccion del lote"),
  num_tiempo_minimo_duracion NUMERIC(20,4) OPTIONS (description="Tiempo minimo de duracion "),
  num_duracion_total_conservacion NUMERIC(20,4) OPTIONS (description="Duracion total de la conservación"),
  num_tiempo_vida_util NUMERIC(20,4) OPTIONS (description="Tiempo de vida util del lote "),
  cod_unidad_tiempo STRING OPTIONS (description="Unidad de tiempo "),
  fec_vencimiento_max DATE OPTIONS (description="Fecha de vencimiento maximo del lote "),
  cod_primeros_dig_lote STRING OPTIONS (description="Primeros digitos del lote"),
  num_tiempo_en_almacen NUMERIC(20,4) OPTIONS (description="Tiempo en almacen del lote "),
  num_tiempo_vida_util_real NUMERIC(20,4) OPTIONS (description="Tiempo de vida util real "),
  cnt_stock_libre_utilizacion NUMERIC(20,4) OPTIONS (description="Cantidad de stock libre utiizacion"),
  cnt_stock_lotes_restringidos NUMERIC(20,4) OPTIONS (description="Cantidad de stock de lotes restringidos"),
  cnt_stock_en_traslado NUMERIC(20,4) OPTIONS (description="Cantidad de stock en traslado"),
  cnt_stock_bloqueado NUMERIC(20,4) OPTIONS (description="Cantidad de stock bloqueado "),
  cnt_stock_en_inspeccion_calidad NUMERIC(20,4) OPTIONS (description="Cantidad de stock en inspeccion de calidad"),
  num_numerador_conversion NUMERIC(20,4) OPTIONS (description="Numerador de conversion"),
  flg_racio_cu03 BOOLEAN OPTIONS (description="Flag de que si esta est_racionalizado el des_material - CU03 "),
  fec_prod2 DATE OPTIONS (description="Fecha de produccion que es la fec_fecha de vencimiento menos el tiempo de vida util "),
  flg_estructura_lote BOOLEAN OPTIONS (description="Flag de la estructura de un lote "),
  num_tiempo_maximo_sku_almacen NUMERIC(20,4) OPTIONS (description="Tiempo maximo del producto en el almacen"),
  val_dbkey STRING OPTIONS (description="Llave unica de la tabla ")
)
OPTIONS (
  description = 'Tabla de lotes '
);
