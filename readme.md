# Release Management Scripts
This repository contains bash shell scripts that assist in implementing a release management strategy that is based on one release branch per minor version.

In this strategy, the `master` branch contains the latest & greatest code, and branches are created for each minor version (`vx.y`) and only patches for that release go into its minor branch.

> _TL;DR:_ This is a minor-release-per-branch strategy, and all that the scripts do is manipulate versions, create release commits & tags, create release branches, and push so that your CI/CD process can actually perform releases based on branch & tag names.
You can override certain defaults; see the `release-xxx` scripts for more information, or issue `./release xxx --help` to get usage information, where `xxx` is `nodejs`, `image`, `version`, or `chart`.

We currently support release management for
* Helm charts (`release-chart`)
* Docker images using `Dockerfile`'s `LABEL` directive with a `version=` label (`release-image`)
* Node.js projects (`release-nodejs`) using `npm` along with `package.json` (`yarn` is a TODO)
* Projects that use a plain-text `VERSION` file (by any name)

If you need to support other project types, see below for developer information.

## Overview
* The only supported source control system is [git](https://git-scm.com/).
* Version numbers are based on [Semantic Versioning](https://semver.org).
* The default prerelease suffix in `master` is `pre` (ie, `1.0.0-pre.0`), and is configurable by setting the `PRE` environment variable.
* The default prerelease suffix in release branches is `rc` for "release candidate" (ie, `1.0.0-rc.0`), and is configurable via the `RC` environment variable.
* The `master` branch always contains the latest & greatest code line.
The name of this branch is configurable via the `MASTER` environment variable.
* The name of the remote git repository is assumed to be `origin`, but is configurable via the `ORIGIN` environment variable.
* The version number at rest in your repository is _almost always_ at a prerelease level, except for the short amount of time during releases where prerelease suffixes are dropped.
* As you push bugfixes to your minor release branches, assess whether they need to be `git cherry-pick`ed into your `master` branch, or even backported to prior release branches.

## Workflow
* Create your codebase & place it under source control with `git`.
* Set your version to its initial value in the `master` branch.
  * For brand new projects, we recommend `0.1.0-pre.0`.
  * For existing projects, start with a major version greater than `0`, like `1.0.0-pre.0` or whatever you need.
* When you're ready to do your first "alpha", prerelease from `master` with the command `./release xxx pre` in the `master` branch.
  * This will create tags & commits for your prerelease & push them, whereupon your CI/CD pipeline should kick in and actually perform your release workflow.  This is independent of your CI/CD provider and is left to you.
* When you're _feature complete_, but not necessarily _bug-free_, you can create your release branch with an initial "release candidate" from the `master` branch with `./release xxx rc`.
  * This will create a release branch in the format `vx.y` where `x` is your `master` branch's current major version and `y` is the minor version.  The initial version in the `vx.y` branch will have the suffix `-rc.0`, which will be released, then it will be immediately bumped to `-rc.1` in preparation for your next release candidate.
  * As you fix bugs in your release candidate, make sure to assess whether they need to be backported to `master`; `git cherry-pick` is a simple tool with which to do that.
* When you're _sufficiently bug-free_ in your release branch to release to production, as agreed upon by your development team, QA team, and customers or customer advocates, you can perform a minor release in that branch with `./release xxx minor`.
  * This will result in release `vx.y.0`, and the script will bump your prerelease number in the release branch to `x.y.1-rc.0`, where `x` & `y` are your major & minor version numbers, respectively.
  * You can continue fixing bugs in the release branch & possibly merging them back to `master` or even older release branches as you see fit.
  * You can then indefinitely release patches from the release branch with `./release xxx patch` or prereleases with `./release xxx rc`.
* In parallel after you've cut a release branch, you can continue doing work in `master` for your next minor release, `vx.z` where `z` is `y + 1`.

## Running Natively
You need to have `bash` with `git` & `docker` installed in order to run the scripts natively.
You'll also need the technology-specific tools, like `npm` if you're using `nodejs`.

## Running via Docker
You can also forgo all dependencies except `docker` and use this strategy via its Docker containers, as these scripts have been Dockerized under the `scispike` organization on [Docker Hub](https://hub.docker.com).
For example, see https://hub.docker.com/r/scispike/release.

All you really have to do is map a volume containing the root of your git repo to `/gitrepo` and set the `EMAIL` environment variable.
You might also want to include other environment variables supported by git; see https://git-scm.com/book/en/v2/Git-Internals-Environment-Variables.
If your current directory _is_ the root of your git repo:
```
$ docker run --rm -i -v "$PWD:/gitrepo" -e EMAIL=you@example.com scispike/release xxx pre # or rc, minor, patch, ...
```
Just replace `xxx` above with `image`, `chart`, `nodejs`, `version`, or whatever else we support in the future.

## For Developers of This Module
* This project Eats Its Own Dog Food™.
It uses a plaintext `VERSION` file to store its version.
Use the script `./release-this <level>` to release it, where `<level>` is `pre`, `rc`, `minor`, `patch`, or `major`.
* `./release` is basically an abstract function that implements the release workflow, but needs `getVersion`, `setVersion` and `usage_xxx` functions to exist at runtime for the particular technology being used.
`./release` looks for a file called `./release-$1` (where `$1` is the value of the first argument given) & sources it, which provides said functions.
Valid values for `$1`, initially, are `chart` for Helm Charts, `image` for Docker images, `nodejs` for Node.js projects using `npm`, and `version` for projects that use a simple text file called `VERSION`, but may increase over time.
* Tests are in `test/`
  * Run `test/test-all.sh`
  * There needs to be (more) assertions in the tests, and we need better saddy path coverage.
* To add a technology, copy & paste an existing one:
  * Look for a `release-xxx` script & a `test/xxx` directory from an existing release technology `xxx`, then remember to
  * update `test/test-all.sh` to add your new type to those tested
* To release this release script, this project Eats Its Own Dog Food™:
  * `./release-this level` where `level` is the release level (`pre`, `rc`, ...)

> NOTE: this repo now releases all technologies together under a single release, and the prior Docker images should be considered deprecated.
