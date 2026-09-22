/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_INTERLOCUTOR_COMERCIAL_SOCIEDAD

  FECHA DE CREACIÓN: 17/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

CREATE OR REPLACE TABLE `{horizonte_project_id}.hzt_finanzas.horizonte_interlocutor_comercial_sociedad`(
  des_origen STRING OPTIONS(description="Nombre de tabla origen"),
  val_rownum INT64 OPTIONS (description="Numero de fila"),
  cod_interlocutor STRING OPTIONS (description="Código de interlocutor"),
  tip_interlocutor_especial STRING OPTIONS (description="Tipo de interlocutor"),
  cod_grupo_interlocutor STRING OPTIONS (description="Código de grupo interlocutor"),
  tip_bp_grouping STRING OPTIONS (description="BP grupo"),
  des_nombre_interlocutor STRING OPTIONS (description="BP grupo"),
  flg_cliente STRING OPTIONS (description="flag de cliente"),
  flg_bloqueo_cliente STRING OPTIONS (description="flag de Bloqueo"),
  flg_proveedor STRING OPTIONS (description="flag de Proveedor"),
  flg_bloqueo_proveedor STRING OPTIONS (description="flag de Bloqueo de Proveedor"),
  cod_pais STRING OPTIONS (description="Código de Pais"),
  cod_sociedad_gl STRING OPTIONS (description="Código de sociedad gl"),
  tipo_documento STRING OPTIONS (description="Tipo de docuento"),
  numero_documento STRING OPTIONS (description="Número de documento"),
  tipo_interlocutor STRING OPTIONS (description="Tipo de interlocutor"),
  cod_sociedad STRING OPTIONS (description="Código de sociedad"),
  cod_cuenta_asociada STRING OPTIONS (description="Códig de cuenta asociada"),
  flag_cuenta_asociada STRING OPTIONS (description="Flag de cuenta asociada"),
  val_dbkey STRING OPTIONS (description="Identificador único")
)
OPTIONS (
  description = 'Tabla interlocutor comercial sociedad.'
);
