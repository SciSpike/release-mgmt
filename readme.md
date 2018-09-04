# Release Management Scripts
This repository contains shell (`sh`) scripts that assist in implementing a release management strategy that is based on one release branch per minor version.
In this strategy, branches are created for each minor version (`vx.y`) and all patches for that release go into its minor branch.

> _TL;DR:_ This is a minor-release-per-branch strategy, and all that the scripts do is create release commits & tags and push so that your CI/CD process can actually perform releases based on branch & tag names.

We currently support release management for
* Helm charts (`release-chart`)
* Docker images released via codefresh.io (`release-image-codefresh`)
* Node.js projects (`release-nodejs`)
* Projects that use a plain-text `VERSION` file (by any name)

Others can be added via copy/paste/massage provided your version information is stored in files that can be processed on the command line (see below).

## Overview
* The only supported source control system is [git](https://git-scm.com/).
* Version numbers are based on [Semantic Versioning](https://semver.org).
* The prerelease suffix in `master` is `pre` (ie, `1.0.0-pre.0`).
* The prerelease suffix in release branches is `rc` for "release candidate" (ie, `1.0.0-rc.0`).
* The `master` branch always contains the latest & greatest code line.
* The version number in your codebase is almost always at a prerelease level, except for the short amount of time during releases where prerelease suffixes are dropped.
* As you push bugfixes to your minor release branches, assess whether they need to be `git cherry-pick`ed into your `master` branch, or even backported to prior release branches.

## Workflow
* Create your codebase & place it under source control with `git`.
* Set your version to its initial value in the `master` branch.
  * For brand new projects, we recommend `0.1.0-pre.0`.
  * For existing projects, start with a major version greater than `0`, like `1.0.0-pre.0` or whatever you need.
* When you're ready to do your first "alpha", prerelease from `master` with the command `./release-xxx pre` in the `master` branch.
  * This will create tags & commits for your prerelease & push them, whereupon your CI/CD pipeline should kick in and actually perform your release workflow.
* When you're feature complete, but not necessarily bug-free, you can cut your release branch with a "release candidate" from the `master` branch with `./release-xxx rc`.
  * This will create a release branch named `vx.y` where `x` is your `master` branch's current major version and `y` is the minor version.  The initial version in the `vx.y` branch will have the suffix `-rc.0`, which will be released, then it will be immediately bumped to `-rc.1` in preparation for your next release candidate.
  * As you fix bugs in your release candidate, make sure to assess whether they need to be merged back to `master`; `git cherry-pick` is a simple tool with which to do that.
* When you're sufficiently bug-free in your release branch, you can perform a minor release in that branch with `./release-xxx minor`.
  * This will result in release `vx.y.0`, then bump your prerelease number in the branch to `x.y.1-rc.0`.
  * You can continue fixing bugs in the release branch & possibly merging them back to `master` as you see fit.
  * You can then indefinitely release patches from the release branch with `./release-xxx patch` or prereleases with `./release-xxx rc`.
* In parallel after you've cut a release branch, you can continue doing work in `master` for your next minor release, `vx.z` where `z` is `y + 1`.

## Running Natively
You need to have a Unix-like system with `git` & `docker` installed.
You can even reference the raw script content in your own scripts in order to stay up to date if you'd like to, piping them to `sh` for execution (if you trust doing that):
```
$ VERSION=master \curl -sSL \
https://raw.githubusercontent.com/SciSpike/release-mgmt/$VERSION/release-xxx | \
sh -s -- pre # or rc, minor, ...`
```

## Running via Docker
You can also forgo all dependencies except `docker` and use this strategy via its Docker containers, as these scripts have been Dockerized under the `scispike` organization on [Docker Hub](https://hub.docker.com).
For example, see https://hub.docker.com/r/scispike/release-nodejs & similar Docker repositories.

All you really have to do is map a volume containing the root of your git repo to `/gitrepo` and set the `EMAIL` environment variable.
You might also want to include other environment variables supported by git; see https://git-scm.com/book/en/v2/Git-Internals-Environment-Variables.
If your current directory _is_ the root of your git repo:
```
$ docker run --rm -i -v "$PWD:/gitrepo" -e EMAIL=you@example.com scispike/release-xxx pre # or rc, minor, patch, ...
```
Just replace `xxx` above with `image-codefresh`, `chart`, `nodejs`, `version`, or whatever else we support in the future.

## For Developers of This Module
* Tests are in `test/`
  * Run `test/test-all.sh`
* Copy & paste an existing `release-xxx`, `xxx.Dockerfile`, `VERSION-xxx`, & `test/xxx` from an existing release script to make a new one, then remember to
  * update `test/test-all.sh` to add your new type to those tested
  * go create a Docker Hub repo called `scispike/release-xxx` similar to an existing one
* To release a particular type of release script:
  * `./release xxx level` where `xxx` is your type (`nodejs`, `version`, ...) & `level` is the release level (`pre`, `rc`, ...)

> NOTE: this is a monorepo, so tags & branches are prefixed with types in order to distinguish them from one another!
The Docker Hub build settings for the various repositories leverage this to only publish what's necessary for that respective repository.
