#!/bin/bash
shopt -s nullglob
while IFS= read -r g; do
  echo "IOMMU Group ${g##*/}:"
  for d in "$g"/devices/*; do
    printf '\t%s\n' "$(lspci -nns "${d##*/}")"
  done
done < <(find /sys/kernel/iommu_groups/* -maxdepth 0 -type d | sort -V)
