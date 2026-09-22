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
  id_material STRING OPTIONS (description="Identificaciòn del material"),
  cod_material STRING OPTIONS (description="Codigo de material "),
  denominacion_material STRING OPTIONS (description="Descripcion del material"),
  cod_tipo_material STRING OPTIONS (description="Codigo del tipo de material"),
  cod_centro STRING OPTIONS (description="Codigo de centro"),
  descripcion_centro STRING OPTIONS (description="Descripcion del centro "),
  cod_sociedad STRING OPTIONS (description="Codigo de sociedad"),
  nombre_sociedad STRING OPTIONS (description="Nombre de sociedad"),
  cod_pais STRING OPTIONS (description="Codigo de pais"),
  cod_almacen STRING OPTIONS (description="Codigo de almacen"),
  cod_lote STRING OPTIONS (description="Codigo de lote"),
  cod_centro_produccion STRING OPTIONS (description="Codigo de centro de produccion del lote "),
  flag_codigo_lote INT64 OPTIONS (description="Flag de codigo de lote"),
  fec_creacion DATE OPTIONS (description="Fecha de creacion del lote"),
  fec_vencimiento DATE OPTIONS (description="Fecha de vencimiento del lote "),
  fec_produccion DATE OPTIONS (description="Fecha de produccion del lote"),
  tiempo_minimo_duracion NUMERIC(20,4) OPTIONS (description="Tiempo minimo de duracion "),
  duracion_total_conservacion NUMERIC(20,4) OPTIONS (description="Duracion total de la conservación"),
  tiempo_vida_util NUMERIC(20,4) OPTIONS (description="Tiempo de vida util del lote "),
  unidad_tiempo STRING OPTIONS (description="Unidad de tiempo "),
  fec_vencimiento_max DATE OPTIONS (description="Fecha de vencimiento maximo del lote "),
  primeros_dig_lote STRING OPTIONS (description="Primeros digitos del lote"),
  tiempo_en_almacen NUMERIC(20,4) OPTIONS (description="Tiempo en almacen del lote "),
  tiempo_vida_util_real NUMERIC(20,4) OPTIONS (description="Tiempo de vida util real "),
  cant_stock_libre_utilizacion NUMERIC(20,4) OPTIONS (description="Cantidad de stock libre utiizacion"),
  cant_stock_lotes_restringidos NUMERIC(20,4) OPTIONS (description="Cantidad de stock de lotes restringidos"),
  cant_stock_en_traslado NUMERIC(20,4) OPTIONS (description="Cantidad de stock en traslado"),
  cant_stock_bloqueado NUMERIC(20,4) OPTIONS (description="Cantidad de stock bloqueado "),
  cant_stock_en_inspeccion_calidad NUMERIC(20,4) OPTIONS (description="Cantidad de stock en inspeccion de calidad"),
  num_numerador_conversion NUMERIC(20,4) OPTIONS (description="Numerador de conversion"),
  flg_racio_cu03 INT64 OPTIONS (description="Flag de que si esta racionalizado el material - CU03 "),
  fec_prod2 DATE OPTIONS (description="Fecha de produccion que es la fecha de vencimiento menos el tiempo de vida util "),
  flg_estructura_lote INT64 OPTIONS (description="Flag de la estructura de un lote "),
  tiempo_maximo_sku_almacen NUMERIC(20,4) OPTIONS (description="Tiempo maximo del producto en el almacen"),
  val_dbkey STRING OPTIONS (description="Llave unica de la tabla ")
)
OPTIONS (
  description = 'Tabla de lotes '
);
