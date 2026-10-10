#!/usr/bin/env bash
set -euo pipefail

tmp_dir="$(mktemp -d)"
tmp_override="${tmp_dir}/comments-test-override.yml"
tmp_site="${tmp_dir}/site"

# This test needs a giscus_comments:true post and a disqus_comments:true post
# to exercise the al_comments tag. It doesn't assume any particular content
# lives in _posts (a downstream site is free to remove/rename demo posts), so
# it creates its own throwaway fixtures for the duration of the build and
# restores whatever was at those paths before (if anything) afterwards.
giscus_post="_posts/2022-02-01-giscus-comments.md"
disqus_post="_posts/2015-10-20-disqus-comments.md"
giscus_backup="${tmp_dir}/giscus-comments.md.bak"
disqus_backup="${tmp_dir}/disqus-comments.md.bak"

cleanup() {
  if [ -f "${giscus_backup}" ]; then
    mv "${giscus_backup}" "${giscus_post}"
  else
    rm -f "${giscus_post}"
  fi
  if [ -f "${disqus_backup}" ]; then
    mv "${disqus_backup}" "${disqus_post}"
  else
    rm -f "${disqus_post}"
  fi
  rm -rf "${tmp_dir}"
}
trap cleanup EXIT

[ -f "${giscus_post}" ] && cp "${giscus_post}" "${giscus_backup}"
[ -f "${disqus_post}" ] && cp "${disqus_post}" "${disqus_backup}"

cat >"${giscus_post}" <<'MD'
---
layout: post
title: Giscus comments integration fixture
giscus_comments: true
---

Throwaway fixture created by test/integration_comments.sh.
MD

cat >"${disqus_post}" <<'MD'
---
layout: post
title: Disqus comments integration fixture
disqus_comments: true
---

Throwaway fixture created by test/integration_comments.sh.
MD

cat >"${tmp_override}" <<'YAML'
giscus:
  repo: alshedivat/al-folio
  repo_id: R_kgDOExample
  category: Comments
  category_id: DIC_kwDOExample
YAML

bundle exec jekyll build --config "_config.yml,${tmp_override}" -d "${tmp_site}" >/dev/null

giscus_page="${tmp_site}/blog/2022/giscus-comments/index.html"
disqus_page="${tmp_site}/blog/2015/disqus-comments/index.html"

grep -q 'https://giscus.app/client.js' "${giscus_page}"
if grep -q 'giscus comments misconfigured' "${giscus_page}"; then
  echo "unexpected giscus misconfiguration warning in ${giscus_page}" >&2
  exit 1
fi

grep -q 'id="disqus_thread"' "${disqus_page}"
grep -q '.disqus.com/embed.js' "${disqus_page}"

echo "comments integration checks passed"
