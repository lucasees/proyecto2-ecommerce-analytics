-- =============================================
-- PROYECTO 2: E-COMMERCE ANALYTICS CON GA4
-- Dataset: Google Merchandise Store
-- Herramienta: BigQuery
-- Autor: Lucas Espinosa
-- =============================================


-- =============================================
-- QUERY 1: Resumen general del dataset
-- =============================================
SELECT
    COUNT(*)                                        AS total_sesiones,
    COUNT(DISTINCT fullVisitorId)                   AS visitantes_unicos,
    SUM(totals.transactions)                        AS total_transacciones,
    ROUND(SUM(totals.transactionRevenue)/1000000,2) AS ingresos_totales_usd
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE _TABLE_SUFFIX BETWEEN '20160801' AND '20170801';


-- =============================================
-- QUERY 2: Facturacion y conversion por canal
-- =============================================
SELECT
    channelGrouping                                     AS canal,
    COUNT(*)                                            AS sesiones,
    COUNT(DISTINCT fullVisitorId)                       AS visitantes_unicos,
    SUM(totals.transactions)                            AS transacciones,
    ROUND(SUM(totals.transactionRevenue)/1000000,2)     AS ingresos_usd,
    ROUND(SUM(totals.transactions)*100.0/COUNT(*),2)    AS tasa_conversion_pct
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE _TABLE_SUFFIX BETWEEN '20160801' AND '20170801'
GROUP BY canal
ORDER BY ingresos_usd DESC;


-- =============================================
-- QUERY 3: Embudo de conversion
-- =============================================
SELECT
    COUNT(*)                                            AS sesiones_totales,
    SUM(totals.pageviews)                               AS total_pageviews,
    ROUND(SUM(totals.pageviews)/COUNT(*),1)             AS paginas_por_sesion,
    COUNTIF(totals.transactions > 0)                    AS sesiones_con_compra,
    ROUND(COUNTIF(totals.transactions>0)*100.0/
        COUNT(*),2)                                     AS tasa_conversion_pct,
    ROUND(SUM(totals.transactionRevenue)/1000000/
        COUNTIF(totals.transactions>0),2)               AS ticket_promedio_usd
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE _TABLE_SUFFIX BETWEEN '20160801' AND '20170801';


-- =============================================
-- QUERY 4: Conversion por dispositivo
-- =============================================
SELECT
    device.deviceCategory                              AS dispositivo,
    COUNT(*)                                           AS sesiones,
    COUNTIF(totals.transactions > 0)                   AS transacciones,
    ROUND(SUM(totals.transactionRevenue)/1000000,2)    AS ingresos_usd,
    ROUND(COUNTIF(totals.transactions>0)*100.0/
        COUNT(*),2)                                    AS tasa_conversion_pct
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE _TABLE_SUFFIX BETWEEN '20160801' AND '20170801'
GROUP BY dispositivo
ORDER BY ingresos_usd DESC;


-- =============================================
-- QUERY 5: Tendencia mensual de ingresos
-- =============================================
SELECT
    FORMAT_DATE('%Y-%m', PARSE_DATE('%Y%m%d', date))   AS mes,
    COUNT(*)                                            AS sesiones,
    COUNTIF(totals.transactions > 0)                    AS transacciones,
    ROUND(SUM(totals.transactionRevenue)/1000000,2)     AS ingresos_usd,
    ROUND(SUM(totals.transactionRevenue)/1000000/
        COUNTIF(totals.transactions>0),2)               AS ticket_promedio
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE _TABLE_SUFFIX BETWEEN '20160801' AND '20170801'
GROUP BY mes
ORDER BY mes;


-- =============================================
-- QUERY 6: Analisis de cohortes
-- =============================================
WITH primera_visita AS (
    SELECT
        fullVisitorId,
        FORMAT_DATE('%Y-%m',
            MIN(PARSE_DATE('%Y%m%d', date)))    AS mes_adquisicion
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
    WHERE _TABLE_SUFFIX BETWEEN '20160801' AND '20170801'
    GROUP BY fullVisitorId
),
visitas_con_cohort AS (
    SELECT
        s.fullVisitorId,
        pv.mes_adquisicion,
        FORMAT_DATE('%Y-%m',
            PARSE_DATE('%Y%m%d', s.date))       AS mes_actividad,
        SUM(s.totals.transactions)              AS transacciones
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*` s
    JOIN primera_visita pv
        ON s.fullVisitorId = pv.fullVisitorId
    WHERE s._TABLE_SUFFIX BETWEEN '20160801' AND '20170801'
    GROUP BY s.fullVisitorId, pv.mes_adquisicion, mes_actividad
)
SELECT
    mes_adquisicion,
    COUNT(DISTINCT fullVisitorId)               AS usuarios_cohorte,
    SUM(transacciones)                          AS compras_totales,
    ROUND(SUM(transacciones)*100.0/
        COUNT(DISTINCT fullVisitorId),2)        AS pct_compradores
FROM visitas_con_cohort
GROUP BY mes_adquisicion
ORDER BY mes_adquisicion;


-- =============================================
-- QUERY 7: Top paginas mas visitadas
-- =============================================
SELECT
    hits.page.pagePath                          AS pagina,
    COUNT(*)                                    AS visitas,
    COUNTIF(totals.transactions > 0)            AS sesiones_con_compra,
    ROUND(COUNTIF(totals.transactions>0)*100.0/
        COUNT(*),2)                             AS conversion_pct
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
    UNNEST(hits) AS hits
WHERE _TABLE_SUFFIX BETWEEN '20160801' AND '20170801'
    AND hits.type = 'PAGE'
GROUP BY pagina
ORDER BY visitas DESC
LIMIT 10;


-- =============================================
-- QUERY 8: Top productos mas vendidos
-- =============================================
SELECT
    p.v2ProductName                             AS producto,
    SUM(p.productQuantity)                      AS unidades_vendidas,
    ROUND(SUM(p.productRevenue)/1000000,2)      AS ingresos_usd,
    COUNT(DISTINCT fullVisitorId)               AS compradores_unicos
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
    UNNEST(hits) AS h,
    UNNEST(h.product) AS p
WHERE _TABLE_SUFFIX BETWEEN '20160801' AND '20170801'
    AND h.eCommerceAction.action_type = '6'
GROUP BY producto
ORDER BY ingresos_usd DESC
LIMIT 10;
