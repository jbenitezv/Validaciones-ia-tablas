/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_FILL_RATE.
  FECHA DE CREACIÓN: 17/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

delete from`{horizonte_project_id}.hzt_planeamiento.horizonte_fill_rate` where des_origen = 'DE-WILSON'; 

insert into `{horizonte_project_id}.hzt_planeamiento.horizonte_fill_rate`
with 
materiales  as 
(
  select distinct a.id_material_origen as cod_material, a.cod_tipo_material, a.cod_material_funcional
  from `{silver_project_id}.slv_modelo_material.horizonte_material_aux` a
),
fill_base AS (
  select 
    'PE11' as cod_sociedad,
    f.num_mes_natural,
    f.fec_reparto,
    f.num_anio,
    f.cod_negocio,
    f.des_negocio,
    f.cod_duenio_marca,
    f.des_duenio_marca,
    f.des_categoria,
    f.des_familia,
    f.cod_material,
    SAFE_CAST(NULL AS STRING) AS cod_tipo_material, --m.cod_tipo_material,
    f.cod_pedido,
    f.cod_centro,
    f.des_centro,
    f.tip_motivo_reabastecimiento,
    f.des_nivel_reabastecimiento,
    f.des_motivo_reabastecimiento,
    f.mnt_solicitado,
    f.mnt_ratio_reabastecimiento,
    f.prc_reabastecimiento,
    f.mnt_pedido_rechazado,
    f.prc_pedido_rechazado,
    f.mnt_devolucion_rechazo,
    f.prc_devolucion_rechazo,
    f.mnt_devolucion,
    f.prc_devolucion,
    f.mnt_total,
    f.num_semana,
    f.num_dia,
    f.tip_facturado,
    f.flg_considerar,
    f.des_motivo_confirmacion,
    f.num_mes,
    f.cod_sku,
    f.prc_participacion,
    f.des_material_alternativa,
    f.des_material_extendida,
    f.des_pareto,
    f.des_sociedad,
    f.cod_oficina_venta,
    f.des_oficina_venta,
    f.cod_grupo_vendedor,
    f.des_grupo_vendedor,
    f.des_canal   
  from `{silver_project_id}.slv_gobierno.ptp_fill_rate` f
  -- left join materiales m
  -- on f.cod_material = m.cod_material_funcional
)
select
   'DE-WILSON' AS des_origen,
   row_number()over(order by cod_material ) as val_rownum,
    *,
  coalesce(cod_material, '') || coalesce(cod_pedido, '') || coalesce(des_motivo_reabastecimiento, '') || safe_cast(fec_reparto as STRING) || coalesce(cod_centro, '') as val_dbkey
from fill_base;
