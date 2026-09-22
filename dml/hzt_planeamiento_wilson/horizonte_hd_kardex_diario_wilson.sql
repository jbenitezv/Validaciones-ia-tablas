/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_HD_KARDEX_DIARIO.
  FECHA DE CREACIÓN: 18/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

delete from `{horizonte_project_id}.hzt_planeamiento.horizonte_hd_kardex_diario` where des_origen = 'DE-WILSON';

insert into `{horizonte_project_id}.hzt_planeamiento.horizonte_hd_kardex_diario`
with 
materiales as 
(
  select distinct a.id_material_origen as cod_material, a.cod_tipo_material, a.cod_material_funcional
  from `{silver_project_id}.slv_modelo_material.horizonte_material_aux` a
),
kardex_base as (
   select 
      k.des_categoria,
      'PE11' as cod_sociedad,
      k.des_familia,
      k.cod_material AS id_material,
      k.des_material,
      SAFE_CAST(NULL AS STRING) AS cod_tipo_material,--f.cod_tipo_material,
      k.cod_centro AS id_centro,
      k.des_centro,
      k.mnt_plan_venta AS mnt_plan_ventas,
      k.mnt_avance_venta AS mnt_avance_ventas,
      k.prc_cumplimiento,
      k.mnt_proyeccion_lineal,
      k.prc_proyeccion_lineal,
      k.mnt_proyeccion,
      k.prc_proyeccion,
      k.mnt_objetivo_diario,
      k.mnt_pedido_entrada,
      k.mnt_facturar_mes,
      k.mnt_a_facturar AS mnt_a_facturar_fecha,
      k.mnt_retenido_credito AS mnt_retenido_x_credito,
      k.mnt_bloqueo_entrega,
      k.mnt_cliente_recoge,
      k.mnt_con_stock_asignado,
      k.mnt_con_stock,
      k.mnt_sin_stock,
      k.mnt_a_facturar_resto_mes,
      k.mnt_stock_libre_ut AS mnt_stk_libre_ut,
      k.mnt_stock_control_calidad AS mnt_stk_control_calidad,
      k.mnt_dia_giro_plan AS mnt_dia_giros_plan,
      k.mnt_stock_transito AS mnt_stk_transito,
      k.mnt_dia_giro_real AS num_dias_giro_real,
      k.mnt_avance_venta_pedido AS mnt_avance_vta_mas_ped_ent,
      k.mnt_cumplimiento_venta AS prc_cumpl_avance_vta_mas_ped_ent,
      k.mnt_venta_mes_anterior AS mnt_vta_mes_anterior,
      k.mnt_stock_total AS mnt_stk_total,
      k.mnt_stock_bloqueado AS mnt_stk_bloqueado,
      k.mnt_avance_produccion,
      CASE WHEN TRIM(COALESCE(k.flg_activo,'')) != '' THEN TRUE ELSE FALSE END AS flg_activo,
      k.mnt_plan_pendiente,
      k.mnt_sobreventa,
      k.mnt_stock_faltante AS mnt_stk_faltante_p_plan,
      k.mnt_stock_disponible AS mnt_stk_disponible,
      k.mnt_stock_disponible_transito AS mnt_stk_dip_mas_transito,
      k.des_tier,
      k.des_jerarquia,
      k.des_expo,
      k.nom_sociedad,
      k.des_negocio,
      k.des_centro_concatenado,
      k.flg_teal,
      k.des_teal AS des_teal_cd,
      k.mnt_pendiente_sin_stock,
      k.mnt_stock_pendiente,
      k.fec_registro,
      k.mnt_indicador_dg AS mnt_dg,
      k.cod_sku AS cod_sku_cd,
      k.nom_responsable,
      k.mnt_sku_indicador_dg AS mnt_dg_obj_sku,
      k.mnt_objetivo_indicador_dg AS mnt_dg_objetivos,
      k.fec_ajustada,
      k.num_dia,
      k.mnt_indicador_dg_real AS mnt_dg_real,
      k.mnt_stock_alitrack AS mnt_stk_alitrack,
      k.mnt_venta AS mnt_sale_t,
      case 
      when mnt_stock_libre_ut is null then null
      when mnt_plan_venta is null then null
      else TRUE
      end as flg_dg_libre_utilizacion,
      case 
      when mnt_stock_libre_ut is null then null
      when mnt_plan_venta is null then null
      when mnt_objetivo_indicador_dg is null then null
      else TRUE
      end as flg_porcentaje_dg
   from `{silver_project_id}.slv_gobierno.ptp_kardex_diario` k
  --  left join materiales f 
  --  on k.cod_material = f.cod_material_funcional 
)
select
'DE-WILSON' AS des_origen,
  row_number()over(order by cod_material || des_material || cod_centro || des_centro) as val_rownum,
  des_categoria,
  cod_sociedad,
  des_familia,
  id_material,
  des_material,
  cod_tipo_material,
  id_centro,
  des_centro,
  mnt_plan_ventas,
  mnt_avance_ventas,
  prc_cumplimiento,
  mnt_proyeccion_lineal,
  prc_proyeccion_lineal,
  mnt_proyeccion,
  prc_proyeccion,
  mnt_objetivo_diario,
  mnt_pedido_entrada,
  mnt_facturar_mes,
  mnt_a_facturar_fecha,
  mnt_retenido_x_credito,
  mnt_bloqueo_entrega,
  mnt_cliente_recoge,
  mnt_con_stock_asignado,
  mnt_con_stock,
  mnt_sin_stock,
  mnt_a_facturar_resto_mes,
  mnt_stk_libre_ut,
  mnt_stk_control_calidad,
  mnt_dia_giros_plan,
  mnt_stk_transito,
  num_dias_giro_real,
  mnt_avance_vta_mas_ped_ent,
  prc_cumpl_avance_vta_mas_ped_ent,
  mnt_vta_mes_anterior,
  mnt_stk_total,
  mnt_stk_bloqueado,
  mnt_avance_produccion,
  flg_activo,
  mnt_plan_pendiente,
  mnt_sobreventa,
  mnt_stk_faltante_p_plan,
  mnt_stk_disponible,
  mnt_stk_dip_mas_transito,
  des_tier,
  des_jerarquia,
  des_expo,
  nom_sociedad,
  des_negocio,
  des_centro_concatenado,
  flg_teal,
  des_teal_cd,
  mnt_pendiente_sin_stock,
  mnt_stock_pendiente,
  fec_registro,
  mnt_dg,
  cod_sku_cd,
  nom_responsable,
  mnt_dg_obj_sku,
  mnt_dg_objetivos,
  fec_ajustada,
  num_dia,
  mnt_dg_real,
  mnt_stk_alitrack,
  mnt_sale_t,
  flg_dg_libre_utilizacion,
  flg_porcentaje_dg,
  case 
    when round(mnt_plan_venta, 6) = 0 then 0
    else mnt_venta / mnt_plan_venta
  end as prc_kd,
  case 
    when round(mnt_venta, 6) = 0 then 0
    else mnt_venta
  end as mnt_venta_realt,
  coalesce(cod_material,'') || coalesce(des_material, '') || coalesce(cod_centro,'') || coalesce(des_centro,'')  as val_dbkey
from kardex_base;