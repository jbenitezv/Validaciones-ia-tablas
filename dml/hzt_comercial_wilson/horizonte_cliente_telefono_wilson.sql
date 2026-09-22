/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_CLIENTE_TELEFONO.
  FECHA DE CREACIÓN: 17/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

DELETE FROM `{horizonte_project_id}.hzt_comercial.horizonte_cliente_telefono`
WHERE des_origen = 'DE-WILSON' ;

INSERT INTO `{horizonte_project_id}.hzt_comercial.horizonte_cliente_telefono`
with clientes_telefono_base as (
  select distinct
    cb.cod_cliente,
    cb.cod_grupo_cliente,
    cb.cod_pais_cliente,
    cb.nombre_cliente as nom_cliente,
    cb.tipo_documento as cod_tipo_documento,
    cb.numero_documento as cod_documento,
    cb.subdominio as cod_subdominio,
    cb.organizaciones_venta as val_organizacion_venta,
    cb.cod_sociedad,
    cb.fec_creacion_cliente,
    cb.cod_usuario_creador,
    cb.subdominio_ventas as cod_subdominio_venta,
    cb.direccion as des_direccion,
    ct.cod_interno_telefono,
    ct.cod_pais_telefono as cod_pais_telefono,
    ct.num_telefono as num_telefono,
    case 
      when ct.flg_telefono_principal is true then true 
      when ct.flg_telefono_principal is false then false 
    end as flg_telefono_principal,
    case 
      when ct.flg_telefono_fijo is true then true 
      when ct.flg_telefono_fijo is false then false 
    end as flg_telefono_fijo,
    ct.fec_inicio_validez,
    ct.fec_fin_validez,
    cb.cod_grupo_precio_alicorp,
    cb.des_grupo_precio_alicorp
  from `{horizonte_project_id}.hzt_comercial.horizonte_cliente_base` cb
  join `{silver_project_id}.slv_modelo_interlocutor.horizonte_interlocutor_telefono` ct
   on cb.cod_cliente=substr(ct.id_interlocutor,15,10)
  --where cb.cod_grupo_cliente in ('ZENT','ZDES')
)
select
  'DE-WILSON'as des_origen,
  row_number()over(order by cod_cliente,cod_interno_telefono) as val_rownum,
  cod_cliente,
  cod_grupo_cliente,
  cod_pais_cliente,
  nom_cliente,
  cod_tipo_documento,
  cod_documento,
  cod_subdominio,
  val_organizacion_venta,
  cod_sociedad,
  fec_creacion_cliente,
  cod_usuario_creador,
  cod_subdominio_venta,
  des_direccion,
  cod_interno_telefono,
  cod_pais_telefono,
  num_telefono,
  flg_telefono_principal,
  flg_telefono_fijo,
  fec_inicio_validez,
  fec_fin_validez,
  cod_grupo_precio_alicorp,
  des_grupo_precio_alicorp,
  cod_cliente||coalesce(safe_cast(cod_interno_telefono as STRING))  as val_dbkey,
  CURRENT_DATETIME('America/Lima') AS fec_proceso
from clientes_telefono_base
;