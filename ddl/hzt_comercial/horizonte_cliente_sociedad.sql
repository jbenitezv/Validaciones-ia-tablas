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
  des_origen STRING OPTIONS(description="Origen de la carga (ej. DE-WILSON, DE-SAPS4)"),
  val_rownum INT64 OPTIONS(description="Número secuencial de fila"),
  cod_cliente STRING OPTIONS(description="Código único de cliente (10 dígitos)"),
  cod_grupo_cliente STRING OPTIONS(description="Código del grupo de interlocutor (ZENT, ZDES, ZDEM, ZNJE)"),
  cod_pais_cliente STRING OPTIONS(description="Código de país del cliente"),
  nom_cliente STRING OPTIONS(description="Nombre o razón social del cliente"),
  flg_persona_natural BOOL OPTIONS(description="TRUE si el cliente es persona natural"),
  cod_tipo_documento STRING OPTIONS(description="Código de tipo de documento de identidad"),
  cod_documento STRING OPTIONS(description="Número de documento de identidad"),
  cod_subdominio STRING OPTIONS(description="Código de subdominio (CMP, B2B)"),
  val_organizacion_venta STRING OPTIONS(description="Valor concatenado de las organizaciones de venta"),
  cod_sociedad STRING OPTIONS(description="Código de sociedad SAP (PE11, EC13, UY11, etc.)"),
  fec_creacion_cliente DATE OPTIONS(description="Fecha de creación del cliente en SAP S/4"),
  cod_usuario_creador STRING OPTIONS(description="Código del usuario creador del cliente"),
  cod_subdominio_venta STRING OPTIONS(description="Código de subdominio de ventas (CMP, B2B)"),
  fec_extension_sociedad DATE OPTIONS(description="Fecha de extensión/creación de la sociedad"),
  cod_usuario_extension STRING OPTIONS(description="Código del usuario que extendió la sociedad"),
  cod_cuenta_asociada STRING OPTIONS(description="Código de cuenta contable asociada"),
  cod_grupo_tesoreria STRING OPTIONS(description="Código del grupo de tesorería actual"),
  cod_grupo_tesoreria_propuesto STRING OPTIONS(description="Código de grupo de tesorería propuesto (EL=Local, EE=Extranjero)"),
  cod_condicion_pago STRING OPTIONS(description="Código de condición de pago del cliente"),
  cod_grupo_precio_alicorp STRING OPTIONS(description="Código del grupo de precio Alicorp"),
  des_grupo_precio_alicorp STRING OPTIONS(description="Descripción del grupo de precio Alicorp"),
  val_dbkey STRING OPTIONS(description="Identificador único de la fila"),
  fec_proceso DATETIME OPTIONS(description="Fecha y hora de proceso de carga")
)
OPTIONS(description="Sociedad de cliente");