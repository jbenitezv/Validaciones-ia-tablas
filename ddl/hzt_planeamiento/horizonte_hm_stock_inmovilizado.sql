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
  fec_fecha DATE OPTIONS(description="Fecha del registro"),
  cod_sociedad STRING OPTIONS(description="Codigo de sociedad"),
  des_tipo_almacen STRING OPTIONS(description="Descripcion del tipo de almacen"),
  num_correlativo INT64 OPTIONS(description="Numero correlativo"),
  des_negocio STRING OPTIONS(description="Descripcion del negocio"),
  des_empresa STRING OPTIONS(description="Descripcion de la empresa"),
  des_plataforma STRING OPTIONS(description="Descripcion de la plataforma"),
  des_categoria STRING OPTIONS(description="Descripcion de la categoria del material"),
  cod_cat STRING OPTIONS(description="Codigo de categoria"),
  des_familia STRING OPTIONS(description="Descripcion de la familia del material"),
  des_centro_desc STRING OPTIONS(description="Descripcion del centro"),
  des_centro STRING OPTIONS(description="Descripcion del centro"),
  des_destino_principal STRING OPTIONS(description="Descripcion del destino principal"),
  des_negocio_s4 STRING OPTIONS(description="Descripcion del negocio en S4"),
  des_plataforma_s4 STRING OPTIONS(description="Descripcion de plataforma en S4"),
  des_subplataforma STRING OPTIONS(description="Descripcion de la subplataforma"),
  cod_hu STRING OPTIONS(description="Codigo HU"),
  cod_codigo STRING OPTIONS(description="Codigo"),
  cod_tipo_material STRING OPTIONS(description="Codigo de tipo material"),
  des_descripcion_producto STRING OPTIONS(description="Descripcion del producto"),
  cod_unidad_medida_uco STRING OPTIONS(description="Codigo de unidad de medida comercial"),
  mnt_total_uco NUMERIC(18,4) OPTIONS(description="Monto total en unidad comercial"),
  est_estado STRING OPTIONS(description="Estado del registro"),
  des_motivo_bloqueo STRING OPTIONS(description="Descripcion del motivo de bloqueo"),
  des_comentario_bloqueo STRING OPTIONS(description="Comentario del bloqueo"),
  mnt_ton NUMERIC(18,4) OPTIONS(description="Monto en toneladas"),
  fec_vencimiento DATE OPTIONS(description="Fecha de vencimiento"),
  val_valor_inventario NUMERIC(18,4) OPTIONS(description="Valor del inventario"),
  num_numero_ubicaciones NUMERIC(18,4) OPTIONS(description="Numero de ubicaciones"),
  fec_em DATE OPTIONS(description="Fecha EM"),
  est_estado_inmovilizado STRING OPTIONS(description="Estado de inmovilizado"),
  des_grupo_tiempo_vida STRING OPTIONS(description="Descripcion del grupo de tiempo de vida"),
  flg_incluir_procesos_inmovilizados BOOLEAN OPTIONS(description="Flag que indica si se incluye en procesos de inmovilizados"),
  mnt_dg_sku NUMERIC(18,4) OPTIONS(description="Monto del indicador DG por SKU"),
  mnt_target_dg NUMERIC(18,4) OPTIONS(description="Monto objetivo del indicador DG"),
  num_inv_age NUMERIC(18,4) OPTIONS(description="Edad del inventario"),
  mnt_target_inv_ave NUMERIC(18,4) OPTIONS(description="Monto objetivo de edad promedio del inventario"),
  num_cuadrante INT64 OPTIONS(description="Numero de cuadrante"),
  nom_nombre STRING OPTIONS(description="Nombre"),
  nom_responsable_central STRING OPTIONS(description="Nombre del responsable central"),
  des_accion_mes_actual STRING OPTIONS(description="Descripcion de la accion del mes actual"),
  des_comentario STRING OPTIONS(description="Descripcion del comentario"),
  des_accion_plan_corp STRING OPTIONS(description="Descripcion de la accion del plan corporativo"),
  nom_responsable_ejecucion STRING OPTIONS(description="Nombre del responsable de ejecucion"),
  est_racionalizado STRING OPTIONS(description="Estado de racionalizado"),
  est_ejecutado STRING OPTIONS(description="Estado de ejecutado"),
  cod_sku STRING OPTIONS(description="Codigo SKU"),
  des_centros_final STRING OPTIONS(description="Descripcion de centros final"),
  cod_sku_cd STRING OPTIONS(description="Codigo SKU CD"),
  num_anio_racionalizado INT64 OPTIONS(description="Numero de ano racionalizado"),
  des_mes_corte_de_data STRING OPTIONS(description="Descripcion del mes de corte de data"),
  cnt_cuadrantes INT64 OPTIONS(description="Cantidad de cuadrantes"),
  fec_data DATE OPTIONS(description="Fecha de la data"),
  val_dbkey                                 STRING          OPTIONS (description="Identificador único")
)
OPTIONS (
    description = 'Tabla relacionada a control tower'
);
