/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_CLIENTE_CORREO.
  FECHA DE CREACIÓN: 17/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

delete from `{horizonte_project_id}.hzt_comercial.horizonte_cliente_correo` where des_origen = 'DE-WILSON';
insert into `{horizonte_project_id}.hzt_comercial.horizonte_cliente_correo`
with clientes_correo_base as (
  select distinct 
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
    cb.subdominio_ventas as cod_subdominio_venta,
    cb.cod_contacto,
    ce.des_comentario_email as des_comentario_correo,
    ce.cod_interno_email as cod_interno_correo,
    ce.des_email  as val_correo_cliente,
    cb.cod_grupo_precio_alicorp,
    cb.des_grupo_precio_alicorp
  from `{horizonte_project_id}.hzt_comercial.horizonte_cliente_base` cb
  join `{silver_project_id}.slv_modelo_interlocutor.horizonte_interlocutor_email` ce
    on cod_cliente = ce.id_interlocutor_origen
  -- where cb.cod_grupo_cliente in ('ZENT','ZDES')
 )
select
  'DE-WILSON' des_origen,
  row_number()over(order by cod_cliente,cod_interno_correo) as val_rownum,
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
  cod_contacto,
  des_comentario_correo,
  cod_interno_correo,
  val_correo_cliente,
  cod_grupo_precio_alicorp,
  des_grupo_precio_alicorp,
  coalesce(cod_cliente)|| coalesce(cod_interno_correo)  as val_dbkey,
  CURRENT_DATETIME('America/Lima') AS fec_proceso  
from clientes_correo_base;