/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_MATERIAL_PROVEEDOR
  FECHA DE CREACIÓN: 18/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

CREATE OR REPLACE TABLE `{horizonte_project_id}.hzt_planeamiento.horizonte_material_proveedor` 
(
  des_origen                            STRING          OPTIONS (description="Nombre de tabla origen"),
  val_rownum                            INT64           OPTIONS (description="Numero de fila "),
  cod_sociedad                          STRING          OPTIONS (description="Código de sociedad"),
  cod_material                          STRING          OPTIONS (description="Código del material"),
  des_material                          STRING          OPTIONS (description="Descripción Material"),
  cod_tipo_material                     STRING          OPTIONS (description="Tipo de Material"),
  des_categoria                         STRING          OPTIONS (description="Categoría del material"),
  cod_centro                            STRING          OPTIONS (description="Codigo de centro"),
  cod_cuenta_proveedor                  STRING          OPTIONS (description="Código de proveedor relacionado a cuotas"),
  flg_cuenta_proveedor                  BOOLEAN         OPTIONS (description="Flag para delimitar universo de regla"),
  cod_proveedor                         STRING          OPTIONS (description="Código de proveedor"),
  cod_organizacion_compra               STRING          OPTIONS (description="Organizacion de compra"),
  flg_proveedor                         BOOLEAN         OPTIONS (description="Flag para delimitar universo de regla"),
  cod_categoria_registro_compra         STRING          OPTIONS (description="Categoria de registro compra"),
  num_plazo_entrega_previsto_cuota      NUMERIC(18,4)   OPTIONS (description="Plazo de entrega previsto para cuota"),
  num_plazo_entrega_previsto_contrato   NUMERIC(18,4)   OPTIONS (description="Plazo de entrega previsto para contrato"),
  val_dbkey                             STRING          OPTIONS (description="Identificador único"),
  fec_proceso                           DATETIME        OPTIONS (description="Fecha y hora de carga de la tabla")
)
OPTIONS (
  description = "Tabla regulacion por cuota s4"
);