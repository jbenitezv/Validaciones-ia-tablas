/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_TMP_ARCHIVO_DEMANDA
  FECHA DE CREACIÓN: 18/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

create or replace table `{horizonte_project_id}.hzt_comercial.horizonte_tpm_archivo_demanda`(
  des_origen STRING OPTIONS(description="Nombre de tabla origen"),
  val_rownum INT64 OPTIONS(description="Número de fila"),
  cod_sociedad STRING OPTIONS(description="Código de sociedad"),
  cod_negocio STRING OPTIONS(description="Código de negocio"),
  des_negocio STRING OPTIONS(description="Descripción de negocio"),
  val_subdominio STRING OPTIONS(description="Valor de subdominio"), -- negocio
  cod_categoria STRING OPTIONS(description="Código de categoría"),
  des_categoria STRING OPTIONS(description="Descripción de categoría"),
  cod_familia STRING OPTIONS(description="Código de familia"),
  des_familia STRING OPTIONS(description="Descripción de familia"),
  cod_material STRING OPTIONS(description="Código de material"),
  nom_material STRING OPTIONS(description="Nombre de material"),
  cod_oficina_venta STRING OPTIONS(description="Código de oficina de venta"), -- cod_oficina_ventas
  des_oficina_venta STRING OPTIONS(description="Descripción de oficina de venta"), -- des_oficina_ventas
  cod_grupo_vendedor STRING OPTIONS(description="Código de grupo vendedor"), -- cod_grupo_vendedores
  des_grupo_vendedor STRING OPTIONS(description="Descripción de grupo vendedor"), -- des_grupo_vendedores
  cod_grupo_precio STRING OPTIONS(description="Código de grupo de precio"), -- cod_grupo_precios
  des_grupo_precio STRING OPTIONS(description="Descripción de grupo de precio"), -- des_grupo_precios
  cod_zona_cliente STRING OPTIONS(description="Código de zona de cliente"), -- cod_zona_clientes
  des_zona_cliente STRING OPTIONS(description="Descripción de zona de cliente"), -- des_zona_clientes
  x STRING OPTIONS(description="Valor de categoría"), -- categoria
  val_familia STRING OPTIONS(description="Valor de familia"), -- familia
  des_gramaje STRING OPTIONS(description="Descripción de gramaje"), -- gramaje
  num_mes_anterior NUMERIC(18,4) OPTIONS(description="Mes anterior"), -- mes_anterior
  num_mes_actual NUMERIC(18,4) OPTIONS(description="Mes actual"), -- mes_actual
  num_diferencia_mes NUMERIC(18,4) OPTIONS(description="Diferencia de mes"), -- diferencia_mes
  nom_mes STRING OPTIONS(description="Nombre del mes"), -- mes
  nom_cliente STRING OPTIONS(description="Nombre de cliente"),
  tip_canal STRING OPTIONS(description="Tipo de canal"), -- canal
  val_dbkey STRING OPTIONS(description="Identificador único")
)
OPTIONS(description="Archivo de demanda TPM");