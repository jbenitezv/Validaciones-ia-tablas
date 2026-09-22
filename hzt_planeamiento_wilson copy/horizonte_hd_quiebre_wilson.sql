/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_HD_QUIEBRE
  FECHA DE CREACIÓN: 18/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/


delete from `{horizonte_project_id}.hzt_planeamiento.horizonte_hd_quiebre` where des_origen = 'DE-WILSON'; 

insert into `{horizonte_project_id}.hzt_planeamiento.horizonte_hd_quiebre`
with  
materiales  as 
(
  select distinct a.id_material_origen as cod_material, a.cod_tipo_material, a.cod_material_funcional
  from `{silver_project_id}.slv_modelo_material.horizonte_material_aux` a
),
hd_quiebres_base as (
 select 
    q.num_mes_natural,
    q.fec_registro,
    q.cod_categoria,
    q.des_categoria,
    'PE11' as cod_sociedad,
    SAFE_CAST(NULL AS STRING) AS cod_tipo_material, --m.cod_tipo_material,
    q.des_familia,
    q.cod_material,
    q.des_material,
    q.cod_centro,
    q.des_centro,
    q.cod_duenio_marca,
    q.des_duenio_marca,
    q.cod_negocio,
    q.des_negocio,
    q.num_dia_quiebre,
    q.num_relevante_quiebre,
    q.prc_dia_quiebre,
    q.num_mes,
    q.num_dia,
    q.cod_empresa,
    q.des_empresa,
    q.num_quiebre_alicorp,
    q.num_relevante_quiebre_alicorp,
    q.num_quiebre_intradevco,
    q.num_relevante_quiebre_intradevco,
    q.des_pareto,
    q.des_centro_final,
    q.cod_sku_extendido,
    q.cod_sku,
    case  when num_quiebre_alicorp is null then null
          when num_relevante_quiebre_alicorp is null then null
          else 1 
    end flg_percent_alicorp,
    case  when num_quiebre_alicorp < 0 then 0
          when num_relevante_quiebre_alicorp < 0 then 0
          else 1
    end flg_percent_alicorp_is_positive,
    case when num_quiebre_intradevco is null then null
         when num_relevante_quiebre_intradevco is null then null
         else 1
    end flg_percent_intradevco,
    case  when num_quiebre_intradevco < 0 then 0
          when num_relevante_quiebre_intradevco < 0 then 0
          else 1
    end flg_percent_intradevco_is_positive,
    case when num_dia_quiebre is null then null
         when num_relevante_quiebre is null then null
         else 1
    end flg_percent_total,
    case  when num_dia_quiebre < 0 then 0
          when num_relevante_quiebre < 0 then 0
          else 1
    end flg_percent_total_is_positive
 from `{silver_project_id}.slv_gobierno.ptp_quiebre` q
--  left join materiales m
--  on q.cod_material = m.cod_material_funcional 
 )
select
      'DE-WILSON' as des_origen,
   row_number()over(order by  cod_categoria ) as val_rownum,
    *,
 coalesce(cod_categoria, '')  || coalesce(cod_material, '') || coalesce(cod_centro, '')   as val_dbkey
from hd_quiebres_base;