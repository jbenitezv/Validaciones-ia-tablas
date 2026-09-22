/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_CLIENTE_IMPUESTO.
  FECHA DE CREACIÓN: 17/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

DELETE FROM `{horizonte_project_id}.hzt_comercial.horizonte_cliente_impuesto`
WHERE des_origen = 'DE-WILSON' ;

INSERT INTO `{horizonte_project_id}.hzt_comercial.horizonte_cliente_impuesto`
with clientes_impuestos_base as (
  select
    cb.cod_cliente,
    cb.cod_grupo_cliente,
    cb.cod_pais_cliente,
    cb.cod_sociedad,
    cb.nombre_cliente as nom_cliente,
    case 
      when cb.flag_persona_natural is true then true 
      when cb.flag_persona_natural is false then false 
    end as flg_persona_natural,
    cb.tipo_documento as cod_tipo_documento,
    cb.numero_documento as cod_documento,
    cb.subdominio as cod_subdominio,
    cb.organizaciones_venta as val_organizacion_venta,
    cb.fec_creacion_cliente as fec_creacion_cliente,
    cb.cod_usuario_creador,
    cb.subdominio_ventas as cod_subdominio_venta,
    SAFE_CAST(NULL AS STRING) as cod_pais_impuesto,
    SAFE_CAST(NULL AS STRING) as cod_categoria_impuesto,
    SAFE_CAST(NULL AS STRING) as cod_clasificacion_impuesto,
    -- ci.cod_pais_impuesto as pais_impuesto,
    -- ci.cod_categoria_impuesto,
    -- ci.cod_clasificacion_impuesto,
    cb.cod_grupo_precio_alicorp,
    cb.des_grupo_precio_alicorp,
    SAFE_CAST(NULL AS BOOL) as flg_igv,
    --case when ci.cod_clasificacion_impuesto in ('0','1') then 1 else 0 end as flag_igv
  from `{horizonte_project_id}.hzt_comercial.horizonte_cliente_base` cb
  -- left join `acpe-dev-mig-calidad-slv.slv_modelo_interlocutor.horizonte_cliente_impuesto` ci
  -- on cb.cod_cliente = substring(ci.id_interlocutor,11,10)
  -- where  cb.cod_grupo_cliente != 'ZNJE'
)
select
  "DE-WILSON"as des_origen,
  row_number()over(order by cod_cliente,cod_categoria_impuesto) as val_rownum,
  cod_cliente,
  cod_grupo_cliente,
  cod_pais_cliente,
  cod_sociedad,
  nom_cliente,
  flg_persona_natural,
  cod_tipo_documento,
  cod_documento,
  cod_subdominio,
  val_organizacion_venta,
  fec_creacion_cliente,
  cod_usuario_creador,
  cod_subdominio_venta,
  cod_pais_impuesto,
  cod_categoria_impuesto,
  cod_clasificacion_impuesto,
  cod_grupo_precio_alicorp,
  des_grupo_precio_alicorp,
  flg_igv,
  coalesce(cod_cliente)||ifnull(cod_categoria_impuesto,'') as val_dbkey,
  CURRENT_DATETIME('America/Lima') AS fec_proceso
from clientes_impuestos_base
;