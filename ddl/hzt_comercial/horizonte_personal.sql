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
    des_origen             STRING              OPTIONS (description="Origen de la carga (ej. DE-WILSON, DE-SAPS4)"),
    val_rownum             INT64               OPTIONS (description="Número secuencial de fila"),
    cod_sociedad           STRING              OPTIONS (description="Código de sociedad SAP (PE11, EC13, UY11, etc.)"),
    cod_grupo_interlocutor STRING              OPTIONS (description="Código del grupo de interlocutor"),
    des_grupo_interlocutor STRING              OPTIONS (description="Descripción del grupo de interlocutor"),
    cod_gerencia_regional  STRING              OPTIONS (description="Código de la gerencia regional"),
    cod_gerencia_zona      STRING              OPTIONS (description="Código de la gerencia de zona"),
    des_negocio            STRING              OPTIONS (description="Descripción del negocio (CMP, B2B, AS)"),
    cod_organizacion_venta STRING              OPTIONS (description="Código de la organización de venta"),
    cod_territorio         STRING              OPTIONS (description="Código del territorio asignado al personal"),
    cod_personal           STRING              OPTIONS (description="Código único del personal"),
    nom_personal           STRING              OPTIONS (description="Nombre completo del personal"),
    tip_documento          STRING              OPTIONS (description="Tipo de documento de identidad"),
    val_documento          STRING              OPTIONS (description="Número de documento de identidad"),
    cod_grupo_precio_alicorp STRING            OPTIONS (description="Código del grupo de precio Alicorp"),
    des_grupo_precio_alicorp STRING            OPTIONS (description="Descripción del grupo de precio Alicorp"),
    val_prefijo            STRING              OPTIONS (description="Prefijo del número telefónico"),
    val_telefono           STRING              OPTIONS (description="Número de teléfono sin prefijo"),
    val_correo             STRING              OPTIONS (description="Dirección de correo electrónico del personal"),
    fec_nacimiento         DATE                OPTIONS (description="Fecha de nacimiento del personal"),
    val_dbkey              STRING              OPTIONS (description="Llave única de la fila (id_interlocutor_origen)"),
    fec_proceso            DATETIME            OPTIONS (description="Fecha y hora de proceso de carga")
)
OPTIONS (
    description = 'Tabla que contiene la información del personal de Alicorp S4'
);
