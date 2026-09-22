/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_TMP_PBW_BLOQUEADO
  FECHA DE CREACIÓN: 21/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

delete from `{horizonte_project_id}.hzt_comercial.horizonte_tpm_pbw_bloqueado`
where des_origen = 'DE-WILSON';

insert into `{horizonte_project_id}.hzt_comercial.horizonte_tpm_pbw_bloqueado`
with base_bloqueados as (
  select distinct 
    b.cod_material_funcional, 
    b.DES_BLOQUEO, 
    a.cod_jerarquia_material as cod_jerarquia
  from `{silver_project_id}.slv_modelo_material.horizonte_material` a
  left join `{silver_project_id}.slv_modelo_material.horizonte_material_aux` b
    on a.id_material = b.id_material
  -- where DES_BLOQUEO = 'Bloqueo Total' and a.COD_TIPO_MATERIAL in ('ZFER','ZHAW')
),
base_pbw as (
  select distinct
   SAFE_CAST(NULL AS STRING) AS plan_cbp, --cod_canal as plan_cbp,
    cod_interlocutor as interlocutor,
    left(cod_producto, instr(cod_producto, '|')-2) as cod_material,
    substring(cod_producto, instr(cod_producto, '|')+2, 60) as nom_material,
    b.DES_BLOQUEO,
    b.COD_JERARQUIA, 
    CASE WHEN B.cod_material_funcional IS NULL THEN 0 ELSE 1 END AS flg_bloqueado
  from `{silver_project_id}.slv_gobierno.otc_plantilla_promocion_pbw` a
  left join base_bloqueados b 
    on left(a.cod_producto, instr(a.cod_producto, '|')-2) = b.cod_material_funcional
),
base_pbw_2 as (
  select distinct 
    cod_material, 
    plan_cbp as cod_plan_cbp, 
    a.interlocutor as cod_interlocutor, 
    des_bloqueo, 
    a.flg_bloqueado,  
    SAFE_CAST(NULL AS STRING) AS cod_jerarquia, -- j.cod_jerarquia_material,
    SAFE_CAST(NULL AS STRING) AS cod_plataforma, -- j.cod_plataforma,
    SAFE_CAST(NULL AS STRING) AS des_plataforma, -- j.des_plataforma,
    SAFE_CAST(NULL AS STRING) AS cod_subplataforma, -- j.cod_sub_plataforma,
    SAFE_CAST(NULL AS STRING) AS des_subplataforma, -- j.des_sub_plataforma,
    SAFE_CAST(NULL AS STRING) AS cod_categoria, -- j.cod_categoria,
    SAFE_CAST(NULL AS STRING) AS des_categoria, -- j.des_categoria,
    SAFE_CAST(NULL AS STRING) AS cod_familia, -- j.cod_familia,
    SAFE_CAST(NULL AS STRING) AS des_familia, -- j.des_familia,
    SAFE_CAST(NULL AS STRING) AS cod_variedad, -- j.cod_variedad,
    SAFE_CAST(NULL AS STRING) AS des_variedad, -- j.des_variedad,
    SAFE_CAST(NULL AS STRING) AS cod_presentacion, -- j.cod_presentacion,
    SAFE_CAST(NULL AS STRING) AS des_presentacion, -- j.des_presentacion,
    SAFE_CAST(NULL AS STRING) AS fec_carga -- safe_cast(j.fec_proceso as STRING)
  from base_pbw a
--  left join `{silver_project_id}.slv_modelo_material.horizonte_material_jerarquia` j 
--    on a.cod_jerarquia = j.cod_jerarquia_material
)
select
  'DE-WILSON' des_origen,
  row_number()over(order by cod_material) as val_rownum,
  'PE11' as cod_sociedad,
    cod_material,
    cod_plan_cbp,
    cod_interlocutor,
    des_bloqueo,
    flg_bloqueado,
    cod_jerarquia,
    cod_plataforma,
    des_plataforma,
    cod_subplataforma,
    des_subplataforma,
    cod_categoria,
    des_categoria,
    cod_familia,
    des_familia,
    cod_variedad,
    des_variedad,
    cod_presentacion,
    des_presentacion,
    fec_carga,
  coalesce(cod_material,'') || coalesce(cod_plan_cbp, '') as val_dbkey
from base_pbw_2;