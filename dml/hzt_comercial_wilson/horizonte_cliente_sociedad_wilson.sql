/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_CLIENTE_SOCIEDAD.
  FECHA DE CREACIÓN: 17/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

DELETE FROM `{horizonte_project_id}.hzt_comercial.horizonte_cliente_sociedad`
WHERE des_origen = 'DE-WILSON' ;

INSERT INTO `{horizonte_project_id}.hzt_comercial.horizonte_cliente_sociedad`
with clientes_sociedades_base as (
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
    ifnull(cs.cod_sociedad,'SSXX') as cod_sociedad,
    cb.fec_creacion_cliente,
    cb.cod_usuario_creador,
    cb.subdominio_ventas as cod_subdominio_venta,
    cs.fec_extension_sociedad,
    cs.cod_usuario_extension,
    cs.cod_cuenta_asociada as cuenta_asociada,
    cs.cod_grupo_tesoreria as grupo_tesoreria,
    case 
      when cb.cod_pais_cliente = left(cs.cod_sociedad,2) then 'EL' 
      else 'EE' 
    end as grp_tesoreria_propuesto,
    cs.cod_condicion_pago,
    cb.cod_grupo_precio_alicorp,
    cb.des_grupo_precio_alicorp
  from `{horizonte_project_id}.hzt_comercial.horizonte_cliente_base` cb
  left join `{silver_project_id}.slv_modelo_interlocutor.horizonte_cliente_sociedad` cs
    on cb.cod_cliente = substring(cs.id_interlocutor,15,10)
     where cs.flg_bloqueo_sociedad is null
    -- and cb.cod_grupo_cliente in ('ZENT','ZDES')
)
select
  "DE-WILSON"as des_origen,
  row_number()over(order by cod_cliente,cod_sociedad) as val_rownum,
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
  cod_subdominio_venta,
  fec_extension_sociedad,
  cod_usuario_extension,
  cod_cuenta_asociada,
  cod_grupo_tesoreria,
  cod_grupo_tesoreria_propuesto,
  cod_condicion_pago,
  cod_grupo_precio_alicorp,
  des_grupo_precio_alicorp,
  coalesce(cod_cliente)||ifnull(safe_cast(cod_sociedad as STRING),'') as val_dbkey,
  CURRENT_DATETIME('America/Lima') AS fec_proceso
from clientes_sociedades_base
;