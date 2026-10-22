WITH staging AS (
    SELECT * FROM {{ ref('stg_walmart_sales') }}
),
ventas_mensuales AS (
    SELECT
        DATE_TRUNC('month', fecha) AS mes,
        id_tienda,
        SUM(ventas_semanales) AS total_ventas,
        AVG(temperatura) AS temp_promedio,
        AVG(precio_combustible) AS combustible_promedio,
        AVG(desempleo) AS desempleo_promedio
    FROM staging
    GROUP BY 1, 2
)
SELECT * FROM ventas_mensuales