/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_CLIENTE_IMPUESTO.
  FECHA DE CREACIÓN: 17/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

CREATE OR REPLACE TABLE `{horizonte_project_id}.hzt_comercial.horizonte_cliente_impuesto`(
  des_origen STRING OPTIONS(description="Origen"),
  val_rownum INT64 OPTIONS(description="Número de fila"),
  cod_cliente STRING OPTIONS(description="Código de cliente"),
  cod_grupo_cliente STRING OPTIONS(description="Código de grupo de cliente"),
  cod_pais_cliente STRING OPTIONS(description="Código de país"),
  cod_sociedad STRING OPTIONS(description="Código de sociedad"),
  nom_cliente STRING OPTIONS(description="Nombre de cliente"),
  flg_persona_natural STRING OPTIONS(description="Indicador de persona natural"),
  cod_tipo_documento STRING OPTIONS(description="Código de tipo de documento"),
  cod_documento STRING OPTIONS(description="Número de documento"),
  cod_subdominio STRING OPTIONS(description="Código de subdominio"),
  val_organizacion_venta STRING OPTIONS(description="Valor concatenado de organización de venta"), -- cod_organizacion_venta
  fec_creacion_cliente DATE OPTIONS(description="Fecha de creación de cliente"),
  cod_usuario_creador STRING OPTIONS(description="Código de usuario creador"),
  cod_subdominio_venta STRING OPTIONS(description="Código de subdominio de venta"),
  cod_pais_impuesto STRING OPTIONS(description="Código de país de impuesto"),
  cod_categoria_impuesto STRING OPTIONS(description="Código de categoría de impuesto"),
  cod_clasificacion_impuesto STRING OPTIONS(description="Código de clasificación de impuesto"),
  cod_grupo_precio_alicorp STRING OPTIONS(description="Código de grupo de precio Alicorp"),
  des_grupo_precio_alicorp STRING OPTIONS(description="Descripción de grupo de precio Alicorp"),
  flg_igv INT64 OPTIONS(description="Indicador de IGV"),
  val_dbkey STRING OPTIONS(description="Identificador único"),
  fec_proceso DATETIME OPTIONS(description="Fecha y hora de proceso")
)
OPTIONS(description="Impuesto de cliente");