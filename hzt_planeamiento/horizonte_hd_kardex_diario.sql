/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_HD_KARDEX_DIARIO.
  FECHA DE CREACIÓN: 18/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

CREATE OR REPLACE TABLE `{horizonte_project_id}.hzt_planeamiento.horizonte_hd_kardex_diario`(
  des_origen                    STRING          OPTIONS (description = "Nombre de tabla origen"),
  val_rownum                              INT64           OPTIONS (description="Numero de fila"),
  categoria STRING,
  cod_sociedad STRING,
  familia STRING,
  material_id STRING,
  material STRING,
  cod_tipo_material STRING, 
  centro_id STRING,
  centro STRING,
  plan_ventas NUMERIC(20,4),
  avance_ventas NUMERIC(20,4),
  cumplimiento_porcentaje NUMERIC(20,4),
  proyeccion_lineal NUMERIC(20,4),
  proyeccion_lineal_porcentaje NUMERIC(20,4),
  proyeccion NUMERIC(20,4),
  proyeccion_porcentaje NUMERIC(20,4),
  objetivo_diario NUMERIC(20,4),
  pedido_entrada NUMERIC(20,4),
  facturar_mes NUMERIC(20,4),
  a_facturar_fecha NUMERIC(20,4),
  retenido_x_credito NUMERIC(20,4),
  bloqueo_entrega NUMERIC(20,4),
  cliente_recoge NUMERIC(20,4),
  con_stock_asignado NUMERIC(20,4),
  con_stock NUMERIC(20,4),
  sin_stock NUMERIC(20,4),
  a_facturar_resto_mes NUMERIC(20,4),
  stk_libre_ut NUMERIC(20,4),
  stk_control_calidad NUMERIC(20,4),
  dia_giros_plan NUMERIC(20,4),
  stk_transito NUMERIC(20,4),
  dias_giro_real NUMERIC(20,4),
  avance_vta_mas_ped_ent NUMERIC(20,4),
  cumpl_avance_vta_mas_ped_ent NUMERIC(20,4),
  vta_mes_anterior NUMERIC(20,4),
  stk_total NUMERIC(20,4),
  stk_bloqueado NUMERIC(20,4),
  avance_produccion NUMERIC(20,4),
  activo STRING,
  plan_pendiente NUMERIC(20,4),
  sobreventa NUMERIC(20,4),
  stk_faltante_p_plan NUMERIC(20,4),
  stk_disponible NUMERIC(20,4),
  stk_dip_mas_transito NUMERIC(20,4),
  tier STRING,
  jerarquia STRING,
  expo STRING,
  sociedad STRING,
  negocio STRING,
  centro_concatenado STRING,
  teal STRING,
  teal_cd STRING,
  pendiente_sin_stock NUMERIC(20,4),
  stock_pendiente NUMERIC(20,4),
  fecha_registro DATE,
  dg NUMERIC(20,4),
  sku_cd STRING,
  responsable STRING,
  dg_obj_sku NUMERIC(20,4),
  dg_objetivos NUMERIC(20,4),
  fecha_ajustada DATE,
  dia INT64,
  dg_real NUMERIC(20,4),
  stk_alitrack NUMERIC(20,4),
  sale_t NUMERIC(20,4),
  flg_dg_libre_utilizacion INT64,
  flg_porcentaje_dg INT64 ,
  porc_kd NUMERIC(18,4),
  venta_realt NUMERIC(18,4),
  val_dbkey                                 STRING          OPTIONS (description="Identificador único")
)
OPTIONS (
    description = 'Tabla relacionada a control tower'
);