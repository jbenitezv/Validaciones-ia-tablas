/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_HD_QUIEBRE_WILSON
  FECHA DE CREACIÓN: 18/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

CREATE OR REPLACE TABLE `{horizonte_project_id}.hzt_planeamiento.horizonte_hm_stock_inmovilizado`(
    des_origen                    STRING          OPTIONS (description = "Nombre de tabla origen"),
  val_rownum                              INT64           OPTIONS (description="Numero de fila"),
  fecha DATE,
  cod_sociedad STRING,
  tipo_de_almacen STRING,
  correlativo INT64,
  negocio STRING,
  empresa STRING,
  plataforma STRING,
  categoria STRING,
  cod_cat STRING,
  familia STRING,
  centro_desc STRING,
  centro STRING,
  destino_principal STRING,
  negocio_s4 STRING,
  plataforma_s4 STRING,
  subplataforma STRING,
  hu STRING,
  codigo STRING,
  cod_tipo_material STRING,
  descripcion_de_producto STRING,
  unidad_de_medida_uco STRING,
  total_uco NUMERIC(18,4),
  estado STRING,
  motivo_bloqueo STRING,
  comentario_bloqueo STRING,
  ton NUMERIC(18,4),
  fecha_vencimiento DATE,
  valor_de_inventario NUMERIC(18,4),
  numero_de_ubicaciones NUMERIC(18,4),
  fecha_de_em DATE,
  estado_inmovilizado STRING,
  grupo_tiempo_de_vida STRING,
  incluir_en_procesos_inmovilizados STRING,
  dg_sku NUMERIC(18,4),
  target_dg NUMERIC(18,4),
  inv_age NUMERIC(18,4),
  target_inv_ave NUMERIC(18,4),
  cuadrante INT64,
  nombre STRING,
  responsable_central STRING,
  accion_mes_actual STRING,
  comentario STRING,
  accion_plan_corp STRING,
  responsale_ejecucion STRING,
  racionalizado STRING,
  ejecutado STRING,
  sku STRING,
  centros_final STRING,
  sku_cd STRING,
  anio_racionalizado INT64,
  mes_corte_de_data STRING,
  cant_cuadrantes INT64,
  fecha_data DATE,
  val_dbkey                                 STRING          OPTIONS (description="Identificador único")
)
OPTIONS (
    description = 'Tabla relacionada a control tower'
);
