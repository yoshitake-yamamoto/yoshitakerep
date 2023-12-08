connection: "looker-private-demo"
label: " eCommerce"
#include: "/queries/queries*.view" # includes all queries refinements
include: "/views/**/*.view" # include all the views
#include: "/gen_ai/**/*.view" # include all the views
#include: "/dashboards/*.dashboard.lookml" # include all the views



explore: order_items {
  label: "受注・商品・顧客"
  view_name: order_items
}
