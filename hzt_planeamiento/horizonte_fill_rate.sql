/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_FILL_RATE.
  FECHA DE CREACIÓN: 17/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

CREATE OR REPLACE TABLE `{horizonte_project_id}.hzt_planeamiento.horizonte_fill_rate`(
  des_origen STRING OPTIONS(description="Nombre de tabla origen"),
  val_rownum INT64 OPTIONS(description="Número de fila"),
  cod_sociedad STRING OPTIONS(description="Código de sociedad"),
  num_mes_natural INT64 OPTIONS(description="Mes natural"), -- mes_natural
  fec_reparto DATE OPTIONS(description="Fecha de reparto"), -- fecha_reparto
  num_anio INT64 OPTIONS(description="Año"), -- anio
  cod_negocio STRING OPTIONS(description="Código de negocio"), -- negocio_id
  des_negocio STRING OPTIONS(description="Descripción de negocio"), -- negocio
  cod_duenio_marca STRING OPTIONS(description="Código de dueño de marca"), -- duenio_marca_id
  des_duenio_marca STRING OPTIONS(description="Descripción de dueño de marca"), -- duenio_marca
  des_categoria STRING OPTIONS(description="Descripción de categoría"), -- categoria
  des_familia STRING OPTIONS(description="Descripción de familia"), -- familia
  cod_material STRING OPTIONS(description="Código de material"),
  cod_tipo_material STRING OPTIONS(description="Código de tipo de material"),
  cod_pedido STRING OPTIONS(description="Código de pedido"), -- numero_pedido
  cod_centro STRING OPTIONS(description="Código de centro"), -- centro_id
  des_centro STRING OPTIONS(description="Descripción de centro"), -- centro
  tip_motivo_fill STRING OPTIONS(description="Tipo de motivo fill"), -- tipo_motivo_fill
  des_nivel_fill_rate STRING OPTIONS(description="Nivel fill rate"), -- nivel_fill_rate
  des_motivo_fill_rate STRING OPTIONS(description="Motivo fill rate"), -- motivo_fill_rate
  mnt_solicitado NUMERIC(18,4) OPTIONS(description="Monto solicitado"), -- solicitado
  mnt_fill_rate NUMERIC(18,4) OPTIONS(description="Monto fill rate"), -- fill_rate
  prc_fill_rate NUMERIC(18,4) OPTIONS(description="Porcentaje fill rate"), -- porcentaje_fill_rate
  mnt_rechazo_pedido NUMERIC(18,4) OPTIONS(description="Rechazo de pedido"), -- rechazo_pedido
  prc_rechazo_pedido NUMERIC(18,4) OPTIONS(description="Porcentaje de rechazo de pedido"), -- porcentaje_rechazo_pedido
  mnt_dev_x_rechazo_desviacion NUMERIC(18,4) OPTIONS(description="Devolución por rechazo desviación"), -- dev_x_rechazo_desviacion
  prc_dev_x_rechazo_desviacion NUMERIC(18,4) OPTIONS(description="Porcentaje de devolución por rechazo desviación"), -- porcentaje_dev_x_rechazo_desviacion
  mnt_devolucion NUMERIC(18,4) OPTIONS(description="Devolución"), -- devolucion
  prc_devolucion NUMERIC(18,4) OPTIONS(description="Porcentaje de devolución"), -- porcentaje_devolucion
  mnt_total NUMERIC(18,4) OPTIONS(description="Total"), -- total
  num_semana INT64 OPTIONS(description="Semana"), -- semana
  num_dia INT64 OPTIONS(description="Día"), -- dia
  tip_facturado STRING OPTIONS(description="Tipo facturado"), -- tipo
  flg_considerar STRING OPTIONS(description="Indicador considerar"), -- motivo_considerar
  des_motivo_ok STRING OPTIONS(description="Motivo OK"), -- motivo_ok
  num_mes INT64 OPTIONS(description="Mes"), -- mes
  cod_sku STRING OPTIONS(description="Código SKU"), -- sku
  prc_participacion NUMERIC(18,4) OPTIONS(description="Porcentaje de participación"), -- porcentaje_participacion
  des_material STRING OPTIONS(description="Descripción de material"), -- descripcion_material
  val_codigo_descripcion_material STRING OPTIONS(description="Código y descripción de material"), -- codigo_descripcion_material
  des_pareto STRING OPTIONS(description="Descripción de pareto"), -- pareto
  des_empresa STRING OPTIONS(description="Descripción de empresa"), -- empresa
  cod_oficina_venta STRING OPTIONS(description="Código de oficina de venta"), -- oficina_ventas_id
  des_oficina_venta STRING OPTIONS(description="Descripción de oficina de venta"), -- oficina_ventas
  cod_grupo_vendedor STRING OPTIONS(description="Código de grupo vendedor"), -- grupo_vendedores_id
  des_grupo_vendedor STRING OPTIONS(description="Descripción de grupo vendedor"), -- grupo_vendedores
  des_canal STRING OPTIONS(description="Descripción de canal"), -- canal
  val_dbkey STRING OPTIONS(description="Identificador único")
)
OPTIONS(description="Tabla relacionada a control tower");