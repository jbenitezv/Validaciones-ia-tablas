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
  des_categoria STRING OPTIONS(description="Descripcion de la categoria del material"),
  cod_sociedad STRING OPTIONS(description="Codigo de sociedad"),
  des_familia STRING OPTIONS(description="Descripcion de la familia del material"),
  id_material STRING OPTIONS(description="Identificador unico del material"),
  des_material STRING OPTIONS(description="Descripcion del material"),
  cod_tipo_material STRING OPTIONS(description="Codigo de tipo material"),
  id_centro STRING OPTIONS(description="Identificador unico del centro"),
  des_centro STRING OPTIONS(description="Descripcion del centro"),
  mnt_plan_ventas NUMERIC(20,4) OPTIONS(description="Monto del plan de ventas"),
  mnt_avance_ventas NUMERIC(20,4) OPTIONS(description="Monto del avance de ventas"),
  prc_cumplimiento NUMERIC(20,4) OPTIONS(description="Porcentaje de cumplimiento del plan de ventas"),
  mnt_proyeccion_lineal NUMERIC(20,4) OPTIONS(description="Monto de la proyeccion lineal de ventas"),
  prc_proyeccion_lineal NUMERIC(20,4) OPTIONS(description="Porcentaje de la proyeccion lineal de ventas"),
  mnt_proyeccion NUMERIC(20,4) OPTIONS(description="Monto de la proyeccion de ventas"),
  prc_proyeccion NUMERIC(20,4) OPTIONS(description="Porcentaje de la proyeccion de ventas"),
  mnt_objetivo_diario NUMERIC(20,4) OPTIONS(description="Monto objetivo de venta diario"),
  mnt_pedido_entrada NUMERIC(20,4) OPTIONS(description="Monto de pedido en entrada"),
  mnt_facturar_mes NUMERIC(20,4) OPTIONS(description="Monto a facturar en el mes"),
  mnt_a_facturar_fecha NUMERIC(20,4) OPTIONS(description="Monto a facturar a la fecha"),
  mnt_retenido_x_credito NUMERIC(20,4) OPTIONS(description="Monto retenido por credito"),
  mnt_bloqueo_entrega NUMERIC(20,4) OPTIONS(description="Monto con bloqueo de entrega"),
  mnt_cliente_recoge NUMERIC(20,4) OPTIONS(description="Monto de cliente que recoge en almacen"),
  mnt_con_stock_asignado NUMERIC(20,4) OPTIONS(description="Monto con stock asignado"),
  mnt_con_stock NUMERIC(20,4) OPTIONS(description="Monto con stock disponible"),
  mnt_sin_stock NUMERIC(20,4) OPTIONS(description="Monto sin stock"),
  mnt_a_facturar_resto_mes NUMERIC(20,4) OPTIONS(description="Monto a facturar del resto del mes"),
  mnt_stk_libre_ut NUMERIC(20,4) OPTIONS(description="Monto de stock libre utilizacion"),
  mnt_stk_control_calidad NUMERIC(20,4) OPTIONS(description="Monto de stock en control de calidad"),
  mnt_dia_giros_plan NUMERIC(20,4) OPTIONS(description="Dias de giro del plan"),
  mnt_stk_transito NUMERIC(20,4) OPTIONS(description="Monto de stock en transito"),
  num_dias_giro_real NUMERIC(20,4) OPTIONS(description="Numero de dias de giro real"),
  mnt_avance_vta_mas_ped_ent NUMERIC(20,4) OPTIONS(description="Monto de avance de venta mas pedido entrada"),
  prc_cumpl_avance_vta_mas_ped_ent NUMERIC(20,4) OPTIONS(description="Porcentaje de cumplimiento de avance de venta mas pedido entrada"),
  mnt_vta_mes_anterior NUMERIC(20,4) OPTIONS(description="Monto de venta del mes anterior"),
  mnt_stk_total NUMERIC(20,4) OPTIONS(description="Monto de stock total"),
  mnt_stk_bloqueado NUMERIC(20,4) OPTIONS(description="Monto de stock bloqueado"),
  mnt_avance_produccion NUMERIC(20,4) OPTIONS(description="Monto de avance de produccion"),
  flg_activo BOOLEAN OPTIONS(description="Flag que indica si el material esta activo"),
  mnt_plan_pendiente NUMERIC(20,4) OPTIONS(description="Monto del plan pendiente"),
  mnt_sobreventa NUMERIC(20,4) OPTIONS(description="Monto de sobreventa"),
  mnt_stk_faltante_p_plan NUMERIC(20,4) OPTIONS(description="Monto de stock faltante para el plan"),
  mnt_stk_disponible NUMERIC(20,4) OPTIONS(description="Monto de stock disponible"),
  mnt_stk_dip_mas_transito NUMERIC(20,4) OPTIONS(description="Monto de stock disponible mas transito"),
  des_tier STRING OPTIONS(description="Descripcion del tier del material"),
  des_jerarquia STRING OPTIONS(description="Descripcion de la jerarquia del material"),
  des_expo STRING OPTIONS(description="Descripcion de expo"),
  nom_sociedad STRING OPTIONS(description="Nombre de la sociedad"),
  des_negocio STRING OPTIONS(description="Descripcion del negocio"),
  des_centro_concatenado STRING OPTIONS(description="Descripcion concatenada del centro"),
  flg_teal BOOLEAN OPTIONS(description="Flag que indica teal"),
  des_teal_cd STRING OPTIONS(description="Descripcion de teal cd"),
  mnt_pendiente_sin_stock NUMERIC(20,4) OPTIONS(description="Monto pendiente sin stock"),
  mnt_stock_pendiente NUMERIC(20,4) OPTIONS(description="Monto de stock pendiente"),
  fec_registro DATE OPTIONS(description="Fecha de registro"),
  mnt_dg NUMERIC(20,4) OPTIONS(description="Monto del indicador DG"),
  cod_sku_cd STRING OPTIONS(description="Codigo SKU CD"),
  nom_responsable STRING OPTIONS(description="Nombre del responsable"),
  mnt_dg_obj_sku NUMERIC(20,4) OPTIONS(description="Monto objetivo del indicador DG por SKU"),
  mnt_dg_objetivos NUMERIC(20,4) OPTIONS(description="Monto de objetivos del indicador DG"),
  fec_ajustada DATE OPTIONS(description="Fecha ajustada"),
  num_dia INT64 OPTIONS(description="Numero de dia"),
  mnt_dg_real NUMERIC(20,4) OPTIONS(description="Monto del indicador DG real"),
  mnt_stk_alitrack NUMERIC(20,4) OPTIONS(description="Monto de stock en Alitrack"),
  mnt_sale_t NUMERIC(20,4) OPTIONS(description="Monto sale T"),
  flg_dg_libre_utilizacion BOOLEAN OPTIONS(description="Flag que indica si el DG esta libre de utilizacion"),
  flg_porcentaje_dg BOOLEAN OPTIONS(description="Flag que indica el porcentaje del DG"),
  prc_kd NUMERIC(18,4) OPTIONS(description="Porcentaje KD"),
  mnt_venta_realt NUMERIC(18,4) OPTIONS(description="Monto de venta real"),
  val_dbkey                                 STRING          OPTIONS (description="Identificador único")
)
OPTIONS (
    description = 'Tabla relacionada a control tower'
);