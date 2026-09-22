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
,cuadrante_contador AS (
  SELECT
    cod_sku,
    COUNT(DISTINCT flg_cuadrante) AS cuadrante_contador
  FROM `{silver_project_id}.slv_gobierno.ptp_stock_inmovilizado`
  GROUP BY cod_sku
)
,stock_inmovilizados_base as (
 select 
  a.fec_registro,
  'PE11' as cod_sociedad,
  a.cod_tipo_almacen,
  a.num_correlativo,
  a.cod_negocio,
  a.des_empresa,
  a.des_plataforma,
  a.des_categoria,
  a.cod_categoria,
  a.des_familia,
  a.des_centro,
  a.cod_centro,
  a.des_destino_principal,
  a.des_negocio_s4,
  a.des_plataforma_s4,
  a.des_plataforma_s4,
  a.des_hu,
  a.cod_material,
  SAFE_CAST(NULL AS STRING) AS cod_tipo_material, --m.cod_tipo_material,
  a.des_material,
  a.cod_unidad_medida_comercial,
  a.mnt_total_comercial,
  a.est_registro,
  a.des_motivo_bloqueo,
  a.des_comentario_bloqueo,
  a.mnt_tonelada,
  a.fec_vencimiento,
  a.mnt_inventario,
  a.mnt_ubicacion,
  a.fec_registro2,
  a.est_inmovilizado,
  a.est_tiempo_vida,
  a.flg_proceso_inmovilizado,
  a.mnt_sku,
  a.mnt_objetivo,
  a.num_edad_inventario,
  a.mnt_objetivo_edad_inventario,
  a.flg_cuadrante,
  a.nom_responsable,
  a.nom_responsable_central,
  a.des_accion_mes_actual,
  a.des_comentario,
  a.des_accion_plan,
  a.des_responsable_ejecucion,
  a.flg_racionalizado,
  a.est_ejecutado,
  a.des_sku,
  a.des_centro_final,
  a.cod_sku,
  a.num_anio_racionalizado,
  a.des_mes,
  coalesce(cc.cuadrante_contador, 0) as cant_cuadrantes,
  a.fec_informacion
 from `{silver_project_id}.slv_gobierno.ptp_stock_inmovilizado` a
--  left join materiales  m
--  on a.cod_material = m.cod_material_funcional
 left join cuadrante_contador cc 
 on a.cod_sku = cc.cod_sku
 )
select
   'DE-WILSON' as des_origen, 
   row_number()over(order by num_correlativo) as val_rownum,
   *,
   coalesce(cod_material, '') || safe_cast(num_correlativo as STRING) as val_dbkey
from stock_inmovilizados_base;