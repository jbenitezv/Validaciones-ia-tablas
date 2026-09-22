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
  des_origen STRING OPTIONS(description="Origen de la carga (ej. DE-WILSON, DE-SAPS4)"),
  val_rownum INT64 OPTIONS(description="Número secuencial de fila"),
  cod_cliente STRING OPTIONS(description="Código único de cliente (10 dígitos)"),
  cod_grupo_cliente STRING OPTIONS(description="Código del grupo de interlocutor (ZENT, ZDES, ZDEM, ZNJE)"),
  cod_pais_cliente STRING OPTIONS(description="Código de país del cliente"),
  nom_cliente STRING OPTIONS(description="Nombre o razón social del cliente"),
  flg_persona_natural BOOL OPTIONS(description="TRUE si el cliente es persona natural"),
  cod_tipo_documento STRING OPTIONS(description="Código de tipo de documento de identidad"),
  num_documento STRING OPTIONS(description="Número de documento de identidad"),
  cnt_longitud_nif INT64 OPTIONS(description="Longitud actual del número de documento (NIF)"),
  cnt_longitud_correcta INT64 OPTIONS(description="Longitud esperada del documento según tipo"),
  flg_primer_digito BOOL OPTIONS(description="TRUE si el documento inicia con un dígito válido según catálogo"),
  cod_subdominio STRING OPTIONS(description="Código de subdominio (CMP, B2B)"),
  cod_sociedad STRING OPTIONS(description="Código de sociedad SAP (PE11, EC13, UY11, etc.)"),
  val_organizacion_venta STRING OPTIONS(description="Valor concatenado de las organizaciones de venta"),
  cod_idioma_cliente STRING OPTIONS(description="Código ISO del idioma del cliente"),
  cod_contacto STRING OPTIONS(description="Código de contacto"),
  cod_ubigeo STRING OPTIONS(description="Código de ubigeo del cliente"),
  flg_cod_ubigeo BOOL OPTIONS(description="TRUE si el código de ubigeo existe en el catálogo"),
  cod_ubigeo_sugerido STRING OPTIONS(description="Código de ubigeo sugerido por coincidencia de población/distrito"),
  des_poblacion STRING OPTIONS(description="Población registrada del cliente"),
  des_poblacion_ubigeo STRING OPTIONS(description="Población asociada al código de ubigeo"),
  des_distrito STRING OPTIONS(description="Distrito registrado del cliente"),
  des_distrito_ubigeo STRING OPTIONS(description="Distrito asociado al código de ubigeo"),
  cod_region STRING OPTIONS(description="Código de región"),
  flg_region BOOL OPTIONS(description="TRUE si el código de región existe en el catálogo"),
  des_direccion STRING OPTIONS(description="Dirección del cliente"),
  cod_zona_transporte STRING OPTIONS(description="Código de zona de transporte"),
  flg_bloqueo_cliente BOOL OPTIONS(description="TRUE si el cliente tiene bloqueo activo en SAP S/4"),
  flg_telefono BOOL OPTIONS(description="TRUE si el cliente registra al menos un teléfono"),
  flg_email BOOL OPTIONS(description="TRUE si el cliente registra al menos un correo electrónico"),
  flg_comentario BOOL OPTIONS(description="TRUE si el cliente registra al menos un comentario"),
  fec_creacion_cliente DATE OPTIONS(description="Fecha de creación del cliente en SAP S/4"),
  cod_usuario_creador STRING OPTIONS(description="Código del usuario creador del cliente"),
  cod_subdominio_venta STRING OPTIONS(description="Código de subdominio de ventas (CMP, B2B)"),
  cod_grupo_precio_alicorp STRING OPTIONS(description="Código del grupo de precio Alicorp"),
  des_grupo_precio_alicorp STRING OPTIONS(description="Descripción del grupo de precio Alicorp"),
  val_dbkey STRING OPTIONS(description="Identificador único de la fila"),
  fec_proceso DATETIME OPTIONS(description="Fecha y hora de proceso de carga")
)
OPTIONS(description="Base de cliente");