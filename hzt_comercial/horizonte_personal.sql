/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_PERSONAL
  FECHA DE CREACIÓN: 18/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

CREATE OR REPLACE TABLE `{horizonte_project_id}.hzt_comercial.horizonte_personal`(
    des_origen             STRING              OPTIONS (description="Nombre de tabla origen"),
    val_rownum             INT64               OPTIONS (description="Numero de fila"),
    cod_sociedad           STRING              OPTIONS (description="Codigo de sociedad"),
    cod_grupo_interlocutor STRING              OPTIONS (description="Codigo del grupo interlocutor"),
    des_grupo_interlocutor STRING              OPTIONS (description="Descripcion del grupo interlocutor"),
    cod_gerencia_regional  STRING              OPTIONS (description="Codigo de la gerencia regional"),
    cod_gerencia_zona      STRING              OPTIONS (description="Codigo de gerencia de zona"),
    des_negocio            STRING              OPTIONS (description="Descripcion del negocio"),
    cod_organizacion_venta STRING              OPTIONS (description="Codigo de organizacion de venta"),
    cod_territorio         STRING              OPTIONS (description="Codigo de territorio"),
    cod_personal           STRING              OPTIONS (description="Codigo del personal"),
    nom_personal           STRING              OPTIONS (description="Nombre del personal"),
    tip_documento          STRING              OPTIONS (description="Tipo de documento"),
    val_documento          STRING              OPTIONS (description="Numero de documento"),
    cod_grupo_precio_alicorp STRING            OPTIONS (description="Codigo del grupo de precio alicorp"),
    des_grupo_precio_alicorp STRING            OPTIONS (description="Descripcion del grupo de precio alicorp"),
    val_prefijo            STRING              OPTIONS (description="Valor del prefijo"),
    val_telefono           STRING              OPTIONS (description="Valor del telefono"),
    val_correo             STRING              OPTIONS (description="Descripcion del correo"),
    fec_nacimiento         DATE                OPTIONS (description="Fecha de nacimiendo del personal"),
    val_dbkey              STRING              OPTIONS (description="Llave unica por tabla"),
    fec_proceso            DATETIME            OPTIONS (description="Fecha de proceso")
)
OPTIONS (
    description = 'Tabla que contiene la información del personal de Alicorp S4'
);
