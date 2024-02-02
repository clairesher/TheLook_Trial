view: customer_aggregates {
  derived_table: {
    sql: SELECT
          users.id  AS user_id,
          count(distinct order_id) as lifetime_orders,
          COALESCE(SUM(CASE WHEN ( order_items.status   NOT IN ('Cancelled', 'Returned') OR ( order_items.status  ) IS NULL) THEN order_items.sale_price  ELSE NULL END), 0) AS lifetime_revenue,
          min((DATE(order_items.created_at , 'America/Los_Angeles')) ) as first_order_date,
          max((DATE(order_items.created_at , 'America/Los_Angeles')) ) as latest_order_date,
          date_diff(current_date(), max((DATE(order_items.created_at , 'America/Los_Angeles')) ), DAY) as days_since_last_order,
          date_diff(current_date(), max((DATE(users.created_at , 'America/Los_Angeles')) ), DAY) as days_since_signup,
          date_diff(current_date(), max((DATE(users.created_at , 'America/Los_Angeles')) ), MONTH) as mths_since_signup
      FROM `looker-private-demo.thelook.users`  AS users
      LEFT JOIN `looker-private-demo.thelook.order_items`  AS order_items ON users.id = order_items.user_id
      where
        {% condition age_filter%} users.age {% endcondition %}
      GROUP BY
          1
      ORDER BY
          1 DESC;;
  }

  filter: age_filter {
    type: number
    default_value: "10"
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }
  dimension: lifetime_orders_cat {
    label: "Lifetime orders grouping"
    type: tier
    tiers: [1,2,3,6,10]
    style: integer
    sql: ${lifetime_orders} ;;
  }
  measure: avg_lifetime_orders {
    type: average
    sql: ${lifetime_orders} ;;
    value_format:  "0"
  }
  measure: total_lifetime_orders {
    type: sum
    sql: ${lifetime_orders} ;;
    value_format:  "0"
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
    value_format: "$#,##0.00"
  }
  measure: avg_lifetime_revenue {
    type: average
    sql: ${lifetime_revenue} ;;
    value_format: "$#,##0.00"
  }
  measure: total_lifetime_revenue {
    type: sum
    sql: ${lifetime_revenue} ;;
    value_format: "$#,##0.00"
  }

  dimension: lifetime_revenue_cat {
    label: "Lifetime revenue grouping"
    value_format: "$#,##0.00"
    case: {
      when: {
        sql: ${lifetime_revenue} < 5;;
        label: "$0.00 - $4.99"
      }
      when: {
        sql: ${lifetime_revenue} >= 5 AND ${lifetime_revenue} < 20;;
        label: "$5.00 - $19.99"
      }
      when: {
        sql: ${lifetime_revenue} >= 20 AND ${lifetime_revenue} < 50;;
        label: "$20.00 - $49.99"
      }
      when: {
        sql: ${lifetime_revenue} >= 50 AND ${lifetime_revenue} < 100;;
        label: "$50.00 - $99.99"
      }
      when: {
        sql: ${lifetime_revenue} >= 100 AND ${lifetime_revenue} < 500;;
        label: "$100.00 - $499.99"
      }
      when: {
        sql: ${lifetime_revenue} >= 500 AND ${lifetime_revenue} < 1000;;
        label: "$500.00 - $999.99"
      }
      when: {
        sql: ${lifetime_revenue} >= 1000 ;;
        label: "$1000.00 +"
      }

    }
  }

  dimension: first_order_date {
    type: date
    datatype: date
    sql: ${TABLE}.first_order_date ;;
  }

  dimension: latest_order_date {
    type: date
    datatype: date
    sql: ${TABLE}.latest_order_date ;;
  }

  dimension: days_since_last_order {
    type: number
    sql: ${TABLE}.days_since_last_order ;;
  }
  dimension: is_repeat_customer{
    label: "Repeat customer flag"
    type: yesno
    sql: lifetime_orders >1 ;;
  }

  dimension: is_active_customer {
    label: "Active customer flag"
    type: yesno
    sql:   ${TABLE}.days_since_last_order < 90;;
  }

  dimension: days_since_signup {
    type: number
    sql: ${TABLE}.days_since_signup ;;
  }



  measure: avg_days_since_signup {
    label: "Average days since signup"
    type: average
    sql: ${days_since_signup} ;;
  }

  dimension: mths_since_signup {
    label: "Months since signup"
    type: number
    sql: ${TABLE}.mths_since_signup ;;
  }
  dimension: Signup_cohort {
    label: "Signup cohorts (months)"
    type: tier
    tiers: [0,3,6,12,18,24]
    style: integer
    sql: mths_since_signup ;;
  }


  measure: avg_mths_since_signup {
    label: "Average months since signup"
    type: average
    sql: ${mths_since_signup} ;;
  }
  set: detail {
    fields: [
      user_id,
      lifetime_orders,
      lifetime_revenue,
      first_order_date,
      latest_order_date,
      days_since_last_order,
      days_since_signup,
      mths_since_signup
    ]
  }


  }
