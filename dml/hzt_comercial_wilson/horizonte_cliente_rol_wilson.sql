/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_CLIENTE_ROL.
  FECHA DE CREACIÓN: 17/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

DELETE FROM `{horizonte_project_id}.hzt_comercial.horizonte_cliente_rol`
WHERE des_origen = 'DE-WILSON' ;

INSERT INTO `{horizonte_project_id}.hzt_comercial.horizonte_cliente_rol`
with clientes_roles_base as (
  select
    cb.cod_cliente,
    cb.cod_grupo_cliente,
    cb.cod_pais_cliente,
    cb.nombre_cliente as nom_cliente,
    case 
      when cb.flag_persona_natural is true then true 
      when cb.flag_persona_natural is false then false 
    end as flg_persona_natural,
    cb.tipo_documento as cod_tipo_documento,
    cb.numero_documento as cod_documento,
    cb.subdominio as cod_subdominio,
    cb.organizaciones_venta as val_organizacion_venta,
    cb.cod_sociedad,
    cb.fec_creacion_cliente,
    cb.cod_usuario_creador,
    cr.cod_rol as cod_rol_cliente,
    cr.fec_inicio_validez,
    cr.fec_fin_validez,
    case
      when cr.cod_rol in ('FLCU00','FLCU01','ZDESTS','ZDESTM','ZAGDSD','ZTERRI','CRM010','UKM000') then true
      else false
    end as flg_rol,
    cb.cod_grupo_precio_alicorp,
    cb.des_grupo_precio_alicorp
  from `{horizonte_project_id}.hzt_comercial.horizonte_cliente_base` cb
  join `{silver_project_id}.slv_modelo_interlocutor.horizonte_interlocutor_rol` cr
    on cb.cod_cliente=substring(cr.id_interlocutor,15,10)
  -- where cb.cod_grupo_cliente in ('ZENT','ZDES','ZDEM')
  -- and ifnull(left(cr.cod_rol,3),'')!= 'FLV'
  -- and ifnull(left(cr.cod_rol,3),'')!= 'TR'
)
select
  "DE-WILSON"as des_origen,
  row_number()over(order by cod_cliente,cod_rol_cliente) as val_rownum,
  cod_cliente,
  cod_grupo_cliente,
  cod_pais_cliente,
  nom_cliente,
  flg_persona_natural,
  cod_tipo_documento,
  cod_documento,
  cod_subdominio,
  val_organizacion_venta,
  cod_sociedad,
  fec_creacion_cliente,
  cod_usuario_creador,
  cod_rol_cliente,
  fec_inicio_validez,
  fec_fin_validez,
  flg_rol,
  cod_grupo_precio_alicorp,
  des_grupo_precio_alicorp,
  coalesce(cod_cliente)||coalesce(safe_cast(cod_rol_cliente as STRING))  as val_dbkey,
  CURRENT_DATETIME('America/Lima') AS fec_proceso
from clientes_roles_base
;