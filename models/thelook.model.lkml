connection: "looker-private-demo"
label: "eCommerce"
include: "/views/*.view.lkml" # include all the views

explore: order_items {
  label: "受注・商品・顧客"
  view_name: order_items
}
