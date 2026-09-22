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
    q.fec_registro AS num_dia_natural,
    q.cod_categoria AS id_categoria,
    q.des_categoria,
    'PE11' as cod_sociedad,
    SAFE_CAST(NULL AS STRING) AS cod_tipo_material, --m.cod_tipo_material,
    q.des_familia,
    q.cod_material AS id_material,
    q.des_material,
    q.cod_centro AS id_centro,
    q.des_centro,
    -- q.cod_duenio_marca AS des_duenio_marca, -- Comentado: ya hay des_duenio_marca en pos 14 (datos correctos)
    q.des_duenio_marca,
    SAFE_CAST(NULL AS STRING) AS des_duenio_descripcion,
    q.cod_negocio AS id_negocio,
    q.des_negocio,
    q.num_dia_quiebre,
    q.num_relevante_quiebre AS num_relev_quiebre,
    q.prc_dia_quiebre,
    q.num_mes,
    q.num_dia,
    q.cod_empresa AS id_empresa,
    q.des_empresa,
    q.num_quiebre_alicorp AS des_alicorp,
    q.num_relevante_quiebre_alicorp AS num_relev_quie_alicorp,
    q.num_quiebre_intradevco AS des_intradevco,
    q.num_relevante_quiebre_intradevco AS num_relev_quie_itdc,
    q.des_pareto,
    q.des_centro_final,
    q.cod_sku_extendido AS cod_sku,
    q.cod_sku AS cod_sku_cd,
    case  when num_quiebre_alicorp is null then null
          when num_relevante_quiebre_alicorp is null then null
          else TRUE
    end as flg_percent_alicorp,
    case  when num_quiebre_alicorp < 0 then FALSE
          when num_relevante_quiebre_alicorp < 0 then FALSE
          else TRUE
    end as flg_percent_alicorp_is_positive,
    case when num_quiebre_intradevco is null then null
         when num_relevante_quiebre_intradevco is null then null
         else TRUE
    end as flg_percent_intradevco,
    case  when num_quiebre_intradevco < 0 then FALSE
          when num_relevante_quiebre_intradevco < 0 then FALSE
          else TRUE
    end as flg_percent_intradevco_is_positive,
    case when num_dia_quiebre is null then null
         when num_relevante_quiebre is null then null
         else TRUE
    end as flg_percent_total,
    case  when num_dia_quiebre < 0 then FALSE
          when num_relevante_quiebre < 0 then FALSE
          else TRUE
    end as flg_percent_total_is_positive
 from `{silver_project_id}.slv_gobierno.ptp_quiebre` q
--  left join materiales m
--  on q.cod_material = m.cod_material_funcional 
 )
select
      'DE-WILSON' as des_origen,
   row_number()over(order by  cod_categoria ) as val_rownum,
    num_mes_natural,
    num_dia_natural,
    id_categoria,
    des_categoria,
    cod_sociedad,
    cod_tipo_material,
    des_familia,
    id_material,
    des_material,
    id_centro,
    des_centro,
    des_duenio_marca,
    des_duenio_descripcion,
    id_negocio,
    des_negocio,
    num_dia_quiebre,
    num_relev_quiebre,
    prc_dia_quiebre,
    num_mes,
    num_dia,
    id_empresa,
    des_empresa,
    des_alicorp,
    num_relev_quie_alicorp,
    des_intradevco,
    num_relev_quie_itdc,
    des_pareto,
    des_centro_final,
    cod_sku,
    cod_sku_cd,
    flg_percent_alicorp,
    flg_percent_alicorp_is_positive,
    flg_percent_intradevco,
    flg_percent_intradevco_is_positive,
    flg_percent_total,
    flg_percent_total_is_positive,
 coalesce(cod_categoria, '')  || coalesce(cod_material, '') || coalesce(cod_centro, '')   as val_dbkey
from hd_quiebres_base;