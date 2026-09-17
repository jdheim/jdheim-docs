<p align="center">
    <a href="LICENSE" rel="noreferrer">
        <img src="https://img.shields.io/github/license/jdheim/jdheim-docs?label=License&logo=googledocs&logoColor=white" alt="License"/>
    </a>
</p>

## JDHeim Docs

Source for the [JDHeim](https://jdheim.com) Documentation.

The site is built with [Zensical](https://zensical.org).

## Prerequisites

- Python 3.10 or later
- [uv](https://docs.astral.sh/uv/) - extremely fast Python package and project manager, written in Rust

## Develop locally

Install the project's dependencies:

```bash
./scripts/uv.sh --sync
```

Start the local documentation server:

```bash
./scripts/serve.sh
```

Open <http://localhost> in a browser. Zensical rebuilds the site when documentation or configuration files change.

## Build

Create a production build with:

```bash
./scripts/build.sh
```

The generated site is written to `site/`.

## License

Copyright 2026 JDHeim.com

This project is licensed under the Apache License, Version 2.0. See the [LICENSE](LICENSE) file for full license terms.
