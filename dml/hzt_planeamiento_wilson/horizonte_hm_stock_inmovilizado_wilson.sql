/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_HD_QUIEBRE_WILSON
  FECHA DE CREACIÓN: 18/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/



delete from `{horizonte_project_id}.hzt_planeamiento.horizonte_hm_stock_inmovilizado` where des_origen = 'DE-WILSON'; 

insert into `{horizonte_project_id}.hzt_planeamiento.horizonte_hm_stock_inmovilizado`
with  
materiales  as 
(
  select distinct a.id_material_origen as cod_material, a.cod_tipo_material, a.cod_material_funcional
  from `{silver_project_id}.slv_modelo_material.horizonte_material_aux` a
)
,cnt_cuadrante_contador AS (
  SELECT
    cod_sku,
    COUNT(DISTINCT flg_cuadrante) AS cnt_cuadrante_contador
  FROM `{silver_project_id}.slv_gobierno.ptp_stock_inmovilizado`
  GROUP BY cod_sku
)
,stock_inmovilizados_base as (
 select 
  a.fec_registro AS fec_fecha,
  'PE11' as cod_sociedad,
  a.cod_tipo_almacen AS des_tipo_almacen,
  a.num_correlativo,
  a.cod_negocio AS des_negocio,
  a.des_empresa,
  a.des_plataforma,
  a.des_categoria,
  a.cod_categoria AS cod_cat,
  a.des_familia,
  SAFE_CAST(NULL AS STRING) AS des_centro_desc,
  a.des_centro,
  -- a.cod_centro, -- Comentado: DDL no tiene cod_centro
  a.des_destino_principal,
  a.des_negocio_s4,
  a.des_plataforma_s4,
  SAFE_CAST(NULL AS STRING) AS des_subplataforma,
  a.des_hu AS cod_hu,
  SAFE_CAST(NULL AS STRING) AS cod_codigo,
  -- a.cod_material, -- Comentado: DDL no tiene cod_material
  SAFE_CAST(NULL AS STRING) AS cod_tipo_material, --m.cod_tipo_material,
  SAFE_CAST(NULL AS STRING) AS des_descripcion_producto,
  a.cod_unidad_medida_comercial AS cod_unidad_medida_uco,
  a.mnt_total_comercial AS mnt_total_uco,
  a.est_registro AS est_estado,
  a.des_motivo_bloqueo,
  a.des_comentario_bloqueo,
  a.mnt_tonelada AS mnt_ton,
  a.fec_vencimiento,
  a.mnt_inventario AS val_valor_inventario,
  a.mnt_ubicacion AS num_numero_ubicaciones,
  a.fec_registro2 AS fec_em,
  a.est_inmovilizado AS est_estado_inmovilizado,
  a.est_tiempo_vida AS des_grupo_tiempo_vida,
  CASE WHEN TRIM(COALESCE(a.flg_proceso_inmovilizado,'')) != '' THEN TRUE ELSE FALSE END AS flg_incluir_procesos_inmovilizados,
  a.mnt_sku AS mnt_dg_sku,
  a.mnt_objetivo AS mnt_target_dg,
  a.num_edad_inventario AS num_inv_age,
  a.mnt_objetivo_edad_inventario AS mnt_target_inv_ave,
  CASE WHEN TRIM(COALESCE(a.flg_cuadrante,'')) != '' THEN 1 ELSE 0 END AS num_cuadrante,
  a.nom_responsable AS nom_nombre,
  a.nom_responsable_central,
  a.des_accion_mes_actual,
  a.des_comentario,
  a.des_accion_plan AS des_accion_plan_corp,
  a.des_responsable_ejecucion AS nom_responsable_ejecucion,
  CASE WHEN TRIM(COALESCE(a.flg_racionalizado,'')) != '' THEN 'X' ELSE '' END AS est_racionalizado,
  a.est_ejecutado,
  a.des_sku AS cod_sku,
  a.des_centro_final AS des_centros_final,
  a.cod_sku AS cod_sku_cd,
  a.num_anio_racionalizado,
  a.des_mes AS des_mes_corte_de_data,
  coalesce(cc.cnt_cuadrante_contador, 0) as cnt_cuadrantes,
  a.fec_informacion AS fec_data
 from `{silver_project_id}.slv_gobierno.ptp_stock_inmovilizado` a
--  left join materiales  m
--  on a.cod_material = m.cod_material_funcional
 left join cnt_cuadrante_contador cc 
 on a.cod_sku = cc.cod_sku
 )
select
   'DE-WILSON' as des_origen,
   row_number()over(order by num_correlativo) as val_rownum,
   fec_fecha,
   cod_sociedad,
   des_tipo_almacen,
   num_correlativo,
   des_negocio,
   des_empresa,
   des_plataforma,
   des_categoria,
   cod_cat,
   des_familia,
   des_centro_desc,
   des_centro,
   des_destino_principal,
   des_negocio_s4,
   des_plataforma_s4,
   des_subplataforma,
   cod_hu,
   cod_codigo,
   cod_tipo_material,
   des_descripcion_producto,
   cod_unidad_medida_uco,
   mnt_total_uco,
   est_estado,
   des_motivo_bloqueo,
   des_comentario_bloqueo,
   mnt_ton,
   fec_vencimiento,
   val_valor_inventario,
   num_numero_ubicaciones,
   fec_em,
   est_estado_inmovilizado,
   des_grupo_tiempo_vida,
   flg_incluir_procesos_inmovilizados,
   mnt_dg_sku,
   mnt_target_dg,
   num_inv_age,
   mnt_target_inv_ave,
   num_cuadrante,
   nom_nombre,
   nom_responsable_central,
   des_accion_mes_actual,
   des_comentario,
   des_accion_plan_corp,
   nom_responsable_ejecucion,
   est_racionalizado,
   est_ejecutado,
   cod_sku,
   des_centros_final,
   cod_sku_cd,
   num_anio_racionalizado,
   des_mes_corte_de_data,
   cnt_cuadrantes,
   fec_data,
   coalesce(cod_material, '') || safe_cast(num_correlativo as STRING) as val_dbkey
from stock_inmovilizados_base;