/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_INTERLOCUTOR_COMERCIAL_BASE.
  FECHA DE CREACIÓN: 17/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/


CREATE OR REPLACE TABLE `{horizonte_project_id}.hzt_finanzas.horizonte_interlocutor_comercial_base`(
  des_origen STRING OPTIONS(description="Nombre de tabla origen"),
  val_rownum INT64 OPTIONS (description="Número de fila"),
  cod_interlocutor STRING OPTIONS (description="Código interlocutor"),
  cod_grupo_interlocutor STRING OPTIONS (description="Código grupo interlocutor"),
  tip_interlocutor_especial STRING OPTIONS (description="Tipo de interlocutor especial"),
  tip_bp_grouping STRING OPTIONS (description="BP grupo"),
  des_nombre_interlocutor STRING OPTIONS (description="Descripción de nombre Interlocutor"),
  flg_cliente STRING OPTIONS (description="Flag de cliente"),
  flg_bloqueo_cliente STRING OPTIONS (description="Flag de Bloqueo"),
  flg_proveedor STRING OPTIONS (description="Flag de Proveedor"),
  flg_bloqueo_proveedor STRING OPTIONS (description="Flag de bloqueo proveedor"),
  cod_sociedad STRING OPTIONS (description="Código de sociedad"),
  cod_pais STRING OPTIONS (description="Código de pais"),
  cod_tipo_documento STRING OPTIONS (description="Código de Tipo de documento"),
  des_numero_documento STRING OPTIONS (description="Descripción de número de documento"),
  cod_sociedad_gl_cliente STRING OPTIONS (description="Código de sociedad GL Cliente"),
  cod_sociedad_gl_proveedor STRING OPTIONS (description="Código de sociedad GL Proveedor"),
  flag_sociedad_gl INT64 OPTIONS (description="Flag de sociedad GL"),
  val_dbkey STRING OPTIONS (description="Identificador único")
)
OPTIONS (
  description = 'Tabla interlocutor comercial base.'
);