# If necessary, uncomment the line below to include explore_source.
# include: "thelook_connection.model.lkml"

view: train_data {
  derived_table: {
    datagroup_trigger: bqml_datagroup
    explore_source: order_items {
      column: id { field: users.id }
      column: gender { field: users.gender }
      column: age_group { field: users.age_group }
      column: city { field: users.city }
      column: lifetime_orders { field: customer_aggregates.lifetime_orders }
      column: lifetime_revenue { field: customer_aggregates.lifetime_revenue }
      column: mths_since_signup { field: customer_aggregates.mths_since_signup }
      column: first_order_date { field: customer_aggregates.first_order_date }
      column: days_since_last_order { field: customer_aggregates.days_since_last_order }
      column: is_active_customer { field: customer_aggregates.is_active_customer }
      filters: {
        field: customer_aggregates.first_order_date
        value: "2019/12/31 to 2021/01/01"
      }
    }
  }
  dimension: id {
    primary_key: yes
    description: ""
    type: number
  }
  dimension: gender {
    description: ""
  }
  dimension: age_group {
    description: ""
    type: tier
    tiers:  [0, 15, 25, 35, 50, 65]
  }
  dimension: city {
    description: ""
  }
  dimension: lifetime_orders {
    label: "Users Lifetime Orders"
    description: ""
    type: number
  }
  dimension: lifetime_revenue {
    label: "Users Lifetime Revenue"
    description: ""
    value_format: "$#,##0.00"
    type: number
  }
  dimension: mths_since_signup {
    label: "Users Months since signup"
    description: ""
    type: number
  }
  dimension: first_order_date {
    label: "Users First Order Date"
    description: ""
    type: date
  }
  dimension: days_since_last_order {
    label: "Users Days Since Last Order"
    description: ""
    type: number
  }
  dimension: is_active_customer {
    label: "Users Active customer flag (Yes / No)"
    description: ""
    type: yesno
  }
}
