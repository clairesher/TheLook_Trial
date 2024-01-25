# If necessary, uncomment the line below to include explore_source.
# include: "thelook_connection.model.lkml"

view: order_aggregates {
  derived_table: {
    explore_source: order_items {
      column: total_sale_price {}
      column: order_id {}
      column: count {}
    }
  }
  dimension: total_sale_price {
    description: ""
    type: number
  }
  dimension: order_id {
    description: ""
    type: number
    primary_key: yes
  }
  dimension: count {
    description: ""
    type: number
  }
  dimension: price_order_ratio {
    type:  number
    sql:  ${total_sale_price}/${count} ;;
  }
  measure: avg_ratio {
    type: average
    sql: ${price_order_ratio} ;;
  }
}
