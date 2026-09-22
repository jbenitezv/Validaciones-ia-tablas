/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_TMP_ARCHIVO_DEMANDA
  FECHA DE CREACIÓN: 18/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

delete from `{horizonte_project_id}.hzt_comercial.horizonte_tpm_archivo_demanda`
where des_origen = 'DE-WILSON';

insert into `{horizonte_project_id}.hzt_comercial.horizonte_tpm_archivo_demanda`
with categorias as (
  select
    cod_categoria
  from `{silver_project_id}.slv_gobierno.otc_categoria_promocion`
),
base_demanda as (
  select distinct
    SUBSTR(des_negocio, 1, STRPOS(des_negocio, '-') - 1) as cod_negocio,
    substring(des_negocio, instr(des_negocio, '-') + 1, length(a.des_categoria)) as des_negocio,
    case 
      when substring(des_negocio, instr(des_negocio, '-') + 1, length(a.des_categoria)) like '%AASS%' then 'CMP'
      else 'B2B'
    end as negocio,  
    SUBSTR(a.des_categoria, 1, STRPOS(a.des_categoria, '-') - 1) as cod_categoria,
    substring(a.des_categoria, instr(a.des_categoria, '-') + 1, length(a.des_categoria)) as des_categoria,
    SUBSTR(a.des_familia, 1, STRPOS(a.des_familia, '-') - 1) as cod_familia,
    substring(a.des_familia, instr(a.des_familia, '-') + 1, length(a.des_familia)) as des_familia,
    SUBSTR(a.des_producto, 1, STRPOS(a.des_producto, '-') - 1) as cod_material,
    substring(a.des_producto, instr(a.des_producto, '-') + 1, length(a.des_producto)) as nom_material,
    SUBSTR(a.des_oficina_venta_s4h, 1, STRPOS(a.des_oficina_venta_s4h, '-') - 1) as cod_oficina_ventas,
    substring(a.des_oficina_venta_s4h, instr(a.des_oficina_venta_s4h, '-') + 1, length(a.des_oficina_venta_s4h)) as des_oficina_ventas,
    SUBSTR(a.des_grupo_vendedor_s4h, 1, STRPOS(a.des_grupo_vendedor_s4h, '-') - 1) as cod_grupo_vendedores,
    substring(a.des_grupo_vendedor_s4h, instr(a.des_grupo_vendedor_s4h, '-') + 1, length(a.des_grupo_vendedor_s4h)) as des_grupo_vendedores,
    case 
      when a.des_grupo_precio = '-' or a.des_grupo_precio = '(None)' then null
      else SUBSTR(a.des_grupo_precio, 1, STRPOS(a.des_grupo_precio, '-') - 1) 
    end as cod_grupo_precios,
    substring(a.des_grupo_precio, instr(a.des_grupo_precio, '-') + 1, length(a.des_grupo_precio)) as des_grupo_precios,
    SUBSTR(a.des_zona_cliente, 1, STRPOS(a.des_zona_cliente, '-') - 1) as cod_zona_clientes,
    substring(a.des_zona_cliente, instr(a.des_zona_cliente, '-') + 1, length(a.des_zona_cliente)) as des_zona_clientes,
    SAFE_CAST(NULL AS STRING) AS categoria, -- j.des_categoria as categoria,
    SAFE_CAST(NULL AS STRING) AS familia, -- j.des_familia as familia,
    SAFE_CAST(NULL AS STRING) AS gramaje, -- j.des_presentacion as gramaje,
    num_volumen_mes_actual as mes_anterior,
    coalesce(num_volumen_mes_siguiente,0) as mes_actual, 
    abs((coalesce(num_volumen_mes_siguiente,0)-num_volumen_mes_actual)) as diferencia_mes,
    FORMAT_DATE('%B-%Y', DATE_ADD(CURRENT_DATE(), INTERVAL 1 MONTH)) as mes 
  from `{silver_project_id}.slv_gobierno.otc_tpm_tonelada` a
  left join `{silver_project_id}.slv_modelo_material.horizonte_material_aux` ma
      on left(des_producto, instr(des_producto, '-') - 1) = ma.cod_material_funcional
  left join `{silver_project_id}.slv_modelo_material.horizonte_material` m
    on ma.id_material=m.id_material
--  left join `{silver_project_id}.slv_modelo_material.horizonte_material_jerarquia` j
--    on m.cod_jerarquia_material=j.cod_jerarquia_material
--  left join categorias c 
--    on concat(j.COD_PLATAFORMA,j.cod_sub_plataforma,j.cod_categoria) = c.cod_categoria
  where des_ratio = 'BASELINE'
--  and c.cod_categoria is not null 
),
base_demanda_final as (
  select distinct
    cod_negocio,
    des_negocio,
    negocio as val_subdominio,  
    cod_categoria,
    des_categoria,
    cod_familia,
    des_familia,
    cod_material,
    nom_material,
    cod_oficina_ventas as cod_oficina_venta,
    des_oficina_ventas as des_oficina_venta,
    cod_grupo_vendedores as cod_grupo_vendedor,
    des_grupo_vendedores as des_grupo_vendedor,
    cod_grupo_precios as cod_grupo_precio,
    des_grupo_precios as des_grupo_precio,
    cod_zona_clientes as cod_zona_cliente,
    des_zona_clientes as des_zona_cliente,
    categoria as val_categoria, 
    familia as val_familia,
    gramaje as des_gramaje,
    mes_anterior as num_mes_anterior,
    mes_actual as num_mes_actual, 
    diferencia_mes as num_diferencia_mes,
    nom_mes,
    case 
      when a.des_grupo_vendedores like '%CENCOSUD%' then 'CENCOSUD'
      when des_grupo_vendedores like '%TOTTUS%' then 'TOTTUS'
      when des_grupo_vendedores like '%SPSA%' then 'SUPERMERCADOS PERUANOS'
      when a.des_grupo_precios = 'Supermercados' and a.des_grupo_vendedores not in ('PE-CM-CENCOSUD','PE-CM-SPSA','PE-CM-TOTTUS') then 'OTROS'
      when a.des_grupo_precios = 'Dist.Exclu.Mayor' then 'DIST.EXCLU.MAYOR'
      when a.des_grupo_precios = 'Dist.Exclu.Minor' then 'DIST.EXCLU.MINOR'
      when a.des_grupo_precios = 'Dist.No.Exclu.Mayor' then 'DIST.NO.EXCLU.MAYOR'
      when a.des_grupo_precios = 'Dist.No.Exclu.Minor' then 'DIST.NO.EXCLU.MINOR'
      when a.des_grupo_precios = 'Ferreterías' then 'FERRETERÍAS'
      when a.des_grupo_precios = 'Gastronomía' then 'GASTRONOMÍA'
      when a.des_grupo_precios = 'Industrias' then 'INDUSTRIAS'
      when a.des_grupo_precios = 'Mayoristas' then 'MAYORISTAS'
      when a.des_grupo_precios = 'MiniMark./Estac.Serv' then 'MINIMARKETS TRADICIONAL'
      when a.des_grupo_precios = 'Panifi. Industr.' then 'PANIFI. INDUSTR.'
      when a.des_grupo_precios = 'Panificación' then 'PANIFICACIÓN'
      else 'OTROS' 
    end as nom_cliente, 
    case
      when a.des_grupo_vendedores in ('PE-CM-CENCOSUD','PE-CM-SPSA','PE-CM-TOTTUS') then 'Moderno'
      else 'Tradicional'
    end as tip_canal
  from base_demanda a
)
select 
  'DE-WILSON' des_origen,
  row_number()over(order by cod_material, cod_negocio, des_negocio) as val_rownum,
  'PE11' as cod_sociedad,
  cod_negocio,
  des_negocio,
  val_subdominio,
  cod_categoria,
  des_categoria,
  cod_familia,
  des_familia,
  cod_material,
  nom_material,
  cod_oficina_venta,
  des_oficina_venta,
  cod_grupo_vendedor,
  des_grupo_vendedor,
  cod_grupo_precio,
  des_grupo_precio,
  cod_zona_cliente,
  des_zona_cliente,
  val_categoria,
  val_familia,
  des_gramaje,
  num_mes_anterior,
  num_mes_actual,
  num_diferencia_mes,
  periodo,
  nom_cliente,
  tip_canal,
  coalesce(cod_material,'') || coalesce(cod_negocio,'') || coalesce(cod_oficina_venta,'') || coalesce(cod_grupo_vendedor,'') || coalesce(des_grupo_vendedor,'') || coalesce(cod_grupo_precio,'') || coalesce(cod_zona_cliente,'') as val_dbkey
from base_demanda_final;