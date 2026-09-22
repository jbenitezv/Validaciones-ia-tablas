/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_CLIENTE_SOCIEDAD.
  FECHA DE CREACIÓN: 17/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

CREATE OR REPLACE TABLE `{horizonte_project_id}.hzt_comercial.horizonte_cliente_sociedad`(
  des_origen STRING OPTIONS(description="Origen"),
  val_rownum INT64 OPTIONS(description="Número de fila"),
  cod_cliente STRING OPTIONS(description="Código de cliente"),
  cod_grupo_cliente STRING OPTIONS(description="Código de grupo de cliente"),
  cod_pais_cliente STRING OPTIONS(description="Código de país"),
  nom_cliente STRING OPTIONS(description="Nombre de cliente"),
  flg_persona_natural STRING OPTIONS(description="Indicador de persona natural"),
  cod_tipo_documento STRING OPTIONS(description="Código de tipo de documento"),
  cod_documento STRING OPTIONS(description="Número de documento"),
  cod_subdominio STRING OPTIONS(description="Código de subdominio"),
  val_organizacion_venta STRING OPTIONS(description="Valor concatenado de organización de venta"), -- cod_organizacion_venta
  cod_sociedad STRING OPTIONS(description="Código de sociedad"),
  fec_creacion_cliente DATE OPTIONS(description="Fecha de creación de cliente"),
  cod_usuario_creador STRING OPTIONS(description="Código de usuario creador"),
  cod_subdominio_venta STRING OPTIONS(description="Código de subdominio de venta"),
  fec_extension_sociedad DATE OPTIONS(description="Fecha de extensión de sociedad"),
  cod_usuario_extension STRING OPTIONS(description="Código de usuario de extensión"),
  cod_cuenta_asociada STRING OPTIONS(description="Código de cuenta asociada"),
  cod_grupo_tesoreria STRING OPTIONS(description="Código de grupo de tesorería"),
  cod_grupo_tesoreria_propuesto STRING OPTIONS(description="Código de grupo de tesorería propuesto"),
  cod_condicion_pago STRING OPTIONS(description="Código de condición de pago"),
  cod_grupo_precio_alicorp STRING OPTIONS(description="Código de grupo de precio Alicorp"),
  des_grupo_precio_alicorp STRING OPTIONS(description="Descripción de grupo de precio Alicorp"),
  val_dbkey STRING OPTIONS(description="Identificador único"),
  fec_proceso DATETIME OPTIONS(description="Fecha y hora de proceso")
)
OPTIONS(description="Sociedad de cliente");