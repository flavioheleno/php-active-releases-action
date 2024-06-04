# php-active-releases-action

This action retrieves a list of active [PHP Releases](https://www.php.net/releases/active.php).

## Outputs

### `major`

The list of major versions available, as a list of strings (`string[]`), for example:

```json
[
  "8"
]
```

### `minor`

The list of minor versions available, as a list of strings (`string[]`), for example:

```json
[
  "8.1",
  "8.2",
  "8.3"
]
```

### `patch`

The list of patch versions available, as a list of strings (`string[]`), for example:

```json
[
  "8.1.28",
  "8.2.19",
  "8.3.7"
]
```

### `release`

The list of releases available, as a list of objects (`object[]`), for example:

```json
[
  {
    "version": "8.1.28",
    "filename": "php-8.1.28.tar.gz",
    "name": "PHP 8.1.28 (tar.gz)",
    "sha256": "a2a9d853f4a4c9ff8631da5dc3a6cec5ab083ef37a214877b0240dcfcdfdefea",
    "date": "11 Apr 2024"
  },
  {
    "version": "8.2.19",
    "filename": "php-8.2.19.tar.gz",
    "name": "PHP 8.2.19 (tar.gz)",
    "sha256": "8bfdd20662b41a238a5acd84fab3e05c36a685fcb56e6d8ac18eeb87057ab2bc",
    "date": "09 May 2024"
  },
  {
    "version": "8.3.7",
    "filename": "php-8.3.7.tar.gz",
    "name": "PHP 8.3.7 (tar.gz)",
    "sha256": "2e11d10b651459a8767401e66b5d70e3b048e446579fcdeb0b69bcba789af8c4",
    "date": "09 May 2024"
  }
]
```

## Example usage

### Using "major"

```yaml
name: PHP Building
on:
  workflow_dispatch:
  schedule:
    - cron: '0 0 * * *'

jobs:
  setup:
    name: Generate build matrix
    runs-on: ubuntu-latest

    outputs:
      major: ${{ steps.releases.outputs.major }}

    steps:
      - id: releases
        name: Get PHP Releases
        uses: flavioheleno/php-active-releases-action@main

  build:
    name: Build matrix
    runs-on: ubuntu-latest
    needs: setup
    strategy:
      matrix: ${{ fromJson(needs.setup.outputs.major) }}

    steps:
      - run: echo ${{ matrix.major }}
```

### Using "minor"

```yaml
name: PHP Building
on:
  workflow_dispatch:
  schedule:
    - cron: '0 0 * * *'

jobs:
  setup:
    name: Generate build matrix
    runs-on: ubuntu-latest

    outputs:
      minor: ${{ steps.releases.outputs.minor }}

    steps:
      - id: releases
        name: Get PHP Releases
        uses: flavioheleno/php-active-releases-action@main

  build:
    name: Build matrix
    runs-on: ubuntu-latest
    needs: setup
    strategy:
      matrix: ${{ fromJson(needs.setup.outputs.minor) }}

    steps:
      - run: echo ${{ matrix.minor }}
```

### Using "patch"

```yaml
name: PHP Building
on:
  workflow_dispatch:
  schedule:
    - cron: '0 0 * * *'

jobs:
  setup:
    name: Generate build matrix
    runs-on: ubuntu-latest

    outputs:
      patch: ${{ steps.releases.outputs.patch }}

    steps:
      - id: releases
        name: Get PHP Releases
        uses: flavioheleno/php-active-releases-action@main

  build:
    name: Build matrix
    runs-on: ubuntu-latest
    needs: setup
    strategy:
      matrix: ${{ fromJson(needs.setup.outputs.patch) }}

    steps:
      - run: echo ${{ matrix.patch }}
```

### Using "release"

```yaml
name: PHP Building
on:
  workflow_dispatch:
  schedule:
    - cron: '0 0 * * *'

jobs:
  setup:
    name: Generate build matrix
    runs-on: ubuntu-latest

    outputs:
      release: ${{ steps.releases.outputs.release }}

    steps:
      - id: releases
        name: Get PHP Releases
        uses: flavioheleno/php-active-releases-action@main
        with:
          format: short

  build:
    name: Build matrix
    runs-on: ubuntu-latest
    needs: setup
    strategy:
      matrix: ${{ fromJson(needs.setup.outputs.release) }}

    steps:
      - run: echo ${{ matrix.release.version }}
```

