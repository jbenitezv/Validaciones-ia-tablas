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
      k.cod_material,
      k.des_material,
      SAFE_CAST(NULL AS STRING) AS cod_tipo_material,--f.cod_tipo_material,
      k.cod_centro,
      k.des_centro,
      k.mnt_plan_venta,
      k.mnt_avance_venta,
      k.prc_cumplimiento,
      k.mnt_proyeccion_lineal,
      k.prc_proyeccion_lineal,
      k.mnt_proyeccion,
      k.prc_proyeccion,
      k.mnt_objetivo_diario,
      k.mnt_pedido_entrada,
      k.mnt_facturar_mes,
      k.mnt_a_facturar,
      k.mnt_retenido_credito,
      k.mnt_bloqueo_entrega,
      k.mnt_cliente_recoge,
      k.mnt_con_stock_asignado,
      k.mnt_con_stock,
      k.mnt_sin_stock,
      k.mnt_a_facturar_resto_mes,
      k.mnt_stock_libre_ut,
      k.mnt_stock_control_calidad,
      k.mnt_dia_giro_plan,
      k.mnt_stock_transito,
      k.mnt_dia_giro_real,
      k.mnt_avance_venta_pedido,
      k.mnt_cumplimiento_venta,
      k.mnt_venta_mes_anterior,
      k.mnt_stock_total,
      k.mnt_stock_bloqueado,
      k.mnt_avance_produccion,
      k.flg_activo,
      k.mnt_plan_pendiente,
      k.mnt_sobreventa,
      k.mnt_stock_faltante,
      k.mnt_stock_disponible,
      k.mnt_stock_disponible_transito,
      k.des_tier,
      k.des_jerarquia,
      k.des_expo,
      k.nom_sociedad,
      k.des_negocio,
      k.des_centro_concatenado,
      k.flg_teal,
      k.des_teal,
      k.mnt_pendiente_sin_stock,
      k.mnt_stock_pendiente,
      k.fec_registro,
      k.mnt_indicador_dg,
      k.cod_sku,
      k.nom_responsable,
      k.mnt_sku_indicador_dg,
      k.mnt_objetivo_indicador_dg,
      k.fec_ajustada,
      k.num_dia,
      k.mnt_indicador_dg_real,
      k.mnt_stock_alitrack,
      k.mnt_venta,
      case 
      when mnt_stock_libre_ut is null then null
      when mnt_plan_venta is null then null
      else 1
      end as flg_dg_libre_utilizacion,
      case 
      when mnt_stock_libre_ut is null then null
      when mnt_plan_venta is null then null
      when mnt_objetivo_indicador_dg is null then null
      else 1
      end as flg_porcentaje_dg
   from `{silver_project_id}.slv_gobierno.ptp_kardex_diario` k
  --  left join materiales f 
  --  on k.cod_material = f.cod_material_funcional 
)
select
'DE-WILSON' AS des_origen,
  row_number()over(order by cod_material || des_material || cod_centro || des_centro) as val_rownum,
  *,
  case 
    when round(mnt_plan_venta, 6) = 0 then 0
    else mnt_venta / mnt_plan_venta
  end as porc_kd,
  case 
    when round(mnt_venta, 6) = 0 then 0
    else mnt_venta
  end as venta_realt,
  coalesce(cod_material,'') || coalesce(des_material, '') || coalesce(cod_centro,'') || coalesce(des_centro,'')  as val_dbkey
from kardex_base;