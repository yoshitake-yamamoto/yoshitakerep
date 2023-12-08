view: order_items {
  sql_table_name: looker-private-demo.ecomm.order_items ;;
  view_label: "Order Items"
  ########## IDs, Foreign Keys, Counts ###########

  dimension: id {
    label: "ID"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    value_format: "00000"
  }

  dimension: inventory_item_id {
    label: "Inventory Item ID"
    type: number
    hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: user_id {
    label: "User Id"
    type: number
    hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    label: "Count"
    type: count
  }
}
