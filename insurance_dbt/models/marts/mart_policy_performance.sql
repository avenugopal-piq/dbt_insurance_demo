WITH policy_metrics AS (
    SELECT * FROM {{ ref('int_policy_metrics') }}
)

SELECT
    policy_id,
    coverage,
    total_written_premium,
    total_written_exposure,
    CASE 
        WHEN total_written_exposure = 0 THEN NULL
        ELSE total_written_premium / total_written_exposure 
    END AS premium_per_exposure,
    transaction_count,
    earliest_effective_date,
    latest_expiration_date,
    DATEDIFF('day', earliest_effective_date, latest_expiration_date) AS policy_duration_days
FROM policy_metrics