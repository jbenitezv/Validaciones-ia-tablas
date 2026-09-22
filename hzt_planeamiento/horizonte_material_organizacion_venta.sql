/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_MATERIAL_ORGANIZACION_VENTA
  FECHA DE CREACIÓN: 18/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

CREATE OR REPLACE TABLE `{horizonte_project_id}.hzt_planeamiento.horizonte_material_organizacion_venta`
(
  des_origen                    STRING  OPTIONS (description="Nombre de tabla origen"),
  val_rownum                    INT64   OPTIONS (description="Numero de fila"),
  id_material                   STRING  OPTIONS (description="Identificacion del material"),
  cod_material                  STRING  OPTIONS (description="Codigo del material"),
  cod_tipo_material             STRING  OPTIONS (description="Codigo del tipo de material"),
  des_material                  STRING  OPTIONS (description="Descripción del material"),
  cod_jerarquia                 STRING  OPTIONS (description="Codigo de jerarquia del material"),
  cod_plataforma                STRING  OPTIONS (description="Codigo de la plataforma"),
  cod_subplataforma             STRING  OPTIONS (description="Codigo de subplataforma"),
  cod_categoria                 STRING  OPTIONS (description="Codigo de la categoria del material"),
  des_categoria                 STRING  OPTIONS (description="Descripcion de la categoria del material"),
  des_familia                   STRING  OPTIONS (description="Descripcion de la familia del material"),
  cod_familia                   STRING  OPTIONS (description="Codigo de la familia del material"),
  cod_variedad                  STRING  OPTIONS (description="Codigo de variedad del material"),
  cod_presentacion              STRING  OPTIONS (description="Codigo de presentacion del material"),
  cod_grupo_articulo            STRING  OPTIONS (description="Código del grupo del artículo"),
  des_grupo_articulo            STRING  OPTIONS (description="Descripción del grupo del artículo"),
  cod_grupo_articulo_3          STRING  OPTIONS (description="Código del grupo del artículo 3"),
  cod_duenio_marca              STRING  OPTIONS (description="Código del dueño de la marca"),
  cod_grupo_transporte          STRING  OPTIONS (description="Código de grupo de transporte"),
  flg_compra                    BOOLEAN OPTIONS (description="Flag de compras"),
  flg_venta                     BOOLEAN OPTIONS (description="Flag de ventas"),
  cod_organizacion_venta        STRING  OPTIONS (description="Codigo de organizacion venta"),
  cod_canal_distribucion        STRING  OPTIONS (description="Codigo de canal de distribucion"),
  cod_pais                      STRING  OPTIONS (description="Codigo de pais"),
  cod_sociedad                  STRING  OPTIONS (description="Codigo de sociedad"),
  cod_grupo_imputacion          STRING  OPTIONS (description="Codigo de grupo de imputacion"),
  des_grupo_imputacion          STRING  OPTIONS (description="Descripcion de grupo de imputacion"),
  cod_negocio                   STRING  OPTIONS (description="Codigo de negocio"),
  des_negocio                   STRING  OPTIONS (description="Descripcion de negocio"),
  cod_subnegocio                STRING  OPTIONS (description="Codigo de subnegocio"),
  des_subnegocio                STRING  OPTIONS (description="Descripcion de subnegocio"),
  cod_marca                     STRING  OPTIONS (description="Codigo de marca"),
  des_marca                     STRING  OPTIONS (description="Descripción de marca"),
  cod_unidad_comercial_organizacion_venta STRING OPTIONS (description="Codigo de unidad comercial de organizacion de venta"),
  cod_unidad_comercial_material STRING  OPTIONS (description="Codigo de unidad comercial de material"),
  cod_unidad_base               STRING  OPTIONS (description="Código de unidad base"),
  num_numerador_conversion_unidad_comercial INT64 OPTIONS (description="Numerador de conversion de unidad comercial"),
  num_denominador_conversion_unidad_comercial INT64 OPTIONS (description="Denominador de conversion de unidad comercial"),
  cod_indicador_impuesto        STRING  OPTIONS (description="Codigo de indicador de impuestos"),
  des_indicador_impuesto        STRING  OPTIONS (description="Descripción de indicador de impuestos"),
  cod_clasificacion_impuesto_1  STRING  OPTIONS (description="Codigo de clasificacion de impuesto 1"),
  cod_clasificacion_impuesto_2  STRING  OPTIONS (description="Codigo de clasificacion de impuesto 2"),
  cod_clasificacion_impuesto_3  STRING  OPTIONS (description="Codigo de clasificacion de impuesto 3"),
  flg_clasificacion_impuesto    BOOLEAN OPTIONS (description="Flag de clasificacion de impuesto"),
  cod_centro_beneficio          STRING  OPTIONS (description="Codigo de centro de beneficio"),
  val_centro_beneficio_digito_567 STRING OPTIONS (description="Valor de centro de beneficio digito 567"),
  fec_creacion_material         DATE    OPTIONS (description="Fecha de creación"),
  cod_usuario_creador           STRING  OPTIONS (description="Código del usuario creador"),
  fec_ultima_modificacion       DATE    OPTIONS (description="Fecha de última modificación"),
  cod_usuario_ultima_modificacion STRING OPTIONS (description="Código del usuario de última modificación"),
  flg_fert_hawa                 BOOLEAN OPTIONS (description="Flag pertenece a fert-hawa"),
  cod_estado_fert_hawa          STRING  OPTIONS (description="Codigo de estado fert-hawa"),
  flg_racionalizacion_caso_uso_03 BOOLEAN OPTIONS (description="Flag de racionalizacion de caso de uso 03 "),
  cod_tier                      STRING  OPTIONS (description="Codigo del tier"),
  des_tier                      STRING  OPTIONS (description="Descripcion tier"),
  des_equipo_creador            STRING  OPTIONS (description="Descripcion del equipo creador"),
  cod_estado_nuevo              STRING  OPTIONS (description="Codigo de estado nuevo"),
  flg_exclusion_categoria_valorizacion BOOLEAN OPTIONS (description="Exclusion de materiales categoria valorizacion"),
  est_relacion_familia_marca    STRING  OPTIONS (description="Estado de relacion de la familia de la marca"),
  flg_sociedad                  BOOLEAN OPTIONS (description="Flag que indica si el centro está o no en Peru"),
  flg_mrp_activo                BOOLEAN OPTIONS (description="Flag que indica si el material tiene MRP activo en algún centro"),
  cod_jerarquia_material        STRING  OPTIONS (description="Codigo de jerarquia de material asociado a la organizacion venta"),
  val_dbkey                     STRING  OPTIONS (description="Identificador único"),
  fec_proceso                   DATETIME OPTIONS (description="Fecha de ejecucion del proceso")
)
OPTIONS (
  description = 'Tabla usada para la calidad de datos de los materiales a nivel organizaciones de venta - canal'
);