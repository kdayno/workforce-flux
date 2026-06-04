-- Explicit cast on calendar_year strips any trailing ".0" that ECharts
-- otherwise introduces when rendering a numeric column on a categorical
-- x-axis. split_part keeps everything before the first ".", so 2011 stays
-- 2011 even if the value arrives as 2011.0 from intermediate type coercion.
select
    month_start,
    split_part(cast(calendar_year as varchar), '.', 1) as calendar_year,
    active_headcount,
    hires,
    terminations,
    net_headcount_change,
    separations_ttm,
    avg_headcount_ttm,
    rolling_12m_turnover_rate
from mart_headcount_monthly
