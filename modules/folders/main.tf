locals {

  sub_folders1_var = compact(
    flatten([for k, i in var.folder_map : length(i) == 0 ? [] : [
      for ip1, op1 in i : join("=1>", [k, ip1])
  ]]))
  sub_folders2_var = compact(
    flatten([for k, i in var.folder_map : length(i) == 0 ? [] : [
      for ip1, op1 in i : length(op1) == 0 ? [] : [
      for ip2, op2 in op1 : join("=2>", [join("=1>", [k, ip1]), ip2])]
  ]]))
  sub_folders3_var = compact(
    flatten([for k, i in var.folder_map : length(i) == 0 ? [] : [
      for ip1, op1 in i : length(op1) == 0 ? [] : [
        for ip2, op2 in op1 : length(op2) == 0 ? [] : [
          for ip3, op3 in op2 : join(
        "=3>", [join("=2>", [join("=1>", [k, ip1]), ip2]), ip3])]
  ]]]))
  sub_folders4_var = compact(
    flatten([for k, i in var.folder_map : length(i) == 0 ? [] : [
      for ip1, op1 in i : length(op1) == 0 ? [] : [
        for ip2, op2 in op1 : length(op2) == 0 ? [] : [
          for ip3, op3 in op2 : length(op3) == 0 ? [] : [
            for ip4, op4 in op3 : join(
          "=4>", [join("=3>", [join("=2>", [join("=1>", [k, ip1]), ip2]), ip3]), ip4])]
  ]]]]))

}

module "folders" {
  source   = "./module/"
  for_each = var.folder_map
  parent   = "organizations/${var.org_id}"
  names    = each.key[*]
}

module "sub_folders1" {
  source   = "./module/"
  for_each = toset(local.sub_folders1_var)
  parent   = module.folders[element(split("=1>", each.value), 0)].id
  names    = [element(split("=1>", each.value), 1)]
}


module "sub_folders2" {
  source   = "./module/"
  for_each = toset(local.sub_folders2_var)
  parent   = module.sub_folders1[element(split("=2>", each.value), 0)].id
  names    = [element(split("=2>", each.value), 1)]
}

module "sub_folders3" {
  source   = "./module/"
  for_each = toset(local.sub_folders3_var)
  parent   = module.sub_folders2[element(split("=3>", each.value), 0)].id
  names    = [element(split("=3>", each.value), 1)]
}

module "sub_folders4" {
  source   = "./module/"
  for_each = toset(local.sub_folders4_var)
  parent   = module.sub_folders3[element(split("=4>", each.value), 0)].id
  names    = [element(split("=4>", each.value), 1)]
}