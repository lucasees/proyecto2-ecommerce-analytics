# E-Commerce Analytics con BigQuery — Google Merchandise Store 📊

## Descripción
Análisis de datos reales de la Google Merchandise Store con SQL en BigQuery, sobre el
dataset público de Google Analytics. El objetivo es extraer insights de negocio sobre conversión, canales 
de adquisición, comportamiento por dispositivo y tendencias de ventas.

## Dataset
Google Analytics Sample Dataset (BigQuery Public Data: `bigquery-public-data.google_analytics_sample`)
- Datos de Universal Analytics, la versión de Google Analytics anterior a GA4
- Período: Agosto 2016 - Agosto 2017
- 903.653 sesiones · 714.167 visitantes únicos · 12.115 transacciones

## Herramientas
- **BigQuery** - Consultas SQL sobre el dataset de Google Analytics
- **Looker Studio** - Dashboard interactivo
- **VS Code** - Edición y organización del código SQL

## Hallazgos principales
- Ingresos totales: **$1.540.071 USD**
- Tasa de conversión general: **1,34%** (transacciones / sesiones); el **1,28%** de las sesiones termina en al menos una compra
- Ticket promedio: **$133.32 USD** por sesión con compra
- Canal más rentable: **Referral** (5,29% de conversión, con la misma definición; $651.429 de ingresos)
- Desktop genera **96% de los ingresos** vs 3.2% mobile
- Cohortes: la de **agosto 2016** registra 2,81 compras por cada 100 usuarios, aunque sale inflada por un efecto de borde (incluye a visitantes previos al inicio de los datos)
- Producto estrella: **Google Men's Zip Hoodie** ($47.636 ingresos)

## Análisis realizados
1. Resumen general del dataset
2. Facturación y conversión por canal de adquisición
3. Análisis del embudo de conversión
4. Conversión por dispositivo (desktop vs mobile vs tablet)
5. Tendencia mensual de ingresos
6. Análisis de cohortes por mes de adquisición
7. Top páginas más visitadas
8. Top productos más vendidos

## Dashboard
[Ver dashboard interactivo en Looker Studio](https://datastudio.google.com/reporting/5c01e3ab-974f-4cd7-af91-0d93c1a211b3)

contacto:
Lucas Espinosa. Data Analyst
[LinkedIn](https://linkedin.com/in/lucasespinosaa) · lucaseespinosa93@gmail.com · [github.com/lucasees](https://github.com/lucasees)

## Estructura del proyecto
- `SQL/` - Queries SQL del análisis
- `dashboard/` - Enlace al dashboard de Looker Studio

