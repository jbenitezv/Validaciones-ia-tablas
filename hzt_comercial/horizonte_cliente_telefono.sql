/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_CLIENTE_TELEFONO.
  FECHA DE CREACIÓN: 17/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

CREATE OR REPLACE TABLE `{horizonte_project_id}.hzt_comercial.horizonte_cliente_telefono`(
  des_origen STRING OPTIONS(description="Origen"),
  val_rownum INT64 OPTIONS(description="Número de fila"), -- val_rownum
  cod_cliente STRING OPTIONS(description="Código de cliente"),
  cod_grupo_cliente STRING OPTIONS(description="Código de grupo de cliente"),
  cod_pais_cliente STRING OPTIONS(description="Código de país"),
  nom_cliente STRING OPTIONS(description="Nombre de cliente"), -- nombre_cliente
  cod_tipo_documento STRING OPTIONS(description="Código de tipo de documento"), -- tipo_documento
  cod_documento STRING OPTIONS(description="Número de documento"), -- numero_documento
  cod_subdominio STRING OPTIONS(description="Código de subdominio"), -- subdominio
  val_organizacion_venta STRING OPTIONS(description="Valor concatenado de organización de venta"), -- organizaciones_venta
  cod_sociedad STRING OPTIONS(description="Código de sociedad"),
  fec_creacion_cliente DATE OPTIONS(description="Fecha de creación de cliente"),
  cod_usuario_creador STRING OPTIONS(description="Código de usuario creador"),
  cod_subdominio_venta STRING OPTIONS(description="Código de subdominio de venta"), -- subdominio_ventas
  des_direccion STRING OPTIONS(description="Dirección"), -- direccion
  cod_interno_telefono STRING OPTIONS(description="Código interno de teléfono"),
  cod_pais_telefono STRING OPTIONS(description="Código de país de teléfono"), -- pais_telefono
  num_telefono STRING OPTIONS(description="Número de teléfono"), -- numero_telefono
  flg_telefono_principal STRING OPTIONS(description="Indicador de teléfono principal"),
  flg_telefono_fijo INT64 OPTIONS(description="Indicador de teléfono fijo"),
  fec_inicio_validez DATE OPTIONS(description="Fecha de inicio de validez"),
  fec_fin_validez DATE OPTIONS(description="Fecha de fin de validez"),
  cod_grupo_precio_alicorp STRING OPTIONS(description="Código de grupo de precio Alicorp"),
  des_grupo_precio_alicorp STRING OPTIONS(description="Descripción de grupo de precio Alicorp"),
  val_dbkey STRING OPTIONS(description="Identificador único"), -- val_dbkey
  fec_proceso DATETIME OPTIONS(description="Fecha y hora de proceso")
)
OPTIONS(description="Teléfono de cliente");