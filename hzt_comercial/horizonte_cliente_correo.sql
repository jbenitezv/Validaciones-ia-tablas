/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_CLIENTE_CORREO.
  FECHA DE CREACIÓN: 17/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

create or replace table `{horizonte_project_id}.hzt_comercial.horizonte_cliente_correo`(
  des_origen STRING OPTIONS(description="Origen"),
  val_rownum INT64 OPTIONS(description="Número de fila"), -- val_rownum
  cod_cliente STRING OPTIONS(description="Código de cliente"),
  cod_grupo_cliente STRING OPTIONS(description="Código de grupo de cliente"),
  cod_pais_cliente STRING OPTIONS(description="Código de país"),
  nom_cliente STRING OPTIONS(description="Nombre de cliente"), -- nombre_cliente
  flg_persona_natural STRING OPTIONS(description="Indicador de persona natural"), -- flag_persona_natural
  cod_tipo_documento STRING OPTIONS(description="Código de tipo de documento"), -- tipo_documento
  cod_documento STRING OPTIONS(description="Número de documento"), -- numero_documento
  cod_subdominio STRING OPTIONS(description="Código de subdominio"), -- subdominio
  val_organizacion_venta STRING OPTIONS(description="Valor concatenado de organización de venta"), -- organizaciones_venta
  cod_sociedad STRING OPTIONS(description="Código de sociedad"),
  fec_creacion_cliente DATE OPTIONS(description="Fecha de creación de cliente"),
  cod_usuario_creador STRING OPTIONS(description="Código de usuario creador"),
  cod_subdominio_venta STRING OPTIONS(description="Código de subdominio de venta"), -- subdominio_ventas
  cod_contacto STRING OPTIONS(description="Código de contacto"),
  des_comentario_correo STRING OPTIONS(description="Comentario de correo"), -- comentario_correo
  cod_interno_correo STRING OPTIONS(description="Código interno de correo"),
  val_correo_cliente STRING OPTIONS(description="Correo de cliente"), -- correo_cliente
  cod_grupo_precio_alicorp STRING OPTIONS(description="Código de grupo de precio Alicorp"),
  des_grupo_precio_alicorp STRING OPTIONS(description="Descripción de grupo de precio Alicorp"),
  val_dbkey STRING OPTIONS(description="Identificador único"), -- val_dbkey
  fec_proceso DATETIME OPTIONS(description="Fecha y hora de proceso")
)
OPTIONS(description="Correo de cliente");