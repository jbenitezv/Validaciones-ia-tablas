/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_CLIENTE_BASE
  FECHA DE CREACIÓN: 21/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

create or replace table `{horizonte_project_id}.hzt_comercial.horizonte_cliente_base`(
  des_origen STRING OPTIONS(description="Origen"),
  val_rownum INT64 OPTIONS(description="Número de fila"), -- val_rownum
  cod_cliente STRING OPTIONS(description="Código de cliente"),
  cod_grupo_cliente STRING OPTIONS(description="Código de grupo de cliente"),
  cod_pais_cliente STRING OPTIONS(description="Código de país"),
  nom_cliente STRING OPTIONS(description="Nombre de cliente"),
  flg_persona_natural STRING OPTIONS(description="Indicador de persona natural"),
  cod_tipo_documento STRING OPTIONS(description="Código de tipo de documento"), -- tipo_documento
  num_documento STRING OPTIONS(description="Número de documento"), -- numero_documento
  cnt_longitud_nif INT64 OPTIONS(description="Longitud del documento"), -- long_nif
  cnt_longitud_correcta INT64 OPTIONS(description="Longitud correcta del documento"), -- long_correcta
  flg_primer_digito INT64 OPTIONS(description="Indicador de primer dígito"), -- flag_primeros_digitos
  cod_subdominio STRING OPTIONS(description="Código de subdominio"), -- subdominio
  cod_sociedad STRING OPTIONS(description="Código de sociedad"),
  val_organizacion_venta STRING OPTIONS(description="Valor concatenado de organización de venta"), -- organizaciones_venta
  cod_idioma_cliente STRING OPTIONS(description="Código de idioma"), -- idioma_cliente
  cod_contacto STRING OPTIONS(description="Código de contacto"),
  cod_ubigeo STRING OPTIONS(description="Código de ubigeo"),
  flg_cod_ubigeo INT64 OPTIONS(description="Indicador de ubigeo válido"), -- flag_cod_ubigeo
  cod_ubigeo_sugerido STRING OPTIONS(description="Código de ubigeo sugerido"), -- ubigeo_sugerido
  des_poblacion STRING OPTIONS(description="Población"), -- poblacion
  des_poblacion_ubigeo STRING OPTIONS(description="Población de ubigeo"), -- poblacion_ubigeo
  des_distrito STRING OPTIONS(description="Distrito"), -- distrito
  des_distrito_ubigeo STRING OPTIONS(description="Distrito de ubigeo"), -- distrito_ubigeo
  cod_region STRING OPTIONS(description="Código de región"),
  flg_region INT64 OPTIONS(description="Indicador de región válida"), -- flag_region
  des_direccion STRING OPTIONS(description="Dirección"), -- direccion
  cod_zona_transporte STRING OPTIONS(description="Código de zona de transporte"), -- zona_transporte
  flg_bloqueo_cliente STRING OPTIONS(description="Indicador de bloqueo de cliente"), -- flag_bloqueo_cliente
  flg_telefono INT64 OPTIONS(description="Indicador de teléfono"), -- flag_telefono
  flg_email INT64 OPTIONS(description="Indicador de email"), -- flag_email
  flg_comentario INT64 OPTIONS(description="Indicador de comentario"), -- flag_comentario
  fec_creacion_cliente DATE OPTIONS(description="Fecha de creación de cliente"),
  cod_usuario_creador STRING OPTIONS(description="Código de usuario creador"),
  cod_subdominio_venta STRING OPTIONS(description="Código de subdominio de venta"), -- subdominio_ventas
  cod_grupo_precio_alicorp STRING OPTIONS(description="Código de grupo de precio Alicorp"),
  des_grupo_precio_alicorp STRING OPTIONS(description="Descripción de grupo de precio Alicorp"),
  val_dbkey STRING OPTIONS(description="Identificador único"), -- val_dbkey
  fec_proceso DATETIME OPTIONS(description="Fecha y hora de proceso")
)
OPTIONS(description="Base de cliente");