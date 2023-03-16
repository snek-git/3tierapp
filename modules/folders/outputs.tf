output "folder_ids" {
  value = [
    [for k, v in var.folder_map : module.folders[k].ids],
    [for i in local.sub_folders1_var : module.sub_folders1[i].ids],
    [for j in local.sub_folders2_var : module.sub_folders2[j].ids],
    [for l in local.sub_folders3_var : module.sub_folders3[l].ids],
    [for a in local.sub_folders4_var : module.sub_folders4[a].ids]
  ]
}

output "names_to_ids" {
  value = zipmap(
    concat([for i in module.folders : i.name],
      [for i in module.sub_folders1 : i.name],
      [for i in module.sub_folders2 : i.name],
      [for i in module.sub_folders3 : i.name],
    [for i in module.sub_folders4 : i.name]),

    concat([for i in module.folders : i.id],
      [for i in module.sub_folders1 : i.id],
      [for i in module.sub_folders2 : i.id],
      [for i in module.sub_folders3 : i.id],
    [for i in module.sub_folders4 : i.id])
  )
}