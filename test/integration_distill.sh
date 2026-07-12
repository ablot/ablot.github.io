#!/usr/bin/env bash
set -euo pipefail

tmp_dir="$(mktemp -d)"
tmp_override="${tmp_dir}/distill-override.yml"
tmp_site="${tmp_dir}/site"

# This test needs a published distill-layout post (with giscus/mermaid/tikzjax
# enabled) to exist at /blog/2021/distill/. It doesn't assume the site keeps a
# stock demo post at that exact dated filename (a downstream site is free to
# rename/unpublish demo content), so if `_posts/distill.md` exists undated
# (unpublished) it's temporarily republished under its own `date:` front
# matter for the duration of the build, then restored afterwards.
distill_source="_posts/distill.md"
distill_post="_posts/2021-05-22-distill.md"
distill_backup="${tmp_dir}/distill.md.bak"

cleanup() {
  if [ -f "${distill_backup}" ]; then
    mv "${distill_backup}" "${distill_post}"
  elif [ -f "${distill_post}" ] && [ "${distill_post}" != "${distill_source}" ]; then
    rm -f "${distill_post}"
  fi
  rm -rf "${tmp_dir}"
}
trap cleanup EXIT

if [ "${distill_post}" != "${distill_source}" ] && [ -f "${distill_source}" ]; then
  [ -f "${distill_post}" ] && cp "${distill_post}" "${distill_backup}"
  cp "${distill_source}" "${distill_post}"
fi

cat >"${tmp_override}" <<'YAML'
giscus:
  repo: alshedivat/al-folio
  repo_id: R_kgDOExample
  category: Comments
  category_id: DIC_kwDOExample
YAML

bundle exec jekyll build --config "_config.yml,${tmp_override}" -d "${tmp_site}" >/dev/null

distill_page="${tmp_site}/blog/2021/distill/index.html"

if [ ! -f "${distill_page}" ]; then
  echo "distill page was not generated at ${distill_page}" >&2
  exit 1
fi

grep -q 'd-front-matter' "${distill_page}"
grep -q '/assets/js/distillpub/template.v2.js' "${distill_page}"
grep -q '/assets/js/distillpub/transforms.v2.js' "${distill_page}"
grep -q '/assets/js/distillpub/overrides.js' "${distill_page}"
grep -q '/assets/al_charts/js/mermaid-setup.js' "${distill_page}"
grep -q 'https://cdn.jsdelivr.net/npm/@planktimerr/tikzjax@1.0.8/dist/fonts.css' "${distill_page}"
grep -q 'https://cdn.jsdelivr.net/npm/@planktimerr/tikzjax@1.0.8/dist/tikzjax.js' "${distill_page}"
grep -q 'id="giscus_thread"' "${distill_page}"
transforms_runtime="${tmp_site}/assets/js/distillpub/transforms.v2.js"
distill_runtime="$(PATH="$HOME/.rbenv/shims:$PATH" bundle exec ruby -e 'spec = Gem.loaded_specs["al_folio_distill"]; puts(spec ? File.join(spec.full_gem_path, "assets/js/distillpub/transforms.v2.js") : "")')"
if [ -f "${distill_runtime}" ]; then
  # Prefer the packaged gem runtime for deterministic parity checks.
  transforms_runtime="${distill_runtime}"
elif [ ! -f "${transforms_runtime}" ]; then
  echo "distill transforms runtime missing at ${transforms_runtime} (and not found in installed al_folio_distill gem)" >&2
  exit 1
fi

expected_transforms_hash="70e3f488e23ec379d33a10a60311ec60b570b3b2d5f1823e9159f661c315184e"
actual_transforms_hash="$(ruby -rdigest -e 'print Digest::SHA256.file(ARGV[0]).hexdigest' "${transforms_runtime}")"
if [ "${actual_transforms_hash}" != "${expected_transforms_hash}" ]; then
  echo "unexpected distill transforms runtime hash: ${actual_transforms_hash}" >&2
  exit 1
fi

echo "distill integration checks passed"
