/*
 * Copyright 2026 JDHeim.com
 * SPDX-License-Identifier: Apache-2.0
 */

const repositories = [
  {
    path: "/jdvm/",
    url: "https://github.com/jdheim/jdvm",
    name: "jdheim/jdvm",
  },
  {
    path: "/toolfetch/",
    url: "https://github.com/jdheim/toolfetch",
    name: "jdheim/toolfetch",
  },
]

function updateRepositoryLink() {
  const pagePath = `${window.location.pathname.replace(/index\.html$/, "").replace(/\/$/, "")}/`
  const repository = repositories
    .filter(({ path }) => pagePath.startsWith(path))
    .sort((left, right) => right.path.length - left.path.length)[0]
  if (!repository) {
    return undefined
  }
  for (const link of document.querySelectorAll('[data-md-component="source"]')) {
    link.href = repository.url
    link.title = `Go to ${repository.name} repository`
    link.querySelector(".md-source__repository").textContent = repository.name
  }
  return repository
}

function formatCount(value) {
  return new Intl.NumberFormat("en", {
    notation: "compact",
    maximumFractionDigits: 1,
  }).format(value)
}

function renderRepositoryFacts(facts) {
  for (const link of document.querySelectorAll('[data-md-component="source"]')) {
    const repositoryName = link.querySelector(".md-source__repository")
    repositoryName.querySelector(".md-source__facts")?.remove()

    const factList = document.createElement("ul")
    factList.className = "md-source__facts"
    for (const name of ["version", "stars", "forks"]) {
      const value = facts[name]
      if (value === undefined) {
        continue
      }
      const fact = document.createElement("li")
      fact.className = `md-source__fact md-source__fact--${name}`
      fact.textContent = typeof value === "number" ? formatCount(value) : value
      factList.append(fact)
    }
    repositoryName.append(factList)
    repositoryName.classList.add("md-source__repository--active")
  }
}

function getCachedRepositoryFacts(repository) {
  try {
    const facts = sessionStorage.getItem(`repository-facts:${repository.name}`)
    return facts ? JSON.parse(facts) : undefined
  } catch {
    return undefined
  }
}

function cacheRepositoryFacts(repository, facts) {
  try {
    sessionStorage.setItem(`repository-facts:${repository.name}`, JSON.stringify(facts))
  } catch {
    return
  }
}

async function updateRepositoryFacts(repository) {
  const cachedFacts = getCachedRepositoryFacts(repository)
  if (cachedFacts) {
    renderRepositoryFacts(cachedFacts)
    return
  }

  try {
    const [detailsResponse, releaseResponse] = await Promise.all([
      fetch(`https://api.github.com/repos/${repository.name}`),
      fetch(`https://api.github.com/repos/${repository.name}/releases/latest`),
    ])
    if (!detailsResponse.ok) {
      return
    }

    const details = await detailsResponse.json()
    const facts = {}
    if (releaseResponse.ok) {
      facts.version = (await releaseResponse.json()).tag_name
    }
    facts.stars = details.stargazers_count
    facts.forks = details.forks_count
    cacheRepositoryFacts(repository, facts)
    renderRepositoryFacts(facts)
  } catch {
    return
  }
}

function updateExternalLinks() {
  for (const link of document.querySelectorAll("a[href]")) {
    const url = new URL(link.href)
    if (
      !["http:", "https:"].includes(url.protocol) ||
      url.origin === window.location.origin
    ) {
      continue
    }
    link.target = "_blank"
    link.rel = "noopener noreferrer"
  }
}

function updateCopyrightYear() {
  for (const year of document.querySelectorAll("#copyright-year")) {
    year.textContent = new Date().getFullYear()
  }
}

document$.subscribe(function() {
  const repository = updateRepositoryLink()
  if (repository) {
    void updateRepositoryFacts(repository)
  }
  updateExternalLinks()
  updateCopyrightYear()
})
